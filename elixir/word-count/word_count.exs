defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
  	sentence
  		|> String.downcase()
  		|> String.split(~r"[\s$!@#%^&:;,._]+")
  		|> Enum.reduce(%{}, &Words.add_or_increment/2)
  end

  def add_or_increment("", map), do: map
  def add_or_increment(word, map) do
    Map.update(map, word, 1, &(&1 + 1))
  end
end
