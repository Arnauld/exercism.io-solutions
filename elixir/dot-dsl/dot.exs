defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []
end

defmodule Dot do
  defmacro graph(ast) do
  	%Graph{}
  	|> parse(ast)
  	|> Macro.escape
  end

  def parse(graph, [do: body]), do: parse(graph, body)
  def parse(graph, {:__block__, _, []}), do: graph

  def parse(graph, {:graph, _, nil}),        do: graph
  def parse(graph, {:graph, _, [[attrs]]}),    do: update_attrs(graph, attrs)
  def parse(graph, {n,      _, nil}),        do: append_node(graph, n, [])
  def parse(graph, {n,      _, [keywords]}), do: append_node(graph, n, keywords)

  def parse(graph, {:--, _, [{n1, _, nil}, {n2, _, nil}]}), do: append_edge(graph, n1, n2, [])

  defp update_attrs(graph, attrs) do
  	%{graph | attrs: [attrs | graph.attrs]}
  end
  defp append_node(graph, n, keywords) do 
  	%{graph | nodes: [{n, keywords} | graph.nodes]}
  end
  defp append_edge(graph, n1, n2, keywords) do 
  	%{graph | edges: [{n1, n2, keywords} | graph.edges]}
  end
end
