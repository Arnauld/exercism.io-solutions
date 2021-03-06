defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    markdown
    |> String.split("\n")
    |> Enum.map(&process/1)
    |> group_list_entries()
    |> Enum.join()
  end

  defp group_list_entries(lines), do: group_list_entries(lines, [], [])

  defp group_list_entries([], [], acc), do: Enum.reverse(acc)
  defp group_list_entries([], list_entries, acc) do
    group_list_entries([], [], [enclose_ul(list_entries)|acc])
  end
  defp group_list_entries(["<li>" <> line | others], uls, acc) do
    group_list_entries(others, ["<li>"<>line | uls], acc)
  end
  defp group_list_entries([line | others], [], acc) do
    group_list_entries(others, [], [line|acc])
  end
  defp group_list_entries(lines, list_entries, acc) do
    group_list_entries(lines, [], [enclose_ul(list_entries)|acc])
  end

  defp enclose_ul(uls) do
    uls
      |> Enum.reverse()
      |> Enum.join()
      |> enclose_with_tag("ul")
  end

  defp process("#" <> header_title), do: process_header(1, header_title)
  defp process("* " <> list_entry), do: process_list_entry(list_entry)
  defp process(line), do: process_paragrah(line)

  defp process_paragrah(line) do
    line
    |> process_block()
    |> enclose_with_tag("p")
  end

  defp process_list_entry(text) do
    text
    |> process_block()
    |> enclose_with_tag("li")
  end

  defp process_header(level, "#" <> header_title), do: process_header(level+1, header_title)
  defp process_header(level, " " <> header_title) do
    header_title
    |> process_block()
    |> enclose_with_tag("h#{level}")
  end

  defp process_block(line) do
    line |> bold() |> italic()
  end

  defp enclose_with_tag(text, tag), do: "<#{tag}>#{text}</#{tag}>"

  defp bold(word) do
    String.replace(word, ~r/__(.+)__/, "<strong>\\1</strong>")
  end

  defp italic(word) do
    String.replace(word, ~r/_(.+)_/, "<em>\\1</em>")
  end

end
