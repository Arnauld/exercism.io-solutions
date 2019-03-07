defmodule Clock do
  defstruct hour: 0, minute: 0

  @hour_per_day 24
  @minute_per_hour 60

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
    effective_minute = rem(delta_minute, @minute_per_hour)
    remaining_hour = div(delta_minute, @minute_per_hour)
    adjusted_hour = positive_hour(delta_hour + remaining_hour)
    effective_hour = rem(adjusted_hour, @hour_per_day)
    %Clock{hour: effective_hour, minute: effective_minute}
  end

  defp positive_hour(hour) when hour >= 0, do: hour

  defp positive_hour(hour) do
    num_day = div(-hour, @hour_per_day) + 1
    hour +  @hour_per_day * num_day
  end

  defp positive_minute({hour, minute}) when minute >= 0, do: {hour, minute}

  defp positive_minute({hour, minute}) do
    num_hour = div(-minute, @minute_per_hour) + 1
    {hour - num_hour, minute + @minute_per_hour * num_hour}
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
