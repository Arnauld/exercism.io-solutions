defmodule Bob do
  def hey(input) do
  	upper_cased = String.upcase(input)
  	question? = String.ends_with?(input, "?")
  	shouting? = (input == upper_cased) and at_leat_a_letter?(input)
  	empty? = String.trim(input) == ""

    cond do
      empty? -> "Fine. Be that way!"
	    shouting? and question? -> "Calm down, I know what I'm doing!"
	    shouting? -> "Whoa, chill out!"
	    question? -> "Sure."
      true -> "Whatever."
    end
  end

  defp at_leat_a_letter?(input) do 
    String.upcase(input) != String.downcase(input)
  end
end
