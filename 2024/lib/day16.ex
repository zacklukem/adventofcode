defmodule Day16a do
  def run do
    grid =
      File.read!(".input.txt")
      |> Grid.gridify_tuple()

    graph =
      Grid.indices(grid)
      |> Enum.reduce(Graph.new(), fn pos, graph ->
        e = Grid.get(grid, pos)

        if e != ?# do
          TVec.dirs()
          |> Enum.reduce(graph, fn dir, graph ->
            graph =
              graph
              |> Graph.add_edge({pos, dir}, {pos, TVec.rot_cw(dir)}, weight: 1000)
              |> Graph.add_edge({pos, TVec.rot_cw(dir)}, {pos, dir}, weight: 1000)

            forward = TVec.add(pos, dir)

            if Grid.get(grid, forward) != ?# do
              graph |> Graph.add_edge({pos, dir}, {forward, dir}, weight: 1)
            else
              graph
            end
          end)
        else
          graph
        end
      end)

    start = Grid.indices(grid) |> Enum.find(&(Grid.get(grid, &1) == ?S))
    endd = Grid.indices(grid) |> Enum.find(&(Grid.get(grid, &1) == ?E))

    graph =
      TVec.dirs()
      |> Enum.reduce(graph, fn dir, graph ->
        graph |> Graph.add_edge({endd, dir}, {endd}, weight: 0)
      end)

    path = graph |> Graph.dijkstra({start, {1, 0}}, {endd})

    Enum.zip(path, tl(path))
    |> Enum.map(fn {a, b} ->
      Graph.edge(graph, a, b).weight
    end)
    |> Enum.sum()
  end
end

defmodule Day16b do
  def asdf(grid, queue, distances) do
    case PriorityQueue.pop(queue) do
      {:empty, _} ->
        distances

      {{:value, {pos, dir}}, queue} ->
        dist = distances |> Map.get({pos, dir})

        neighbors =
          [TVec.rot_cw(dir), TVec.rot_ccw(dir)]
          |> Enum.map(fn dir ->
            pos = TVec.add(pos, dir)
            {{pos, dir}, dist + 1001}
          end)

        front = TVec.add(pos, dir)

        neighbors = [{{front, dir}, dist + 1} | neighbors]

        {queue, distances} =
          neighbors
          |> Enum.reduce({queue, distances}, fn {{pos, dir}, dist}, {queue, distances} ->
            if Grid.get(grid, pos) == ?# or
                 (Map.has_key?(distances, {pos, dir}) and distances[{pos, dir}] <= dist) do
              {queue, distances}
            else
              queue = queue |> PriorityQueue.push({pos, dir}, dist)

              distances = distances |> Map.put({pos, dir}, dist)

              {queue, distances}
            end
          end)

        asdf(grid, queue, distances)
    end
  end

  def foo(_grid, _distances, {pos, _}, start, visited) when pos == start do
    visited
  end

  def foo(grid, distances, {pos, dir} = vert, start, visited) do
    visited = visited |> MapSet.put(pos)

    d = fn {_, dir2} = vert ->
      if dir2 == dir do
        distances[vert]
      else
        distances[vert] + 1000
      end
    end

    neighbors =
      TVec.dirs()
      |> Enum.flat_map(fn dir ->
        pos = TVec.add(pos, dir)
        TVec.dirs() |> Enum.map(&{pos, &1})
      end)
      |> Enum.filter(fn vert2 ->
        Map.has_key?(distances, vert2) and d.(vert2) <= d.(vert)
      end)

    if neighbors == [] do
      visited
    else
      min = neighbors |> Enum.min_by(&d.(&1))
      min = d.(min)

      neighbors
      |> Enum.filter(&(d.(&1) == min))
      |> Enum.reduce(visited, fn neighbor, visited ->
        foo(grid, distances, neighbor, start, visited)
      end)
    end
  end

  def run do
    grid =
      File.read!(".input.txt")
      |> Grid.gridify_tuple()

    start = Grid.indices(grid) |> Enum.find(&(Grid.get(grid, &1) == ?S))
    endd = Grid.indices(grid) |> Enum.find(&(Grid.get(grid, &1) == ?E))

    initial = {start, {1, 0}}

    distances =
      asdf(
        grid,
        PriorityQueue.new() |> PriorityQueue.push(initial, 0),
        Map.new() |> Map.put(initial, 0)
      )

    neighbors = TVec.dirs() |> Enum.map(fn dir -> {endd, dir} end)

    min = neighbors |> Enum.min_by(&Map.get(distances, &1))
    min = Map.get(distances, min)

    visited =
      neighbors
      |> Enum.filter(&(Map.get(distances, &1) == min))
      |> Enum.reduce(MapSet.new(), fn neighbor, visited ->
        foo(grid, distances, neighbor, start, visited)
      end)

    File.read!(".input.txt")
    |> Grid.gridify()
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {cell, x} ->
        if visited |> MapSet.member?({x, y}) do
          ?O
        else
          cell
        end
      end)
      |> to_string()
    end)
    |> Enum.join("\n")

    visited = visited |> MapSet.put(start)

    visited |> MapSet.size()
  end
end
