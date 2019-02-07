defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
  	Enum.map(dna, &RNATranscription.transcribes/1)
  end

  def transcribes(?G), do: ?C
  def transcribes(?C), do: ?G
  def transcribes(?T), do: ?A
  def transcribes(?A), do: ?U

end
