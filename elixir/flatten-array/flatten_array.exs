defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    flatten(list, [])
    |> Enum.reverse
  end

  defp flatten([], acc), do: acc
  defp flatten([head|tail], acc) when is_list(head), do: flatten(tail, flatten(head, acc))
  defp flatten([head|tail], acc) when head==nil, do: flatten(tail, acc)
  defp flatten([head|tail], acc), do: flatten(tail, [head|acc])
end
