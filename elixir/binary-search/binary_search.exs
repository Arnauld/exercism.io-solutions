defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    min = 0
    max = tuple_size(numbers) - 1
    binary_search(min, max, numbers, key)
  end

  defp binary_search(min, max, _umbers, _ey) when min>max, do: :not_found
  defp binary_search(min, max, numbers, key) do
    mid = div(max+min, 2)
    elem_at = elem(numbers, mid)
    cond do
      key > elem_at ->
        binary_search(mid+1, max, numbers, key)
      key < elem_at ->
        binary_search(min, mid-1, numbers, key)
      true ->
        {:ok, mid}
    end
  end
end
