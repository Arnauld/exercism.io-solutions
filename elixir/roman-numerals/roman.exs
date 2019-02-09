defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do
  	List.duplicate('I', number)
  		|> List.to_string()
  		|> String.replace("IIIII", "V")
  		|> String.replace("VV", "X")
  		|> String.replace("XXXXX", "L")
  		|> String.replace("LL", "C")
  		|> String.replace("CCCCC", "D")
  		|> String.replace("DD", "M")
  		# SPECIAL CASES
  		|> String.replace("IIII","IV")
        |> String.replace("VIV","IX")
        |> String.replace("XXXX","XL")
        |> String.replace("LXL","XC")
        |> String.replace("CCCC","CD")
        |> String.replace("DCD","CM")
  end
end
