defmodule Day23a do
  def run do
    File.read!(".input.txt") |> run
  end

  def run(input) do
    con = input |> String.split("\n") |> Enum.map(&List.to_tuple(String.split(&1, "-")))

    graph =
      Graph.new(type: :undirected)
      |> Graph.add_edges(con)

    Graph.components(graph)
    |> Enum.flat_map(fn comp ->
      comp
      |> Enum.filter(&String.starts_with?(&1, "t"))
      |> Enum.flat_map(fn x ->
        n = graph |> Graph.neighbors(x)

        n
        |> Enum.flat_map(fn y -> n |> Enum.map(&{y, &1}) end)
        |> Enum.filter(fn {a, b} -> a != b end)
        |> Enum.filter(fn {a, b} -> Graph.edge(graph, a, b) != nil end)
        |> Enum.map(fn {a, b} -> MapSet.new([a, b, x]) end)
      end)
    end)
    |> MapSet.new()
    |> MapSet.size()
  end
end

defmodule Day23b do
  def run do
    File.read!(".input.txt") |> run
  end

  def bron_kerbosch(graph) do
    bron_kerbosch(graph, MapSet.new(), MapSet.new(Graph.vertices(graph)), MapSet.new(), [])
  end

  def bron_kerbosch(graph, r, p, x, max_cliques) do
    if MapSet.size(p) == 0 and MapSet.size(x) == 0 do
      [MapSet.to_list(r) | max_cliques]
    else
      p
      |> Enum.reduce({p, x, max_cliques}, fn v, {p, x, max_cliques} ->
        n_v = MapSet.new(Graph.neighbors(graph, v))

        max_cliques =
          bron_kerbosch(
            graph,
            MapSet.put(r, v),
            MapSet.intersection(p, n_v),
            MapSet.intersection(x, n_v),
            max_cliques
          )

        p = p |> MapSet.delete(v)
        x = x |> MapSet.put(v)

        {p, x, max_cliques}
      end)
      |> elem(2)
    end
  end

  def run(input) do
    con = input |> String.split("\n") |> Enum.map(&List.to_tuple(String.split(&1, "-")))

    graph =
      Graph.new(type: :undirected)
      |> Graph.add_edges(con)

    bron_kerbosch(graph)
    |> Enum.max_by(fn comp -> length(comp) end)
    |> Enum.sort()
    |> Enum.join(",")
  end
end
