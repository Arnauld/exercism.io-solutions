defmodule OCRNumbers do
  @alphabet %{
    [' _ ',
     '| |',
     '|_|',
     '   '] => "0",
    ['   ',
     '  |',
     '  |',
     '   '] => "1"
  }
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: String.t()
  def convert(input) do
    result =
      input
      |> Enum.map(&String.to_charlist/1)
      |> split_letters()
      |> Enum.map(&to_letter/1)
      |> List.to_string()

    {:ok, result}
  end

  defp to_letter(input) do
    Map.get(@alphabet, input, "?")
  end

  defp split_letters(input) do
    split_letters(input, [])
  end

  defp split_letters(['', '', '', ''], acc), do: acc

  defp split_letters(input, acc) do
    {letter, remaining} = first_letter(input, [], [])
    split_letters(remaining, [letter | acc])
  end

  defp first_letter([], letter, remaining) do
    {Enum.reverse(letter), Enum.reverse(remaining)}
  end

  defp first_letter([line | other_lines], letter, remaining) do
    {letter_part, remaining_part} =
      line
      |> Enum.split(3)

    first_letter(other_lines, [letter_part | letter], [remaining_part | remaining])
  end
end
