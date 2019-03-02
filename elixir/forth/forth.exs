defmodule Forth do
  @opaque evaluator :: any

  defstruct stack: []

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %Forth{}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(%Forth{stack: stack}, expr) do
    new_stack =
      expr
      |> String.split(~r/[^\w+-\\*\/]| /)
      |> Enum.map(&String.upcase/1)
      |> Enum.reduce(stack, &evaluate_token/2)

    %Forth{stack: new_stack}
  end

  defp evaluate_token("+", [a, b | others]), do: [a + b | others]
  defp evaluate_token("*", [a, b | others]), do: [a * b | others]
  defp evaluate_token("-", [a, b | others]), do: [b - a | others]
  defp evaluate_token("/", [0, b | others]), do: raise(Forth.DivisionByZero)
  defp evaluate_token("/", [a, b | others]), do: [div(b, a) | others]
  defp evaluate_token("DUP", []), do: raise(Forth.StackUnderflow)
  defp evaluate_token("DUP", [a | others]), do: [a, a | others]
  defp evaluate_token("DROP", []), do: raise(Forth.StackUnderflow)
  defp evaluate_token("DROP", [a | others]), do: others
  defp evaluate_token("SWAP", []), do: raise(Forth.StackUnderflow)
  defp evaluate_token("SWAP", [_]), do: raise(Forth.StackUnderflow)
  defp evaluate_token("SWAP", [a, b | others]), do: [b, a | others]
  defp evaluate_token("OVER", []), do: raise(Forth.StackUnderflow)
  defp evaluate_token("OVER", [_]), do: raise(Forth.StackUnderflow)
  defp evaluate_token("OVER", [a, b | others]), do: [b, a, b | others]

  defp evaluate_token(token, stack), do: [String.to_integer(token) | stack]

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%Forth{stack: stack}) do
    stack
    |> Enum.reduce("", fn
      e, "" -> "#{e}"
      e, acc -> "#{e} #{acc}"
    end)
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
