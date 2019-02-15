defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}

  defstruct map: [] 

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    %CustomSet{map: remove_duplicate(enumerable, [])}
  end

  defp remove_duplicate([], collected), do: collected |> Enum.sort()
  defp remove_duplicate([h|t], collected) do
    if is_present?(collected, h) do
      remove_duplicate(t, collected)
    else
      remove_duplicate(t, [h|collected])
    end
  end

  defp is_present?([], _), do: false
  defp is_present?([v|vs], v), do: true
  defp is_present?([_|vs], v), do: is_present?(vs, v)

  @spec empty?(t) :: boolean
  def empty?(custom_set) do
    custom_set.map == []
  end

  @spec contains?(t, any) :: boolean
  def contains?(custom_set, element), do: is_present?(custom_set.map, element)

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2) do
    Enum.all?(custom_set_1.map, fn x -> is_present?(custom_set_2.map, x) end)
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2) do
    Enum.all?(custom_set_1.map, fn x -> !is_present?(custom_set_2.map, x) end)
  end

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2) do
    custom_set_1.map == custom_set_2.map
  end

  @spec add(t, any) :: t
  def add(custom_set, element) do
    %CustomSet{map: remove_duplicate([element], custom_set.map)}
  end

  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2) do
    new_map = custom_set_1.map |> Enum.filter(fn x -> is_present?(custom_set_2.map, x) end)
    %CustomSet{map: new_map}
  end

  @spec difference(t, t) :: t
  def difference(custom_set_1, custom_set_2) do
    new_map = custom_set_1.map |> Enum.filter(fn x -> !is_present?(custom_set_2.map, x) end)
    %CustomSet{map: new_map}
  end

  @spec union(t, t) :: t
  def union(custom_set_1, custom_set_2) do
    %CustomSet{map: remove_duplicate(custom_set_2.map, custom_set_1.map)}
  end
end
