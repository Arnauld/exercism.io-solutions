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
    {delta_hour, delta_minute} = positive_minute({hour, minute})
    effective_hour = positive_hour(delta_hour + div(delta_minute, 60))
    %Clock{hour: rem(effective_hour, 24), minute: rem(delta_minute, 60)}
  end

  defp positive_hour(hour) when hour >= 0, do: hour

  defp positive_hour(hour) do
    num = div(-hour, 24) + 1
    hour + 24 * num
  end

  defp positive_minute({hour, minute}) when minute >= 0, do: {hour, minute}

  defp positive_minute({hour, minute}) do
    num = div(-minute, 60) + 1
    {hour - num, minute + 60 * num}
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end
end
