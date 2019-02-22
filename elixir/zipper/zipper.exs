defmodule BinTree do
  import Inspect.Algebra

  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{value: any, left: BinTree.t() | nil, right: BinTree.t() | nil}
  defstruct value: nil, left: nil, right: nil

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BT[value: 3, left: BT[value: 5, right: BT[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: v, left: l, right: r}, opts) do
    concat([
      "(",
      to_doc(v, opts),
      ":",
      if(l, do: to_doc(l, opts), else: ""),
      ":",
      if(r, do: to_doc(r, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  @type t :: %Zipper{node: BinTree.t(), stack: [{atom(), BinTree.t()}]}
  defstruct node: nil, stack: []

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t()) :: Z.t()
  def from_tree(bt) do
    %Zipper{node: bt}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t()) :: BT.t()
  def to_tree(%Zipper{node: n, stack: []}), do: n

  def to_tree(%Zipper{stack: stack}) do
    {_, n} = List.last(stack)
    n
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t()) :: any
  def value(%Zipper{node: n}), do: n.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t()) :: Z.t() | nil
  def left(z = %Zipper{node: n}) do
    case n.left do
      nil ->
        nil

      new_node ->
        %Zipper{z | node: new_node, stack: [{:left, n} | z.stack]}
    end
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t()) :: Z.t() | nil
  def right(z = %Zipper{node: n}) do
    case n.right do
      nil ->
        nil

      new_node ->
        %Zipper{z | node: new_node, stack: [{:right, n} | z.stack]}
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t()) :: Z.t()
  def up(%Zipper{stack: []}), do: nil
  def up(z = %Zipper{stack: [{_, h} | t]}), do: %Zipper{z | node: h, stack: t}

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t(), any) :: Z.t()
  def set_value(%Zipper{node: n, stack: stack}, new_value) do
    new_n = %BinTree{n | value: new_value}
    # then need to rewrite entire history to reference the new node in chain
    new_stack = rewrite_tree(new_n, stack, [])
    %Zipper{node: new_n, stack: new_stack}
  end

  defp rewrite_tree(_, [], out_stack), do: Enum.reverse(out_stack)

  defp rewrite_tree(n, [{direction, parent} | t], out_stack) do
    new_parent =
      case direction do
        :left ->
          %BinTree{parent | left: n}

        :right ->
          %BinTree{parent | right: n}
      end

    new_stack = [{direction, new_parent} | out_stack]
    rewrite_tree(new_parent, t, new_stack)
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t(), BT.t()) :: Z.t()
  def set_left(z, l) do
    z
    |> left()
    |> set_value(l)
    |> up()
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t(), BT.t()) :: Z.t()
  def set_right(z, r) do
    z
    |> right()
    |> set_value(r)
    |> up()
  end
end
