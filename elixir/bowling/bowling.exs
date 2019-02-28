defmodule Bowling do
  defstruct rolls: [], status: :incomplete

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
    %Bowling{}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()
  def roll(_, roll) when roll < 0, do: {:error, "Negative roll is invalid"}
  def roll(_, roll) when roll > 10, do: {:error, "Pin count exceeds pins on the lane"}

  def roll(game = %Bowling{rolls: rolls}, roll) do
    new_rolls = [roll | rolls]

    case validate_rolls(new_rolls) do
      s when s == :ok or s == :incomplete ->
        %Bowling{game | rolls: new_rolls, status: s}

      error ->
        error
    end
  end

  defp validate_rolls(rolls) do
    validate_rolls(Enum.reverse(rolls), 1)
  end

  defp validate_rolls([], 11) do
    :ok
  end

  defp validate_rolls([], n) do
    :incomplete
  end

  defp validate_rolls(_, roll_count) when roll_count > 10 do
    {:error, "Cannot roll after game is over"}
  end

  # last but incomplete roll
  defp validate_rolls([r], n) do
    :incomplete
  end

  # final but incomplete strike
  defp validate_rolls([r, r1], n = 10) when r == 10 do
    :incomplete
  end

  # final perfect strike
  defp validate_rolls([r, 10, _], 10) when r == 10 do
    :ok
  end

  defp validate_rolls([r, r1, r2], 10) when r == 10 and r1 + r2 > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  defp validate_rolls([r, r1, r2], 10) when r == 10 do
    :ok
  end

  # final spare
  defp validate_rolls([r1, r2, r], 10) when r1 + r2 == 10 do
    :ok
  end

  # final but incomplete spare
  defp validate_rolls([r1, r2], n = 10) when r1 + r2 == 10 do
    :incomplete
  end

  # strike
  defp validate_rolls([r | others], roll_count) when r == 10 do
    validate_rolls(others, roll_count + 1)
  end

  # complete but invalid roll
  defp validate_rolls([r1, r2 | others], roll_count) when r1 + r2 > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  # complete roll
  defp validate_rolls([r1, r2 | others], roll_count) do
    validate_rolls(others, roll_count + 1)
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score(%Bowling{rolls: rolls, status: status}) do
    case status do
      :ok ->
        rolls
        |> Enum.reverse()
        |> score_frames(0, 0)

      :incomplete ->
        {:error, "Score cannot be taken until the end of the game"}
    end
  end

  defp score_frames(_, total, 10), do: total

  defp score_frames([r1, n1, n2 | others], total, frame) when r1 == 10 do
    score_frames([n1, n2 | others], total + r1 + n1 + n2, frame + 1)
  end

  defp score_frames([r1, r2, n1 | others], total, frame) when r1 + r2 == 10 do
    score_frames([n1 | others], total + r1 + r2 + n1, frame + 1)
  end

  defp score_frames([r1, r2 | others], total, frame) do
    score_frames(others, total + r1 + r2, frame + 1)
  end
end
