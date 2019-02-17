defmodule ISBNVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    case Regex.match?(~r/^\d\-?\d{3}\-?\d{5}\-?(\d|X)$/, isbn) do
      false ->
        false

      true ->
        isbn
        |> String.replace("-", "")
        |> String.to_charlist()
        |> Enum.zip(10..1)
        |> Enum.map(&parse_and_scale/1)
        |> Enum.sum()
        |> rem(11) == 0
    end
  end

  defp parse_and_scale({?X, scale}), do: 10 * scale

  defp parse_and_scale({digit, scale}) when digit >= 48 and digit <= 57 do
    (digit - 48) * scale
  end
end
