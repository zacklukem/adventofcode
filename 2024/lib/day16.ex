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
  # def asdf({graph, visited}, grid, {pos, dir} = vert) do
  #   if visited |> MapSet.member?(vert) do
  #     {graph, visited}
  #   else
  #     visited = visited |> MapSet.put(vert)

  #     {graph, visited} =
  #       [TVec.rot_cw(dir), TVec.rot_ccw(dir)]
  #       |> Enum.reduce({graph, visited}, fn dir, {graph, visited} ->
  #         # if Graph.has_vertex?(graph, {pos, dir}) do
  #         #   {graph, visited}
  #         # else
  #         graph = graph |> Graph.add_edge(vert, {pos, dir}, weight: 1000)

  #         {graph, visited} |> asdf(grid, {pos, dir})
  #         # end
  #       end)

  #     forward = TVec.add(pos, dir)

  #     if Grid.get(grid, forward) != ?# do
  #       graph = graph |> Graph.add_edge(vert, {forward, dir}, weight: 1)
  #       {graph, visited} |> asdf(grid, {forward, dir})
  #     else
  #       {graph, visited}
  #     end
  #   end
  # end

  # def asdf(graph, visited, queue, grid) do
  #   if :queue.is_empty(queue) do
  #     graph
  #   else
  #     {pos, dir} = vert = :queue.head(queue)
  #     queue = :queue.tail(queue)

  #     visited = visited |> MapSet.put(vert)

  #     {graph, queue} =
  #       [TVec.rot_cw(dir), TVec.rot_ccw(dir)]
  #       |> Enum.reduce({graph, queue}, fn dir, {graph, queue} ->
  #         graph =
  #           if Graph.edge(graph, {pos, dir}, vert) == nil do
  #             graph |> Graph.add_edge(vert, {pos, dir}, weight: 1000)
  #           else
  #             graph
  #           end

  #         queue =
  #           if visited |> MapSet.member?({pos, dir}) do
  #             queue
  #           else
  #             :queue.snoc(queue, {pos, dir})
  #           end

  #         {graph, queue}
  #       end)

  #     forward = TVec.add(pos, dir)

  #     {graph, queue} =
  #       if Grid.get(grid, forward) != ?# do
  #         graph = graph |> Graph.add_edge(vert, {forward, dir}, weight: 1)

  #         queue =
  #           if visited |> MapSet.member?({forward, dir}) do
  #             queue
  #           else
  #             :queue.snoc(queue, {forward, dir})
  #           end

  #         {graph, queue}
  #       else
  #         {graph, queue}
  #       end

  #     asdf(graph, visited, queue, grid)
  #   end
  # end

  # def remove_cycles(graph, visited) do

  # end

  # @spec foo(Graph.t(), any(), any(), any()) :: any()
  # def foo(graph, bf, vert, acc) do
  #   best =
  #     Graph.neighbors(graph, vert)
  #     |> Enum.min_by(fn x -> bf[Graph.Utils.vertex_id(x)] end)

  #   if best do
  #     foo(graph, bf, best, acc + Graph.edge(graph, vert, best).weight)
  #   else
  #     acc
  #   end
  # end

  # def reverse_graph(graph) do
  #   graph
  #   |> Graph.edges()
  #   |> Enum.reduce(Graph.new(), fn edge, graph ->
  #     graph |> Graph.add_edge(edge.v2, edge.v1, weight: edge.weight)
  #   end)
  # end

  # def asdf(grid, queue, distances) do
  #   if :queue.is_empty(queue) do
  #     distances
  #   else
  #     {pos, dir} = :queue.head(queue)
  #     queue = :queue.tail(queue)

  #     dist = distances |> Map.get({pos, dir})

  #     {queue, distances} =
  #       [TVec.rot_cw(dir), TVec.rot_ccw(dir)]
  #       |> Enum.reduce({queue, distances}, fn dir, {queue, distances} ->
  #         pos = TVec.add(pos, dir)
  #         # Should the or be there?
  #         # or distances |> Map.has_key?({pos, TVec.invert(dir)})
  #         if distances |> Map.has_key?({pos, dir}) do
  #           {queue, distances}
  #         else
  #           if Grid.get(grid, pos) == ?# do
  #             {queue, distances}
  #           else
  #             queue = queue |> :queue.snoc({pos, dir})
  #             distances = distances |> Map.put({pos, dir}, dist + 1001)

  #             {queue, distances}
  #           end
  #         end
  #       end)

  #     front = TVec.add(pos, dir)

  #     {queue, distances} =
  #       if Grid.get(grid, front) == ?# or
  #            distances
  #            |> Map.has_key?({front, dir}) do
  #         {queue, distances}
  #       else
  #         queue = queue |> :queue.snoc({front, dir})

  #         distances = distances |> Map.put({front, dir}, dist + 1)

  #         {queue, distances}
  #       end

  #     asdf(grid, queue, distances)
  #   end
  # end
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

        # {queue, distances} =
        #   [TVec.rot_cw(dir), TVec.rot_ccw(dir)]
        #   |> Enum.reduce({queue, distances}, fn dir, {queue, distances} ->
        #     pos = TVec.add(pos, dir)
        #     # Should the or be there?
        #     # or distances |> Map.has_key?({pos, TVec.invert(dir)})
        #     if distances |> Map.has_key?({pos, dir}) do
        #       {queue, distances}
        #     else
        #       if Grid.get(grid, pos) == ?# do
        #         {queue, distances}
        #       else
        #         queue = queue |> PriorityQueue.push({pos, dir}, dist + 1001)

        #         distances = distances |> Map.put({pos, dir}, dist + 1001)

        #         {queue, distances}
        #       end
        #     end
        #   end)

        # front = TVec.add(pos, dir)

        # {queue, distances} =
        #   if Grid.get(grid, front) == ?# or
        #        distances
        #        |> Map.has_key?({front, dir}) do
        #     {queue, distances}
        #   else
        #     queue = queue |> PriorityQueue.push({front, dir}, dist + 1)

        #     distances = distances |> Map.put({front, dir}, dist + 1)

        #     {queue, distances}
        #   end

        asdf(grid, queue, distances)
    end
  end

  def foo(_grid, _distances, {pos, _}, start, visited) when pos == start do
    visited
  end

  def foo(grid, distances, {pos, dir} = vert, start, visited) do
    visited = visited |> MapSet.put(pos)

    # neighbors =
    #   [TVec.rot_cw(dir), TVec.rot_ccw(dir)]
    #   |> Enum.map(fn dir -> {TVec.sub(pos, dir), dir} end)
    #   |> Enum.filter(fn {pos, _} -> Grid.get(grid, pos) != ?# end)

    # front = TVec.sub(pos, dir)

    # neighbors =
    #   if Grid.get(grid, front) == ?# do
    #     neighbors
    #   else
    #     [{front, dir} | neighbors]
    #   end
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

    # |> IO.puts()
    visited = visited |> MapSet.put(start)

    visited |> MapSet.size()
    # {distances, visited}

    # min

    # |> MapSet.size()

    # foo(grid, distances, {{13, 1}, {0, 1}}, start, MapSet.new())
    # |> MapSet.size()

    # distances

    # # graph = asdf(Graph.new(), MapSet.new(), :queue.cons({start, {1, 0}}, :queue.new()), grid)
    # graph =
    #   Grid.indices(grid)
    #   |> Enum.reduce(Graph.new(), fn pos, graph ->
    #     e = Grid.get(grid, pos)

    #     if e != ?# do
    #       TVec.dirs()
    #       |> Enum.reduce(graph, fn dir, graph ->
    #         graph =
    #           graph
    #           |> Graph.add_edge({pos, dir}, {pos, TVec.rot_cw(dir)}, weight: 1000)
    #           |> Graph.add_edge({pos, TVec.rot_cw(dir)}, {pos, dir}, weight: 1000)

    #         forward = TVec.add(pos, dir)

    #         if Grid.get(grid, forward) != ?# do
    #           graph |> Graph.add_edge({pos, dir}, {forward, dir}, weight: 1)
    #         else
    #           graph
    #         end
    #       end)
    #     else
    #       graph
    #     end
    #   end)

    # graph =
    #   TVec.dirs()
    #   |> Enum.reduce(graph, fn dir, graph ->
    #     graph |> Graph.add_edge({endd, dir}, {endd}, weight: 0)
    #   end)

    # {:ok, dot} = graph |> Graph.to_dot()
    # File.write(".graph.dot", dot)

    # IO.puts("djik")

    # IO.puts("time: #{Graph.num_edges(graph) * Graph.num_vertices(graph)}")

    # {graph, _} =
    #   graph
    #   |> Graph.Reducers.Bfs.reduce({graph, MapSet.new()}, fn vert, {graph, visited} ->
    #     visited = visited |> MapSet.put(vert)

    #     graph =
    #       Graph.neighbors(graph, vert)
    #       |> Enum.reduce(graph, fn next, graph ->
    #         if visited |> MapSet.member?(next) do
    #           graph |> Graph.delete_edge(vert, next)
    #         else
    #           graph
    #         end
    #       end)

    #     {:next, {graph, visited}}
    #   end)

    # IO.puts("Is asyclic: #{Graph.is_acyclic?(graph)}")

    # Graph.re
    # bf = Graph.bellman_ford(graph, {start, {1, 0}})

    # foo(graph |> reverse_graph(), bf, {endd}, 0)

    # Graph.Utils.vertex_id({start, {1, 0}})

    # Graph.vertex_labels(graph, {start, {1, 0}})

    # Graph.get_paths()
    # asdf =
    #   Graph.get_paths(graph, {start, {1, 0}}, {endd})
    #   |> Enum.map(fn path ->
    #     len =
    #       Enum.zip(path, tl(path))
    #       |> Enum.map(fn {a, b} ->
    #         Graph.edge(graph, a, b).weight
    #       end)
    #       |> Enum.sum()

    #     pos = MapSet.new(path |> Enum.map(&elem(&1, 0)))

    #     {len, pos}
    #   end)

    # {min, _} = asdf |> Enum.min_by(&elem(&1, 0))

    # asdf
    # |> Enum.filter(&(elem(&1, 0) == min))
    # |> Enum.reduce(MapSet.new(), fn {_, xyz}, acc ->
    #   MapSet.union(xyz, acc)
    # end)
    # |> MapSet.size()

    # Graph.
    # path = graph |> Graph.dijkstra({start, {1, 0}}, {endd})
  end
end

#             11111
#   012345678901234
#  0###############
#  1#.......#....O#
#  2#.#.###.#.###O#
#  3#.....#.#...#O#
#  4#.###.#####.#O#
#  5#.#.#.......#O#
#  6#.#.#####.###O#
#  7#..OOOOOOOOO#O#
#  8###O#O#####O#O#
#  9#OOO#O....#O#O#
# 10#O#O#O###.#O#O#
# 11#OOOOO#...#O#O#
# 12#O###.#.#.#O#O#
# 13#S..#.....#OOO#
# 14###############

#             1111111
#   01234567890123456
#  0#################
#  1#...#...#...#..O#
#  2#.#.#.#.#.#.#.#O#
#  3#.#.#.#...#...#O#
#  4#.#.#.#.###.#.#O#
#  5#OOO#.#.#.....#O#
#  6#O#O#.#.#.#####O#
#  7#O#O..#.#.#OOOOO#
#  8#O#O#####.#O###.#
#  9#O#O#..OOOOO#...#
# 10#O#O###O#####.###
# 11#O#O#OOO#.....#.#
# 12#O#O#O#####.###.#
# 13#O#O#O........#.#
# 14#O#O#O#########.#
# 15#S#OOO..........#
# 16#################
