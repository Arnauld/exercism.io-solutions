defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
  	MapSet.new()
  	|> collect(limit, factors)
  	|> Enum.sum()
  end

  defp collect(set, _limit, []) do
  	set
  end
  defp collect(set, limit, [factor|others]) do
  	set
  		|> collect_multiples(limit, factor, 1)
  		|> collect(limit, others)
  end

  defp collect_multiples(set, limit, factor, multiple) do
  	f = factor * multiple
  	cond do
  			f < limit ->
  				collect_multiples(MapSet.put(set, f), limit, factor, multiple + 1)
  			true ->
  				set
  		end	
  end
end
