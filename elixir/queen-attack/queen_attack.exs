defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct black: nil, white: nil

  @indices [0,1,2,3,4,5,6,7]

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new(white \\ {0, 3}, black \\ {7, 3})
  def new(white, white), do: raise ArgumentError
  def new(white, black), do: %Queens{white: white, black: black}

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    rows = for row <-  @indices, do: row_at(row, queens)
    Enum.join(rows, "\n")
  end

  defp row_at(row, queens) do
    cols = for col <- @indices, do: cell_at(row, col, queens)
    Enum.join(cols, " ")
  end

  defp cell_at(row, col, %Queens{white: {row, col}}), do: "W"
  defp cell_at(row, col, %Queens{black: {row, col}}), do: "B"
  defp cell_at(row, col, _), do: "_"

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{white: {row, _}, black: {row, _}}), do: true
  def can_attack?(%Queens{white: {_, col}, black: {_, col}}), do: true
  def can_attack?(%Queens{white: {rowW, colW}, black: {rowB, colB}}) do
    abs(rowW-rowB) == abs(colW-colB)
  end

end
