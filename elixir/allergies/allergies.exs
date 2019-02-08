defmodule Allergies do
  use Bitwise

  @allergy_masks %{
    "eggs" => 1,
    "peanuts" => 2,
    "shellfish" => 4,
    "strawberries" => 8,
    "tomatoes" => 16,
    "chocolate" => 32,
    "pollen" => 64,
    "cats" => 128
  }

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    Enum.reduce(
      @allergy_masks,
      MapSet.new(),
      fn ({label, mask}, acc) -> append_if(acc, flags, label, mask) end)
  end

  defp append_if(set, flags, label, mask) do
    cond do
      (flags &&& mask) == mask ->
        MapSet.put(set, label)
      true ->
        set
    end
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item) do
    case Map.get(@allergy_masks, item) do
      nil ->
        false
      mask ->
        (flags &&& mask) == mask
    end

  end
end
