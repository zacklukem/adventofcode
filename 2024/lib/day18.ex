defmodule Day18a do
  defmacro width, do: quote(do: unquote(71))
  defmacro height, do: quote(do: unquote(71))
  defmacro take, do: quote(do: unquote(1024))

  def at(_, {x, y}) when x < 0 or y < 0 or x >= width() or y >= height() do
    nil
  end

  def at(walls, pos) do
    if MapSet.member?(walls, pos) do
      :wall
    else
      :empty
    end
  end

  def run do
    walls =
      File.read!(".input.txt")
      |> String.split("\n")
      |> Enum.map(fn line ->
        line |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)
      |> Enum.take(take())
      |> MapSet.new()

    graph =
      0..(width() - 1)
      |> Enum.reduce(Graph.new(type: :undirected), fn x, graph ->
        0..(height() - 1)
        |> Enum.reduce(graph, fn y, graph ->
          pos = {x, y}

          if at(walls, pos) == :empty do
            [{1, 0}, {0, 1}]
            |> Enum.reduce(graph, fn dir, graph ->
              pos2 = TVec.add(pos, dir)

              if at(walls, pos2) == :empty do
                graph |> Graph.add_edge(pos, pos2)
              else
                graph
              end
            end)
          else
            graph
          end
        end)
      end)

    # {:ok, dot} = graph |> Graph.to_dot()
    # File.write(".graph.dot", dot)

    (Graph.dijkstra(graph, {0, 0}, {width() - 1, height() - 1})
     |> length()) - 1
  end
end

defmodule Day18b do
  defmacro width, do: quote(do: unquote(71))
  defmacro height, do: quote(do: unquote(71))

  def at(_, {x, y}) when x < 0 or y < 0 or x >= width() or y >= height() do
    nil
  end

  def at(walls, pos) do
    if MapSet.member?(walls, pos) do
      :wall
    else
      :empty
    end
  end

  def asdf(walls_initial, take) do
    walls = walls_initial |> Enum.take(take) |> MapSet.new()

    graph =
      0..(width() - 1)
      |> Enum.reduce(Graph.new(type: :undirected), fn x, graph ->
        0..(height() - 1)
        |> Enum.reduce(graph, fn y, graph ->
          pos = {x, y}

          if at(walls, pos) == :empty do
            [{1, 0}, {0, 1}]
            |> Enum.reduce(graph, fn dir, graph ->
              pos2 = TVec.add(pos, dir)

              if at(walls, pos2) == :empty do
                graph |> Graph.add_edge(pos, pos2)
              else
                graph
              end
            end)
          else
            graph
          end
        end)
      end)

    Graph.a_star(graph, {0, 0}, {width() - 1, height() - 1}, fn {x, y} ->
      x + y
    end) == nil
  end

  def run do
    walls_initial =
      File.read!(".input.txt")
      |> String.split("\n")
      |> Enum.map(fn line ->
        line |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)

    walls_initial
    |> Enum.with_index()
    |> Enum.drop(3000)
    |> Enum.find(fn {_, n} ->
      IO.puts(n)
      asdf(walls_initial, n + 1)
    end)
  end
end
