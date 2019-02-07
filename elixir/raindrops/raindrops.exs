defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
      ''
      |> append(number, 7, 'Plong')
      |> append(number, 5, 'Plang')
      |> append(number, 3, 'Pling')
      |> otherwise(number)
      |> List.to_string()
  end

  defp append(buffer, number, threshold, text) do
    plxng? = rem(number, threshold) == 0
    cond do
      plxng? -> text ++ buffer
      true -> buffer
    end
  end

  defp otherwise(buffer, number) do
    length = length(buffer)
    cond do
      length == 0 ->
        number
        |> to_string()
        |> to_charlist()

      true ->
        buffer
    end
  end
end
