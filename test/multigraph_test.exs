defmodule MultiGraphTest do
  use ExUnit.Case, async: true
  alias Graph.Edge

  defp complete_graph(n, opts \\[])
  defp complete_graph(0, _opts), do: Graph.new()
  defp complete_graph(1, _opts), do: Graph.new() |> Graph.add_vertex(0)
  defp complete_graph(k, opts) do
    Enum.reduce(0..k-2, complete_graph(k - 1, opts), fn v, g ->
      Graph.add_edge(g, v, k - 1, opts)
    end)
  end

  defp merge_graph(g1, g2) do
    Graph.edges(g2)
    |> Enum.reduce(g1, fn edge, acc -> Graph.add_edge(acc, edge) end)
  end

  test "test complete_graph" do
    for {k, e} <- Enum.zip(0..6, [0, 0, 1, 3, 6, 10, 15]) do
      graph = complete_graph(k)
      assert Graph.edges(graph) |> length == e
      assert Graph.vertices(graph) |> length == k
    end
  end

  test "test merge graph" do
    multi = complete_graph(4, label: [color: :red])
    |> merge_graph(complete_graph(4, label: [colour: :blue]))
    |> merge_graph(complete_graph(4, label: [colour: :green]))
    assert Graph.edges(multi) |> length == 18
    assert Graph.vertices(multi) |> length == 4
    assert Graph.degree(multi, 0) == 9
  end

  test "describe multigraph" do
    graph = Graph.new()
      |> Graph.add_edge(:v1, :v2, weight: 1, label: [colour: :red])
      |> Graph.add_edge(:v1, :v2, weight: 2, label: [colour: :blue])
      |> Graph.add_edge(:v1, :v2, weight: 3, label: [colour: :green])
    assert Graph.degree(graph, :v1) == 3
    assert Graph.edges(graph) |> length == 3
  end

  test "pathfinding multigraph" do
    graph = Graph.new()
      |> Graph.add_edge(:v1, :v2, label: [colour: :green])
      |> Graph.add_edge(:v1, :v3, label: [colour: :red])
      |> Graph.add_edge(:v2, :v3, label: [colour: :blue])
      |> Graph.add_edge(:v2, :v3, label: [colour: :green])
      |> Graph.add_edge(:v3, :v4, label: [colour: :blue])
      |> Graph.add_edge(:v3, :v4, label: [colour: :green])
    assert Graph.Pathfinding.all(graph, :v1, :v3) == [[:v1, :v2, :v3], [:v1, :v3]]
  end

end
