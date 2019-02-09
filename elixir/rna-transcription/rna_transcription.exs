defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
  	Enum.map(dna, &transcribes/1)
  end

  defp transcribes(?G), do: ?C
  defp transcribes(?C), do: ?G
  defp transcribes(?T), do: ?A
  defp transcribes(?A), do: ?U

end
