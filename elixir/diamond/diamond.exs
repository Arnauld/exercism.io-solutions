defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
  	pattern = pattern(letter)
  	letters = letters(letter)
  	rows = for letter <- letters, do: replace_all_except(pattern, letter)
  	Enum.join(rows, "\n") <> "\n"
  end

  defp replace_all_except(list, letter) do
  	# Enum.reverse is not needed due to symetry in list
  	replace_all_except(list, letter, []) 
  end

  defp replace_all_except([], _, acc), do: acc
  defp replace_all_except([letter|others], letter, acc) do
  	replace_all_except(others, letter, [letter|acc])
  end
  defp replace_all_except([_|others], letter, acc) do
  	replace_all_except(others, letter, [' '|acc])
  end

  def letters(?A), do: [?A]
  def letters(letter) do
  	Enum.to_list(?A..letter) ++ Enum.to_list((letter-1)..?A)
  end

  def pattern(?A), do: [?A]
  def pattern(letter) do
  	Enum.to_list(letter..?A) ++ Enum.to_list((?A+1)..letter)
  end
end
