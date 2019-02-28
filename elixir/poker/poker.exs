defmodule Poker do
  @jack 11
  @queen 12
  @king 13
  @ace 14

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

  defp sort_cards(cards) do
    cards
    |> Enum.sort(fn {n1, c1}, {n2, c2} ->
      if n1 == n2 do
        c1 >= c2
      else
        n1 >= n2
      end
    end)
  end

  defp compare_and_filter(refs, []), do: refs

  defp compare_and_filter(refs = [ref | _], [other | others]) do
    r_score = score_of(ref)
    o_score = score_of(other)

    cond do
      o_score == r_score ->
        compare_and_filter([other | refs], others)

      o_score > r_score ->
        compare_and_filter([other], others)

      true ->
        compare_and_filter(refs, others)
    end
  end

  defp score_of(cards) do
    cards
    |> sort_cards()
    |> score_of_sorted()
  end

  defp score_of_sorted(cards) do
    highest_card =
      cards
      |> Enum.map(fn {n, c} -> n end)
      |> Enum.sort()
      |> Enum.reverse()
      |> List.first()

    highest_card
  end
end
