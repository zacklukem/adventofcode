defmodule Day20a do
  def djikstra(grid, queue, distances) do
    case PriorityQueue.pop(queue) do
      {:empty, _} ->
        distances

      {{:value, pos}, queue} ->
        dist = distances |> Map.get(pos)

        {queue, distances} =
          TVec.dirs()
          |> Enum.reduce({queue, distances}, fn dir, {queue, distances} ->
            pos = TVec.add(pos, dir)
            dist = dist + 1

            if Grid.get(grid, pos) == ?# or
                 (Map.has_key?(distances, pos) and distances[pos] <= dist) do
              {queue, distances}
            else
              queue = queue |> PriorityQueue.push(pos, dist)

              distances = distances |> Map.put(pos, dist)

              {queue, distances}
            end
          end)

        djikstra(grid, queue, distances)
    end
  end

  def cheats_starting_at(cheats, grid, p1, distances) do
    adj =
      TVec.dirs()
      |> Enum.map(&TVec.add(p1, &1))
      |> Enum.filter(&(Grid.get(grid, &1, ?#) != ?#))

    if adj == [] do
      cheats
    else
      max_dist1 =
        adj
        |> Enum.map(&distances[&1])
        |> Enum.max()

      TVec.dirs()
      |> Enum.map(&TVec.add(p1, &1))
      |> Enum.filter(&(Grid.get(grid, &1) != nil))
      |> Enum.reduce(cheats, fn p2, cheats ->
        if distances[p2] != nil do
          savings = max_dist1 - distances[p2] - 2

          if savings > 0 do
            cheats |> Map.put({p1, p2}, savings)
          else
            cheats
          end
        else
          cheats
        end
      end)
    end
  end

  def run do
    grid =
      File.read!(".input.txt")
      |> Grid.gridify_tuple()

    endd = Grid.indices(grid) |> Enum.find(&(Grid.get(grid, &1) == ?E))

    distances = djikstra(grid, PriorityQueue.new() |> PriorityQueue.push(endd, 0), %{{endd, 0}})

    cheats =
      Grid.indices(grid)
      |> Enum.filter(&(Grid.get(grid, &1) == ?#))
      |> Enum.reduce(Map.new(), fn pos, cheats ->
        cheats |> cheats_starting_at(grid, pos, distances)
      end)

    cheats
    |> Map.values()
    |> Enum.filter(&(&1 >= 100))
    |> Enum.count()
  end
end

defmodule Day20b do
  def djikstra(grid, queue, distances) do
    case PriorityQueue.pop(queue) do
      {:empty, _} ->
        distances

      {{:value, pos}, queue} ->
        dist = distances |> Map.get(pos)

        {queue, distances} =
          TVec.dirs()
          |> Enum.reduce({queue, distances}, fn dir, {queue, distances} ->
            pos = TVec.add(pos, dir)
            dist = dist + 1

            if Grid.get(grid, pos) == ?# or
                 (Map.has_key?(distances, pos) and distances[pos] <= dist) do
              {queue, distances}
            else
              queue = queue |> PriorityQueue.push(pos, dist)

              distances = distances |> Map.put(pos, dist)

              {queue, distances}
            end
          end)

        djikstra(grid, queue, distances)
    end
  end

  def pico_between(a, b) do
    {x, y} = TVec.map(TVec.sub(a, b), &abs/1)
    x + y
  end

  def ending_pos_within_20(pos, distances) do
    -20..20
    |> Enum.flat_map(fn x ->
      -20..20
      |> Enum.map(&{x, &1})
      |> Enum.filter(&(pico_between(&1, {0, 0}) <= 20))
    end)
    |> Enum.map(&TVec.add(&1, pos))
    |> Enum.filter(&(&1 !== pos and distances[&1] != nil))
  end

  def cheats_starting_at(cheats, _grid, p1, distances) do
    max_dist1 = distances[p1]

    ending_pos_within_20(p1, distances)
    |> Enum.reduce(cheats, fn p2, cheats ->
      savings = max_dist1 - distances[p2] - pico_between(p1, p2)

      if savings > 0 do
        cheats |> Map.put({p1, p2}, savings)
      else
        cheats
      end
    end)
  end

  def run do
    grid =
      File.read!(".input.txt")
      |> Grid.gridify_tuple()

    endd = Grid.indices(grid) |> Enum.find(&(Grid.get(grid, &1) == ?E))

    distances = djikstra(grid, PriorityQueue.new() |> PriorityQueue.push(endd, 0), %{{endd, 0}})

    cheats =
      Grid.indices(grid)
      |> Enum.filter(&(distances[&1] != nil))
      |> Enum.reduce(Map.new(), fn pos, cheats ->
        cheats |> cheats_starting_at(grid, pos, distances)
      end)

    cheats
    |> Map.values()
    |> Enum.filter(&(&1 >= 100))
    |> Enum.count()
  end
end
