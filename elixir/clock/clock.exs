defmodule Clock do
  defstruct hour: 0, minute: 0

  defimpl String.Chars, for: Clock do
    def to_string(clock) do
      "#{leftPad(clock.hour)}:#{leftPad(clock.minute)}"
    end

    defp leftPad(num) when num < 10, do: "0#{num}"
    defp leftPad(num), do: "#{num}"
  end

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) do
    %Clock{hour: hour, minute: minute}
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
  end
end
