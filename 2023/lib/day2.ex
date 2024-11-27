defmodule Day2a do
  def parse_line(line) do
    [game_dirty, values_dirty] = String.split(line, ": ")

    [_, game_id_str] = String.split(game_dirty)
    game_id = String.to_integer(game_id_str)

    values =
      String.split(values_dirty, "; ")
      |> Enum.map(fn subset_dirty ->
        String.split(subset_dirty, ", ")
        |> Enum.map(fn value_dirty ->
          [count, color] = String.split(value_dirty, " ")
          {color, String.to_integer(count)}
        end)
      end)

    {game_id, values}
  end

  def is_color_possible?({color, count}) do
    case color do
      "red" -> count <= 12
      "green" -> count <= 13
      "blue" -> count <= 14
      _ -> false
    end
  end

  def is_possible?(game) do
    game
    |> Enum.all?(fn subset ->
      subset
      |> Enum.all?(&is_color_possible?/1)
    end)
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn {_, values} -> is_possible?(values) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end
end

defmodule Day2b do
  def parse_line(line) do
    [game_dirty, values_dirty] = String.split(line, ": ")

    [_, game_id_str] = String.split(game_dirty)
    game_id = String.to_integer(game_id_str)

    values =
      String.split(values_dirty, "; ")
      |> Enum.map(fn subset_dirty ->
        String.split(subset_dirty, ", ")
        |> Enum.map(fn value_dirty ->
          [count, color] = String.split(value_dirty, " ")
          {String.to_atom(color), String.to_integer(count)}
        end)
        |> Enum.into(%{})
      end)

    {game_id, values}
  end

  def subset_max([values | tail], max) do
    maxp =
      max
      |> Enum.map(fn {color, count} ->
        {color,
         case Map.get(values, color) do
           nil -> count
           value -> max(count, value)
         end}
      end)
      |> Enum.into(%{})

    subset_max(tail, maxp)
  end

  def subset_max([], max) do
    max
  end

  def power(set) do
    set
    |> Enum.map(&elem(&1, 1))
    |> Enum.product()
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {_, values} -> subset_max(values, %{blue: 0, green: 0, red: 0}) end)
    |> Enum.map(&power/1)
    |> Enum.sum()
  end
end
