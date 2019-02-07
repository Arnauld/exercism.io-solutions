defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec is_valid?(integer) :: boolean
  def is_valid?(number) do
    chars =
      number
      |> to_string()
      |> to_charlist()

    number_of_digits = length(chars)

    powa =
      Enum.reduce(chars, 0, fn char, acc ->
        delta =
          char
          |> ascii_to_digit()
          |> :math.pow(number_of_digits)
          |> round()

        acc + delta
      end)

    number == powa
  end

  def ascii_to_digit(ascii) when ascii >= 48 and ascii < 58 do
    ascii - 48
  end
end
