defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(_, 0), do: 1

  def largest_product(number_string, size) do
    with :ok <- validate_size(size),
         :ok <- validate_number(number_string, size) do
      number_string
      |> String.to_charlist()
      |> Enum.map(&to_digit/1)
      |> traverse(size)
    else
      _ -> raise ArgumentError
    end
  end

  defp validate_size(size) when size < 0, do: :error
  defp validate_size(_), do: :ok

  defp validate_number(number_string, size) do
    if size <= number_string |> String.to_charlist() |> length() do
      :ok
    else
      :error
    end
  end

  defp to_digit(c) when c >= 48 and c <= 57, do: c - 48

  defp traverse(elems, size) do
    {initial_elems, others} = Enum.split(elems, size)
    max = evaluate(initial_elems)
    traverse(others, size, initial_elems |> Enum.reverse(), max)
  end

  defp traverse([], _, _, max), do: max

  defp traverse([h | t], size, acc, max) do
    new_acc = [h | Enum.take(acc, size - 1)]
    pot = evaluate(new_acc)

    if pot > max do
      traverse(t, size, new_acc, pot)
    else
      traverse(t, size, new_acc, max)
    end
  end

  defp evaluate(list) do
    list |> Enum.reduce(1, fn x, acc -> x * acc end)
  end
end
