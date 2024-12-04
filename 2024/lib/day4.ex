defmodule Day4a do
  def get(grid, x, y)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    nil
  end

  def get(grid, x, y) do
    grid |> elem(y) |> elem(x)
  end

  def checkdir(grid, x, y, dx, dy, [ch | tail]) do
    if get(grid, x, y) == ch do
      checkdir(grid, x + dx, y + dy, dx, dy, tail)
    else
      false
    end
  end

  def checkdir(_, _, _, _, _, []) do
    true
  end

  def checkpos(grid, x, y) do
    [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]
    |> Enum.map(fn {dx, dy} ->
      if checkdir(grid, x, y, dx, dy, "XMAS" |> String.graphemes()), do: 1, else: 0
    end)
    |> Enum.sum()
  end

  def run do
    grid =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> x |> String.graphemes() |> List.to_tuple() end)
      |> List.to_tuple()

    0..(tuple_size(grid) - 1)
    |> Enum.map(fn y ->
      0..(tuple_size(elem(grid, 0)) - 1)
      |> Enum.map(fn x -> checkpos(grid, x, y) end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end
end

defmodule Day4b do
  def get(grid, x, y)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    nil
  end

  def get(grid, x, y) do
    grid |> elem(y) |> elem(x)
  end

  def is_good_map(map) do
    MapSet.equal?(map, MapSet.new(["M", "S"]))
  end

  def checkpos(grid, x, y) do
    if get(grid, x, y) === "A" do
      a = MapSet.new([get(grid, x - 1, y - 1), get(grid, x + 1, y + 1)])
      b = MapSet.new([get(grid, x + 1, y - 1), get(grid, x - 1, y + 1)])

      if is_good_map(a) and is_good_map(b), do: 1, else: 0
    else
      0
    end
  end

  def run do
    grid =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> x |> String.graphemes() |> List.to_tuple() end)
      |> List.to_tuple()

    0..(tuple_size(grid) - 1)
    |> Enum.map(fn y ->
      0..(tuple_size(elem(grid, 0)) - 1)
      |> Enum.map(fn x -> checkpos(grid, x, y) end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end
end
