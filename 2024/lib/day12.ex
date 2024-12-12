defmodule Day12a do
  def get(grid, x, y)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    nil
  end

  def get(grid, x, y) do
    grid |> elem(y) |> elem(x)
  end

  def run do
    grid =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn row -> row |> String.to_charlist() |> List.to_tuple() end)
      |> List.to_tuple()

    graph =
      -1..(tuple_size(grid) - 1)
      |> Enum.reduce(Graph.new(type: :undirected), fn y, graph ->
        -1..(tuple_size(elem(grid, 0)) - 1)
        |> Enum.reduce(graph, fn x, graph ->
          a = get(grid, x, y)

          [{1, 0}, {0, 1}]
          |> Enum.reduce(graph, fn {dx, dy}, graph ->
            b = get(grid, x + dx, y + dy)

            graph = if a != nil, do: graph |> Graph.add_vertex({x, y}), else: graph

            if a == b and a != nil and b != nil do
              Graph.add_edge(graph, {x, y}, {x + dx, y + dy})
            else
              graph
            end
          end)
        end)
      end)

    # {:ok, dot} = graph |> Graph.to_dot()
    # File.write(".graph.dot", dot)

    graph
    |> Graph.components()
    |> Enum.map(fn component ->
      fence = component |> Enum.map(fn vert -> 4 - Graph.degree(graph, vert) end) |> Enum.sum()
      area = component |> length()

      fence * area
    end)
    |> Enum.sum()
  end
end

defmodule Day12b do
  def get(grid, x, y)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    nil
  end

  def get(grid, x, y) do
    grid |> elem(y) |> elem(x)
  end

  def perp({x, y}) do
    [{y, -x}, {-y, x}]
  end

  def run do
    grid =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn row -> row |> String.to_charlist() |> List.to_tuple() end)
      |> List.to_tuple()

    graph =
      -1..(tuple_size(grid) - 1)
      |> Enum.reduce(Graph.new(type: :undirected), fn y, graph ->
        -1..(tuple_size(elem(grid, 0)) - 1)
        |> Enum.reduce(graph, fn x, graph ->
          a = get(grid, x, y)

          [{1, 0}, {0, 1}]
          |> Enum.reduce(graph, fn {dx, dy}, graph ->
            b = get(grid, x + dx, y + dy)

            graph = if a != nil, do: graph |> Graph.add_vertex({x, y}), else: graph

            if a == b and a != nil and b != nil do
              Graph.add_edge(graph, {x, y}, {x + dx, y + dy})
            else
              graph
            end
          end)
        end)
      end)

    # {:ok, dot} = graph |> Graph.to_dot()
    # File.write(".graph.dot", dot)

    graph
    |> Graph.components()
    |> Enum.map(fn component ->
      area = component |> length()

      edges =
        component
        |> Enum.filter(&(Graph.degree(graph, &1) < 4))

      all_out_dirs =
        edges
        |> Enum.map(fn vert ->
          {x1, y1} = vert

          out_dirs =
            Graph.neighbors(graph, vert)
            |> Enum.reduce(MapSet.new([{1, 0}, {0, 1}, {-1, 0}, {0, -1}]), fn {x2, y2}, acc ->
              dx = x2 - x1
              dy = y2 - y1

              MapSet.delete(acc, {dx, dy})
            end)

          {vert, out_dirs}
        end)
        |> Map.new()

      subgraph = Graph.subgraph(graph, edges)

      sides =
        subgraph
        |> Graph.Reducers.Dfs.reduce(Graph.new(type: :undirected), fn {x1, y1} = vert,
                                                                      edge_graph ->
          out_dirs = all_out_dirs |> Map.get(vert)

          edge_graph =
            out_dirs
            |> Enum.reduce(edge_graph, fn {dx, dy}, edge_graph ->
              edge_graph |> Graph.add_vertex({x1, y1, dx, dy})
            end)

          neighbors = subgraph |> Graph.neighbors(vert) |> MapSet.new()

          res =
            out_dirs
            |> Enum.reduce(edge_graph, fn {dx, dy} = dir, edge_graph ->
              perp(dir)
              |> Enum.reduce(edge_graph, fn {pdx, pdy}, edge_graph ->
                other = {x1 + pdx, y1 + pdy}
                {x2, y2} = other

                if MapSet.member?(neighbors, other) and
                     Map.get(all_out_dirs, other) |> MapSet.member?(dir) do
                  edge_graph |> Graph.add_edge({x1, y1, dx, dy}, {x2, y2, dx, dy})
                else
                  edge_graph
                end
              end)
            end)

          {:next, res}
        end)
        |> Graph.components()

      length(sides) * area
    end)
    |> Enum.sum()
  end
end
