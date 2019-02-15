defmodule BracketPush do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
  	check_brackets(str, [])
  end

  defp check_brackets("", []), do: true
  defp check_brackets("",  _), do: false
  defp check_brackets("(" <> str, stack), do: check_brackets(str, ["(" | stack])
  defp check_brackets("{" <> str, stack), do: check_brackets(str, ["{" | stack])
  defp check_brackets("[" <> str, stack), do: check_brackets(str, ["[" | stack])
  #
  defp check_brackets("}" <> str, ["{"|stack]), do: check_brackets(str, stack)
  defp check_brackets(")" <> str, ["("|stack]), do: check_brackets(str, stack)
  defp check_brackets("]" <> str, ["["|stack]), do: check_brackets(str, stack)
  defp check_brackets("}" <> str, _), do: false
  defp check_brackets(")" <> str, _), do: false
  defp check_brackets("]" <> str, _), do: false
  #
  defp check_brackets(str, stack), do: check_brackets(String.slice(str, 1..-1), stack)
end
