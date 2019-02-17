defmodule RobotSimulator do
  @settings %{
    :north => {:west, :east, {0, 1}},
    :east => {:north, :south, {1, 0}},
    :south => {:east, :west, {0, -1}},
    :west => {:south, :north, {-1, 0}}
  }

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    case {Map.get(@settings, direction, nil), position} do
       {nil, _} -> {:error, "invalid direction"}
       {_, {x, y}} when is_integer(x) and is_integer(y) -> {direction, position}
       _ -> {:error, "invalid position"}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, ""), do: robot

  def simulate({direction, position}, "R" <> instructions) do
    {_left, right, _advance} = Map.get(@settings, direction)
    {right, position}
    |> simulate(instructions)
  end

  def simulate({direction, position}, "L" <> instructions) do
    {left, _right, _advance} = Map.get(@settings, direction)
    {left, position}
    |> simulate(instructions)
  end

  def simulate({direction, {x, y}}, "A" <> instructions) do
    {_left, _right, {dx,dy}} = Map.get(@settings, direction)
    {direction, {x+dx, y+dy}}
    |> simulate(instructions)
  end

  def simulate(_, _), do: {:error, "invalid instruction"}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction({direction, _position}), do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position({_direction, position}), do: position
end
