defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
  	if Regex.match?(~r/^\s*\d+(\s*\d)+\s*$/, number) do
	  	sum = number
		  		|> String.replace(" ", "")
		        |> String.to_charlist()
		        |> Enum.map(&to_digit/1)
		        |> Enum.reverse()
		        |> reduce([])
		rem(sum |> Enum.sum(), 10) == 0
   	else
  		false
  	end
  end


  defp to_digit(d) when d >= 48 and d <= 57, do: d - 48

  defp reduce([], acc), do: acc
  defp reduce([d1], acc), do: [d1|acc]
  defp reduce([d1,d2|tail], acc) do
  	reduce(tail, [apply_threshold(2*d2), d1|acc])
  end

  defp apply_threshold(d) when d > 9, do: d-9
  defp apply_threshold(d), do: d
end
