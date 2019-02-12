defmodule ListOpsNative do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l) do
    Enum.count(l)
  end

  @spec reverse(list) :: list
  def reverse(l) do
    Enum.reverse(l)
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    Enum.map(l,f)
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    Enum.filter(l, f)
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce(ll, acc, f) do
    Enum.reduce(ll, acc, f)
  end

  @spec append(list, list) :: list
  def append(a, b) do
    a ++ b
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    Enum.concat(ll)
  end
end
