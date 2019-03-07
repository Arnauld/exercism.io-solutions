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
    {effective_hour, effective_minute} = adjuste_time({hour, minute})
    %Clock{hour: effective_hour, minute: effective_minute}
  end

  defp adjuste_time({hour, minute}) when minute >= 0 and hour >= 0 do
    delta_hour = div(minute, @minute_per_hour)
    adjusted_hour = hour + delta_hour

    effective_hour = rem(adjusted_hour, @hour_per_day)
    effective_minute = rem(minute, @minute_per_hour)
    {effective_hour, effective_minute}
  end

  defp adjuste_time({hour, minute}) when minute < 0 do
    nb_hour = div(-minute, @minute_per_hour) + 1
    adjuste_time({hour - nb_hour, minute + @minute_per_hour * nb_hour})
  end

  defp adjuste_time({hour, minute}) when hour < 0 do
    nb_day = div(-hour, @hour_per_day) + 1
    adjusted_hour = hour +  @hour_per_day * nb_day
    adjuste_time({adjusted_hour, minute})
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
