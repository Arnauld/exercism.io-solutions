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
    |> Enum.join()
    |> patch()
  end

  defp process(line) do
    cond do
      String.starts_with?(line, "#") ->
        line
          |> parse_header_md_level()
          |> join_words_with_tags()
          |> enclose_with_header_tag()
      String.starts_with?(line, "*") ->
        line
          |> parse_list_md_level()
          |> join_words_with_tags()
          |> enclose_with_list_tag()
      true -> 
        line
          |> String.split()
          |> join_words_with_tags()
          |> enclose_with_paragraph_tag()
    end
  end

  defp parse_list_md_level(line) do
    line
      |> String.trim_leading("* ")
      |> String.split()
  end

  defp enclose_with_list_tag(text) do
    "<li>#{text}</li>"
  end

  defp parse_header_md_level(header_line) do
    [level | words] = String.split(header_line)
    {String.length(level), words}
  end

  defp enclose_with_header_tag({header_level, header_title}) do
    "<h#{header_level}>#{header_title}</h#{header_level}>"
  end

  defp enclose_with_paragraph_tag(text) do
    "<p>#{text}</p>"
  end

  defp join_words_with_tags({level, words}) do
    {level, join_words_with_tags(words)}
  end
  defp join_words_with_tags(words) do
    words
    |> Enum.map(&replace_md_with_tag/1)
    |> Enum.join(" ")
  end

  defp replace_md_with_tag(word) do
    word
    |> replace_prefix_md()
    |> replace_suffix_md()
  end

  defp replace_prefix_md(w) do
    cond do
      w =~ ~r/^#{"__"}{1}/ -> String.replace(w, ~r/^#{"__"}{1}/, "<strong>", global: false)
      w =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ -> String.replace(w, ~r/_/, "<em>", global: false)
      true -> w
    end
  end

  defp replace_suffix_md(w) do
    cond do
      w =~ ~r/#{"__"}{1}$/ -> String.replace(w, ~r/#{"__"}{1}$/, "</strong>")
      w =~ ~r/[^#{"_"}{1}]/ -> String.replace(w, ~r/_/, "</em>")
      true -> w
    end
  end

  defp patch(l) do
    String.replace_suffix(
      String.replace(l, "<li>", "<ul>" <> "<li>", global: false),
      "</li>",
      "</li>" <> "</ul>"
    )
  end
end
