defmodule OCRNumbers do
  # preserve:start
  @alphabet %{
    [' _ ', '| |', '|_|', '   '] => "0",
    ['   ', '  |', '  |', '   '] => "1",
    [' _ ', ' _|', '|_ ', '   '] => "2",
    [' _ ', ' _|', ' _|', '   '] => "3",
    [
      '   ',
      '|_|',
      '  |',
      '   '
    ] => "4",
    [
      ' _ ',
      '|_ ',
      ' _|',
      '   '
    ] => "5",
    [
      ' _ ',
      '|_ ',
      '|_|',
      '   '
    ] => "6",
    [
      ' _ ',
      '  |',
      '  |',
      '   '
    ] => "7",
    [
      ' _ ',
      '|_|',
      '|_|',
      '   '
    ] => "8",
    [
      ' _ ',
      '|_|',
      ' _|',
      '   '
    ] => "9"
  }
  # preserve:end
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: String.t()
  def convert(input) do
    with :ok <- validate_lines(0, input) do
      result =
        input
        |> Enum.map(&String.to_charlist/1)
        |> split_and_map_letters()
        |> List.to_string()

      {:ok, result}
    end
  end

  defp validate_lines(0, []), do: {:error, 'invalid line count'}
  defp validate_lines(_, []), do: :ok

  defp validate_lines(line_number, [l1, l2, l3, l4 | r]) do
    with :ok <- validate_column_count([l1, l2, l3, l4]),
         :ok <- validate_length_of_all_lines([l1, l2, l3, l4]) do
      validate_lines(line_number + 1, r)
    end
  end

  defp validate_lines(_line_number, _whatever), do: {:error, 'invalid line count'}

  defp validate_column_count([line | _]) do
    nb_chars = String.length(line)

    case rem(nb_chars, 3) do
      0 -> :ok
      n -> {:error, 'invalid column count'}
    end
  end

  defp validate_length_of_all_lines([line | others]) do
    nb_chars = String.length(line)

    case Enum.all?(others, fn x -> String.length(x) == nb_chars end) do
      true -> :ok
      _ -> {:incoherent_length_of_lines}
    end
  end

  defp to_letter(input) do
    Map.get(@alphabet, input, "?")
  end

  defp split_and_map_letters(input) do
    split_and_map_letters(input, [], "")
  end

  defp split_and_map_letters(['', '', '', ''], acc, out) do
    out_part =
      Enum.reverse(acc)
      |> Enum.map(&to_letter/1)
    out <> out_part
  end

  defp split_and_map_letters(
         [
           [a1, b1, c1 | r1],
           [a2, b2, c2 | r2],
           [a3, b3, c3 | r3],
           [a4, b4, c4 | r4]
         ],
         acc
       ) do
    letter = [[a1, b1, c1], [a2, b2, c2], [a3, b3, c3], [a4, b4, c4]]
    split_and_map_letters([r1, r2, r3, r4], [letter | acc])
  end
end
