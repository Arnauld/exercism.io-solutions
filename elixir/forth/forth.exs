defmodule Forth do
  @opaque evaluator :: %Forth{}

  defstruct stack: [], words: %{}

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
  def eval(ev, expr) do
    expr
    |> String.split(~r/[\s\pC]/u)
    |> Enum.map(&String.upcase/1)
    |> evaluate_expr(ev)
  end

  defp evaluate_expr([], ev), do: ev

  defp evaluate_expr([":", word | others], ev) do
    with :ok <- validate_word(word) do
      {word_expr, remaining} = evaluate_word(others, [])
      new_words = Map.put(ev.words, word, word_expr)
      new_ev = %Forth{ev | words: new_words}
      evaluate_expr(remaining, new_ev)
    end
  end

  defp evaluate_expr([token | expr_remaining], ev = %Forth{stack: stack, words: words}) do
    case Map.get(words, token) do
      nil ->
        new_stack = evaluate_token(token, stack)
        new_ev = %Forth{ev | stack: new_stack}
        evaluate_expr(expr_remaining, new_ev)

      word_expr ->
        evaluate_expr(word_expr ++ expr_remaining, ev)
    end
  end

  defp validate_word(word) do
    if String.match?(word, ~r/[^0-9]+.*/i) do
      :ok
    else
      raise Forth.InvalidWord
    end
  end

  defp evaluate_word([";" | others], expr), do: {Enum.reverse(expr), others}
  defp evaluate_word([e | others], expr), do: evaluate_word(others, [e | expr])

  defp evaluate_token("+", [a, b | others]), do: [a + b | others]
  defp evaluate_token("+", _), do: raise(Forth.StackUnderflow)
  defp evaluate_token("*", [a, b | others]), do: [a * b | others]
  defp evaluate_token("*", _), do: raise(Forth.StackUnderflow)
  defp evaluate_token("-", [a, b | others]), do: [b - a | others]
  defp evaluate_token("-", _), do: raise(Forth.StackUnderflow)
  defp evaluate_token("/", [0, _ | _]), do: raise(Forth.DivisionByZero)
  defp evaluate_token("/", [a, b | others]), do: [div(b, a) | others]
  defp evaluate_token("/", _), do: raise(Forth.StackUnderflow)
  defp evaluate_token("DUP", [a | others]), do: [a, a | others]
  defp evaluate_token("DUP", _), do: raise(Forth.StackUnderflow)
  defp evaluate_token("DROP", [_ | others]), do: others
  defp evaluate_token("DROP", _), do: raise(Forth.StackUnderflow)
  defp evaluate_token("SWAP", [a, b | others]), do: [b, a | others]
  defp evaluate_token("SWAP", _), do: raise(Forth.StackUnderflow)
  defp evaluate_token("OVER", [a, b | others]), do: [b, a, b | others]
  defp evaluate_token("OVER", _), do: raise(Forth.StackUnderflow)


  defp evaluate_token(token, stack) do
    if String.match?(token, ~r/[0-9]+/) do
      [String.to_integer(token) | stack]
    else
      raise Forth.UnknownWord
    end
  end

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
