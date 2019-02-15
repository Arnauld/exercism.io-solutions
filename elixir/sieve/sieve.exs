defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
  	Enum.to_list(2..limit)
  		|> sieve([])
  		|> Enum.reverse()
  end

  defp sieve([], collected), do: collected
  defp sieve([n | ns], collected) do
  	ns
  	|> remove_multiple_of(n)
  	|> sieve([n|collected])
  end
  defp remove_multiple_of(ns, n) do
  	ns
  	|> Enum.filter(fn x -> rem(x,n) != 0 end)
  end
end
