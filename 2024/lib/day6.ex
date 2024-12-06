defmodule Day6a do
  def parse_char(ch) do
    case ch do
      "#" -> :blocked
      _ -> :open
    end
  end

  def find_guard(ch) do
    case ch do
      "^" -> {0, -1}
      "v" -> {0, 1}
      "<" -> {-1, 0}
      ">" -> {1, 0}
      _ -> nil
    end
  end

  def add_pos({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end

  def at(grid, {x, y}) do
    if y < 0 or y >= tuple_size(grid) do
      nil
    else
      row = elem(grid, y)

      if x < 0 or x >= tuple_size(row) do
        nil
      else
        elem(row, x)
      end
    end
  end

  def turn_right({x, y}) do
    {-y, x}
  end

  def is_loop?(grid, pos, dir, distinct) do
    cell = at(grid, add_pos(pos, dir))

    case cell do
      :open -> is_loop?(grid, add_pos(pos, dir), dir, MapSet.put(distinct, pos))
      :blocked -> is_loop?(grid, pos, turn_right(dir), distinct)
      nil -> MapSet.size(MapSet.put(distinct, pos))
    end
  end

  def run do
    grid_raw =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> x |> String.graphemes() end)

    {{initial_dir, initial_x}, initial_y} =
      grid_raw
      |> Enum.map(fn row ->
        cell =
          row
          |> Enum.with_index()
          |> Enum.find(&find_guard(elem(&1, 0)))

        if not is_nil(cell) do
          {find_guard(elem(cell, 0)), elem(cell, 1)}
        end
      end)
      |> Enum.with_index()
      |> Enum.find(&(not is_nil(elem(&1, 0))))

    grid =
      grid_raw
      |> Enum.map(fn x -> x |> Enum.map(&parse_char/1) |> List.to_tuple() end)
      |> List.to_tuple()

    is_loop?(grid, {initial_x, initial_y}, initial_dir, MapSet.new())
  end
end

defmodule Day6b do
  def parse_char(ch) do
    case ch do
      "#" -> :blocked
      _ -> :open
    end
  end

  def find_guard(ch) do
    case ch do
      "^" -> {0, -1}
      "v" -> {0, 1}
      "<" -> {-1, 0}
      ">" -> {1, 0}
      _ -> nil
    end
  end

  def add_pos({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end

  def at(grid, {x, y}) do
    if y < 0 or y >= tuple_size(grid) do
      nil
    else
      row = elem(grid, y)

      if x < 0 or x >= tuple_size(row) do
        nil
      else
        elem(row, x)
      end
    end
  end

  def turn_right({x, y}) do
    {-y, x}
  end

  def is_loop?(grid, pos, dir, distinct) do
    if MapSet.member?(distinct, {pos, dir}) do
      true
    else
      cell = at(grid, add_pos(pos, dir))

      case cell do
        :open -> is_loop?(grid, add_pos(pos, dir), dir, MapSet.put(distinct, {pos, dir}))
        :blocked -> is_loop?(grid, pos, turn_right(dir), MapSet.put(distinct, {pos, dir}))
        nil -> false
      end
    end
  end

  def is_new_grid_loop?(grid, pos, dir, {obs_x, obs_y}) do
    grid = grid |> put_elem(obs_y, elem(grid, obs_y) |> put_elem(obs_x, :blocked))

    is_loop?(grid, pos, dir, MapSet.new())
  end

  def run do
    grid_raw =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> x |> String.graphemes() end)

    {{initial_dir, initial_x}, initial_y} =
      grid_raw
      |> Enum.map(fn row ->
        cell =
          row
          |> Enum.with_index()
          |> Enum.find(&find_guard(elem(&1, 0)))

        if not is_nil(cell) do
          {find_guard(elem(cell, 0)), elem(cell, 1)}
        end
      end)
      |> Enum.with_index()
      |> Enum.find(&(not is_nil(elem(&1, 0))))

    grid =
      grid_raw
      |> Enum.map(fn x -> x |> Enum.map(&parse_char/1) |> List.to_tuple() end)
      |> List.to_tuple()

    grid_raw
    |> Enum.with_index()
    |> Enum.reduce(0, fn {row, y}, acc ->
      row_count =
        row
        |> Enum.with_index()
        |> Enum.reduce(0, fn {cell, x}, acc ->
          if cell === "." and is_new_grid_loop?(grid, {initial_x, initial_y}, initial_dir, {x, y}) do
            acc + 1
          else
            acc
          end
        end)

      row_count + acc
    end)
  end
end
