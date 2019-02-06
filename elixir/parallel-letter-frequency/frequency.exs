defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
  end


  def slice(texts, nb_parts) do
  	slice([], texts, nb_parts)
  end

  defp slice(accumulator, [], _nb_parts), do: accumulator
  defp slice(accumulator, [text|texts], nb_parts) do
  	accumulator
  		|> slice_text(text, nb_parts)
  		|> slice(texts, nb_parts)
  end

  defp slice_text(accumulator, text, nb_parts) do
  	length = String.length(text)
  	nb_per_part = div(length,nb_parts)
  	remaining = rem(length,nb_parts)
  	# IO.puts("length:#{length} nb_per_part:#{nb_per_part} remaining:#{remaining}")
  	accumulator
  		|> 	slice_text(String.to_charlist(text), nb_per_part, remaining, nb_parts, 0, [])
  end

  defp slice_text(accumulator, [], _nb_per_part, 0, 0, 0, _buffer) do
  	accumulator
  end
  # buffer complete and no remaining
  defp slice_text(accumulator, text, nb_per_part, 0, current_part, buffer_sz, buffer) when buffer_sz == nb_per_part do
  	slice_text([buffer|accumulator], text, nb_per_part, 0, current_part - 1, 0, [])
  end
  # buffer complete and remaining
  defp slice_text(accumulator, [char|chars], nb_per_part, remaining, current_part, buffer_sz, buffer) when buffer_sz == nb_per_part do
  	new_buffer = [char|buffer]
  	slice_text([new_buffer|accumulator], chars, nb_per_part, remaining-1, current_part - 1, 0, [])
  end
  defp slice_text(accumulator, [char|chars], nb_per_part, remaining, current_part, buffer_sz, buffer) do
  	new_buffer = [char|buffer]
  	slice_text(accumulator, chars, nb_per_part, remaining, current_part, buffer_sz+1, new_buffer)
  end
end
