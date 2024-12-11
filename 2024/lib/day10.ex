defmodule Day10a do
  def get(grid, x, y)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    nil
  end

  def get(grid, x, y) do
    grid |> elem(y) |> elem(x)
  end

  def score(input, x, y, exp \\ 0, visited \\ MapSet.new()) do
    if MapSet.member?(visited, {x, y, exp}) do
      {visited, 0}
    else
      visited = MapSet.put(visited, {x, y, exp})

      case get(input, x, y) do
        ^exp ->
          if exp == 9 do
            {visited, 1}
          else
            [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]
            |> Enum.reduce({visited, 0}, fn {dx, dy}, {visited, count} ->
              {visited, count2} = score(input, x + dx, y + dy, exp + 1, visited)
              {visited, count + count2}
            end)
          end

        _ ->
          {visited, 0}
      end
    end
  end

  def run do
    input =
      File.read!(".input.txt")
      |> String.split("\n")
      |> Enum.map(fn line ->
        line |> String.to_charlist() |> Enum.map(&(&1 - ?0)) |> List.to_tuple()
      end)
      |> List.to_tuple()

    0..(tuple_size(input) - 1)
    |> Enum.map(fn y ->
      0..(tuple_size(elem(input, 0)) - 1)
      |> Enum.map(fn x -> score(input, x, y) |> elem(1) end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end
end

defmodule Day10b do
  def get(grid, x, y)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    nil
  end

  def get(grid, x, y) do
    grid |> elem(y) |> elem(x)
  end

  def score(input, x, y, exp \\ 0) do
    case get(input, x, y) do
      ^exp ->
        if exp == 9 do
          1
        else
          [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]
          |> Enum.reduce(0, fn {dx, dy}, count ->
            count + score(input, x + dx, y + dy, exp + 1)
          end)
        end

      _ ->
        0
    end
  end

  def run do
    input =
      File.read!(".input.txt")
      |> String.split("\n")
      |> Enum.map(fn line ->
        line |> String.to_charlist() |> Enum.map(&(&1 - ?0)) |> List.to_tuple()
      end)
      |> List.to_tuple()

    0..(tuple_size(input) - 1)
    |> Enum.map(fn y ->
      0..(tuple_size(elem(input, 0)) - 1)
      |> Enum.map(fn x -> score(input, x, y) end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end
end
