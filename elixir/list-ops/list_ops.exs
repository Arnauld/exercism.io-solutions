defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l) do
    count(l, 0)
  end

  defp count([], acc), do: acc
  defp count([_|t], acc), do: count(t, acc+1)

  @spec reverse(list) :: list
  def reverse(l) do
    reverse(l, [])
  end

  defp reverse([], acc), do: acc
  defp reverse([h|t], acc), do: reverse(t, [h|acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    map(l, f, [])
  end

  defp map([], _, acc), do: reverse(acc)
  defp map([h|t], f, acc), do: map(t, f, [f.(h) | acc])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    filter(l, f, [])
  end

  defp filter([], _, acc), do: reverse(acc)
  defp filter([h|t], f, acc) do
    if f.(h) do
      filter(t, f, [h|acc])
    else
      filter(t, f, acc)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _), do: acc
  def reduce([h|t], acc, f) do
    new_acc = f.(h, acc)
    reduce(t, new_acc, f)
  end

  @spec append(list, list) :: list
  def append(a, b) do
    a
    |> reverse()
    |> reduce(b, fn(e,acc) -> [e|acc] end)
  end

  @spec concat([[any]]) :: [any]
  def concat([]), do: []
  def concat([h|t]) do
    t
    |> reduce(reverse(h), fn(e,acc) -> e |> reverse() |> append(acc) end)
    |> reverse()
  end
end
