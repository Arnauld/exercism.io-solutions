defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, nb_workers) do
    workers =
      Enum.to_list(1..nb_workers)
      |> Enum.map(fn _ -> spawn(__MODULE__, :worker_loop, [%{}]) end)

    slice({workers, []}, &Frequency.round_robin_distribute/2, texts, nb_workers)
    send_eot(workers)
    wait_frequencies(nb_workers, %{})
  end

  defp wait_frequencies(0, stats), do: stats

  defp wait_frequencies(waiting, stats) do
    receive do
      {:stats, worker_stats} ->
        wait_frequencies(waiting - 1, merge_stats(stats, worker_stats))

      msg ->
        raise "unsupportedMessage: #{inspect(msg)}"
    end
  end

  defp merge_stats(stats1, stats2) do
    Map.merge(stats1, stats2, fn _, v1, v2 -> v1 + v2 end)
  end

  defp send_eot([]), do: :ok

  defp send_eot([worker | others]) do
    send(worker, {:eot, self()})
    send_eot(others)
  end

  def round_robin_distribute(buffer, {[], used}) do
    round_robin_distribute(buffer, {used, []})
  end

  def round_robin_distribute(buffer, {[worker | others], used}) do
    send(worker, {:buffer, buffer})
    {others, [worker | used]}
  end

  def worker_loop(worker_stats) do
    receive do
      {:eot, from} ->
        send(from, {:stats, worker_stats})

      {:buffer, buffer} ->
        updated_stats = count_letters(buffer, worker_stats)
        worker_loop(updated_stats)

      msg ->
        raise "unsupportedMessage: #{inspect(msg)}"
    end
  end

  def count_letters(chars, stats) do
    chars
    |> Stream.filter(fn c ->
      s = List.to_string([c])
      String.upcase(s) != String.downcase(s)
    end)
    |> Enum.reduce(stats, fn c, st ->
      key = [c] |> List.to_string() |> String.downcase()
      Map.update(st, key, 1, &(&1 + 1))
    end)
  end

  def slice(texts, nb_parts) do
    slice([], fn b, acc -> [b | acc] end, texts, nb_parts)
  end

  defp slice(accumulator_state, _accumulator_fn, [], _nb_parts), do: accumulator_state

  defp slice(accumulator_state, accumulator_fn, [text | texts], nb_parts) do
    accumulator_state
    |> slice_text(accumulator_fn, text, nb_parts)
    |> slice(accumulator_fn, texts, nb_parts)
  end

  defp slice_text(accumulator_state, accumulator_fn, text, nb_parts) do
    length = String.length(text)
    nb_per_part = div(length, nb_parts)
    remaining = rem(length, nb_parts)
    # IO.puts("length:#{length} nb_per_part:#{nb_per_part} remaining:#{remaining}")
    accumulator_state
    |> slice_text(
      accumulator_fn,
      String.to_charlist(text),
      nb_per_part,
      remaining,
      nb_parts,
      0,
      []
    )
  end

  defp slice_text(
         accumulator_state,
         accumulator_fn,
         text,
         nb_per_part,
         remaining,
         current_part,
         buffer_sz,
         buffer
       )

  defp slice_text(accumulator_state, _, [], _, 0, _, 0, _) do
    accumulator_state
  end

  defp slice_text(accumulator_state, accumulator_fn, [], _, 0, _, _, buffer) do
    accumulator_fn.(buffer, accumulator_state)
  end

  # buffer complete and no remaining
  defp slice_text(
         accumulator_state,
         accumulator_fn,
         text,
         nb_per_part,
         0,
         current_part,
         buffer_sz,
         buffer
       )
       when buffer_sz == nb_per_part do
    new_state = accumulator_fn.(buffer, accumulator_state)
    slice_text(new_state, accumulator_fn, text, nb_per_part, 0, current_part - 1, 0, [])
  end

  # buffer complete and remaining
  defp slice_text(
         accumulator_state,
         accumulator_fn,
         [char | chars],
         nb_per_part,
         remaining,
         current_part,
         buffer_sz,
         buffer
       )
       when buffer_sz == nb_per_part do
    new_buffer = [char | buffer]
    new_state = accumulator_fn.(new_buffer, accumulator_state)

    slice_text(
      new_state,
      accumulator_fn,
      chars,
      nb_per_part,
      remaining - 1,
      current_part - 1,
      0,
      []
    )
  end

  defp slice_text(
         accumulator_state,
         accumulator_fn,
         [char | chars],
         nb_per_part,
         remaining,
         current_part,
         buffer_sz,
         buffer
       ) do
    slice_text(
      accumulator_state,
      accumulator_fn,
      chars,
      nb_per_part,
      remaining,
      current_part,
      buffer_sz + 1,
      [char | buffer]
    )
  end
end
