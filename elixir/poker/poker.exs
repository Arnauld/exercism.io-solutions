defmodule Poker do
  @jack 11
  @queen 12
  @king 13
  @ace 14

  @card_max 14

  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """
  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands) do
    [first | others] =
      hands
      |> Enum.map(&parse_cards/1)

    compare_and_filter([first], others)
    |> Enum.reverse()
    |> Enum.map(&cards_to_string/1)
  end

  defp parse_cards(cards), do: cards |> Enum.map(&parse_card/1)

  defp parse_card(card_as_string) do
    [_, num, color] = Regex.run(~r/(.+)([HSCD])/, card_as_string)
    {parse_card_num(num), color}
  end

  defp parse_card_num("J"), do: @jack
  defp parse_card_num("Q"), do: @queen
  defp parse_card_num("K"), do: @king
  defp parse_card_num("A"), do: @ace
  defp parse_card_num(num_as_string), do: String.to_integer(num_as_string)

  defp cards_to_string(cards), do: cards |> Enum.map(&card_to_string/1)
  defp card_to_string({@jack, color}), do: "J#{color}"
  defp card_to_string({@queen, color}), do: "Q#{color}"
  defp card_to_string({@king, color}), do: "K#{color}"
  defp card_to_string({@ace, color}), do: "A#{color}"
  defp card_to_string({num, color}), do: "#{num}#{color}"

  defp compare_and_filter(refs, []), do: refs

  defp compare_and_filter(refs = [ref | _], [other | others]) do
    case compare(ref, other) do
      c when c > 0 ->
        compare_and_filter(refs, others)

      c when c < 0 ->
        compare_and_filter([other], others)

      _ ->
        compare_and_filter([other | refs], others)
    end
  end

  defmacro otherwise(delta, expr) do
    quote do
      case unquote(delta) do
        0 ->
          unquote(expr)

        _ ->
          unquote(delta)
      end
    end
  end

  defp compare(cards1, cards2) do
    group1 = cards1 |> group_by_num()
    group2 = cards2 |> group_by_num()
    sorted1 = cards1 |> sort_cards_by_num()
    sorted2 = cards2 |> sort_cards_by_num()

    compare_straight_flush(sorted1, sorted2)
    |> otherwise(compare_four_of_a_kind(group1, group2))
    |> otherwise(compare_fullhouse(group1, group2))
    |> otherwise(compare_straight(sorted1, sorted2))
    |> otherwise(compare_set(group1, group2))
    |> otherwise(compare_pairs(group1, group2))
    |> otherwise(raw_score(cards1) - raw_score(cards2))
  end

  defp compare_straight_flush(sorted1, sorted2) do
    straight1? = sorted1 |> straight?()
    straight2? = sorted2 |> straight?()
    flush1? = sorted1 |> flush?()
    flush2? = sorted2 |> flush?()

    straight_flush1? = straight1? and flush1?
    straight_flush2? = straight2? and flush2?

    cond do
      straight_flush1? and straight_flush2? ->
        0

      straight_flush1? ->
        +1

      straight_flush2? ->
        -1

      true ->
        0
    end
  end

  defp compare_four_of_a_kind(group1, group2) do
    four_of_a_kind1 = group1 |> Map.get(4, [])
    four_of_a_kind2 = group2 |> Map.get(4, [])
    four_of_a_kind1? = four_of_a_kind1 |> length() > 0
    four_of_a_kind2? = four_of_a_kind2 |> length() > 0

    cond do
      four_of_a_kind1? and four_of_a_kind2? ->
        [v1] = four_of_a_kind1
        [v2] = four_of_a_kind2
        v1 - v2

      four_of_a_kind1? ->
        +1

      four_of_a_kind2? ->
        -1

      true ->
        0
    end
  end

  defp compare_fullhouse(group1, group2) do
    pairs1? = group1 |> Map.get(2, []) |> length() > 0
    pairs2? = group2 |> Map.get(2, []) |> length() > 0
    three_of_a_kind1? = group1 |> Map.get(3, []) |> length() > 0
    three_of_a_kind2? = group2 |> Map.get(3, []) |> length() > 0

    fullhouse1? = pairs1? and three_of_a_kind1?
    fullhouse2? = pairs2? and three_of_a_kind2?

    cond do
      fullhouse1? and fullhouse2? ->
        0

      fullhouse1? ->
        +1

      fullhouse2? ->
        -1

      true ->
        0
    end
  end

  defp compare_straight(sorted1, sorted2) do
    straight1 = sorted1 |> straight?()
    straight2 = sorted2 |> straight?()
    flush1 = sorted1 |> flush?()
    flush2 = sorted2 |> flush?()

    cond do
      (flush1 and flush2) or (!flush1 and !flush2) ->
        cond do
          straight1 and straight2 ->
            score_nums(sorted1 |> Enum.map(&num_of_card/1) |> reevaluate_ace_on_straight()) -
              score_nums(sorted2 |> Enum.map(&num_of_card/1) |> reevaluate_ace_on_straight())

          straight1 ->
            +1

          straight2 ->
            -1

          true ->
            0
        end

      flush1 ->
        +1

      flush2 ->
        -1
    end
  end

  defp reevaluate_ace_on_straight([2, 3, 4, 5, @ace]), do: [1, 2, 3, 4, 5]
  defp reevaluate_ace_on_straight(card_nums), do: card_nums

  defp sort_cards_by_num(cards) do
    cards |> Enum.sort(fn {n1, _}, {n2, c} -> n1 <= n2 end)
  end

  defp num_of_card({n, _}), do: n

  defp compare_set(group1, group2) do
    set1 = group1 |> Map.get(3, [])
    set2 = group2 |> Map.get(3, [])

    (length(set1) - length(set2))
    |> otherwise(score_nums(set1) - score_nums(set2))
  end

  defp compare_pairs(group1, group2) do
    pairs1 = group1 |> Map.get(2, [])
    pairs2 = group2 |> Map.get(2, [])

    (length(pairs1) - length(pairs2))
    |> otherwise(score_nums(pairs1) - score_nums(pairs2))
  end

  defp group_by_num(cards) do
    cards
    |> Enum.group_by(fn {n, c} -> n end)
    |> Enum.to_list()
    |> Enum.map(fn {n, cards} -> {length(cards), n} end)
    |> Enum.group_by(fn {nb, n} -> nb end, fn {nb, n} -> n end)
  end

  defp raw_score(cards) do
    cards
    |> Enum.map(fn {n, c} -> n end)
    |> score_nums()
  end

  defp score_nums(nums) do
    nums
    |> Enum.sort()
    |> Enum.zip(0..4)
    |> Enum.map(fn {n1, n2} -> n1 * :math.pow(@card_max, n2) end)
    |> Enum.sum()
    |> round()
  end

  defp flush?(cards) do
    nb_colors =
      cards
      |> Enum.map(fn {n, c} -> c end)
      |> Enum.uniq()
      |> length()

    nb_colors == 1
  end

  defp straight?([{n, _}, {np1, _}, {np2, _}, {np3, _}, {np4, _}])
       when np1 == n + 1 and np2 == n + 2 and np3 == n + 3 and np4 == n + 4,
       do: true

  defp straight?([{2, _}, {3, _}, {4, _}, {5, _}, {@ace, _}]), do: true
  defp straight?(_), do: false
end
