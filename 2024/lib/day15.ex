defmodule Day15a do
  def asdf(grid, dir) do
    pos = find_pos(grid)
    grid |> asdf(dir, pos)
  end

  def asdf(grid, dir, pos) do
    p2 = TVec.add(dir, pos)

    cond do
      Grid.get(grid, p2) == nil ->
        grid
        |> Grid.set(p2, Grid.get(grid, pos))
        |> Grid.set(pos, nil)

      Grid.get(grid, p2) == :wall ->
        grid

      true ->
        grid = grid |> asdf(dir, p2)

        if Grid.get(grid, p2) == nil do
          grid
          |> Grid.set(p2, Grid.get(grid, pos))
          |> Grid.set(pos, nil)
        else
          grid
        end
    end
  end

  def find_pos(grid) do
    grid
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.find_value(fn {row, y} ->
      x = row |> Tuple.to_list() |> Enum.find_index(&(&1 == :robot))
      x && {x, y}
    end)
  end

  def print(grid) do
    grid
    |> Tuple.to_list()
    |> Enum.map(fn row ->
      row
      |> Tuple.to_list()
      |> Enum.map(fn
        :wall -> ?#
        :box -> ?O
        :robot -> ?@
        _ -> ?.
      end)
      |> to_string()
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def run do
    [grid, moves] =
      File.read!(".input.txt")
      |> String.split("\n\n")

    grid = Grid.gridify(grid)

    grid =
      grid
      |> Enum.map(fn row ->
        row
        |> Enum.map(fn
          ?# -> :wall
          ?O -> :box
          ?@ -> :robot
          _ -> nil
        end)
        |> List.to_tuple()
      end)
      |> List.to_tuple()

    moves =
      moves
      |> String.to_charlist()
      |> Enum.filter(&(&1 != ?\n))
      |> Enum.map(fn
        ?< -> {-1, 0}
        ?v -> {0, 1}
        ?> -> {1, 0}
        ?^ -> {0, -1}
      end)

    grid =
      moves
      |> Enum.reduce(grid, fn move, grid ->
        # pretty_move =
        #   case move do
        #     {-1, 0} -> ?<
        #     {0, 1} -> ?v
        #     {1, 0} -> ?>
        #     {0, -1} -> ?^
        #   end

        # print(grid)
        # IO.gets("#{[pretty_move]}")

        grid |> asdf(move)
      end)

    grid
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Tuple.to_list()
      |> Enum.with_index()
      |> Enum.filter(fn {cell, _} -> cell == :box end)
      |> Enum.map(fn {_, x} -> 100 * y + x end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end
end

defmodule Day15b do
  def branches(grid, {_, y}, pos) do
    if y == 0 do
      [pos]
    else
      case Grid.get(grid, pos) do
        :boxl -> [pos, TVec.add(pos, {1, 0})]
        :boxr -> [pos, TVec.add(pos, {-1, 0})]
        :robot -> [pos]
      end
    end
  end

  def asdf(grid, dir) do
    pos = find_pos(grid)

    if can_move(grid, dir, pos) do
      grid |> asdf(dir, pos)
    else
      grid
    end
  end

  def asdf(grid, dir, pos) do
    poss = branches(grid, dir, pos)

    poss
    |> Enum.reduce(grid, fn pos, grid ->
      front = TVec.add(pos, dir)

      grid =
        if Grid.get(grid, front) != nil do
          asdf(grid, dir, front)
        else
          grid
        end

      if Grid.get(grid, front) != nil do
        IO.puts("ERROR DETECTED")
      end

      grid
      |> Grid.set(front, Grid.get(grid, pos))
      |> Grid.set(pos, nil)
    end)
  end

  def can_move(grid, dir, pos) do
    poss = branches(grid, dir, pos)

    poss
    |> Enum.all?(fn pos ->
      front = TVec.add(pos, dir)

      in_front = Grid.get(grid, front)

      in_front == nil or (in_front != :wall and can_move(grid, dir, front))
    end)
  end

  def find_pos(grid) do
    grid
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.find_value(fn {row, y} ->
      x = row |> Tuple.to_list() |> Enum.find_index(&(&1 == :robot))
      x && {x, y}
    end)
  end

  def print(grid) do
    grid
    |> Tuple.to_list()
    |> Enum.map(fn row ->
      row
      |> Tuple.to_list()
      |> Enum.map(fn
        :wall -> ?#
        :boxl -> ?[
        :boxr -> ?]
        :robot -> ?@
        _ -> ?.
      end)
      |> to_string()
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def run do
    [grid, moves] =
      File.read!(".input.txt")
      |> String.split("\n\n")

    grid = Grid.gridify(grid)

    grid =
      grid
      |> Enum.map(fn row ->
        row
        |> Enum.flat_map(fn
          ?# -> [:wall, :wall]
          ?O -> [:boxl, :boxr]
          ?@ -> [:robot, nil]
          _ -> [nil, nil]
        end)
        |> List.to_tuple()
      end)
      |> List.to_tuple()

    moves =
      moves
      |> String.to_charlist()
      |> Enum.filter(&(&1 != ?\n))
      |> Enum.map(fn
        ?< -> {-1, 0}
        ?v -> {0, 1}
        ?> -> {1, 0}
        ?^ -> {0, -1}
      end)

    grid =
      moves
      |> Enum.reduce(grid, fn move, grid ->
        # pretty_move =
        #   case move do
        #     {-1, 0} -> ?<
        #     {0, 1} -> ?v
        #     {1, 0} -> ?>
        #     {0, -1} -> ?^
        #   end

        # print(grid)
        # IO.gets("#{[pretty_move]}")

        grid |> asdf(move)
      end)

    grid
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Tuple.to_list()
      |> Enum.with_index()
      |> Enum.filter(fn {cell, _} -> cell == :boxl end)
      |> Enum.map(fn {_, x} -> 100 * y + x end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end
end
