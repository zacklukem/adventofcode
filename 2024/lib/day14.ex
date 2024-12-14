defmodule Day14a do
  defmacro width, do: quote(do: 101)
  defmacro height, do: quote(do: 103)

  def wrap(x, dim) when x < 0, do: x + dim
  def wrap(x, dim), do: rem(x, dim)

  def run do
    state =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(" ")
        |> Enum.map(fn vec ->
          [_, vec] = String.split(vec, "=")
          vec |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
        end)
        |> List.to_tuple()
      end)

    1..100
    |> Enum.reduce(state, fn _, state ->
      Enum.map(state, fn {pos, vel} ->
        {x, y} =
          TVec.add(pos, vel)

        pos = {wrap(x, width()), wrap(y, height())}

        {pos, vel}
      end)
    end)
    |> Enum.map(fn {{x, y}, _} ->
      midx = div(width(), 2)
      midy = div(height(), 2)

      cond do
        x < midx and y < midy -> :top_left
        x < midx and y > midy -> :bottom_left
        x > midx and y < midy -> :top_right
        x > midx and y > midy -> :bottom_right
        true -> nil
      end
    end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.product()
  end
end

defmodule Day14b do
  defmacro width, do: quote(do: 101)
  defmacro height, do: quote(do: 103)

  def wrap(x, dim) when x < 0, do: x + dim
  def wrap(x, dim), do: rem(x, dim)

  def print(state, i) do
    robots = state |> Enum.map(&elem(&1, 0)) |> MapSet.new()

    Enum.each(0..(height() - 1), fn y ->
      Enum.each(0..(width() - 1), fn x ->
        if robots |> MapSet.member?({x, y}) do
          IO.write("X")
        else
          IO.write(".")
        end
      end)

      IO.puts("")
    end)

    IO.puts("")

    IO.gets("#{i}")

    state
  end

  def has_christmas_like(robots) do
    robots
    |> Enum.count(fn pos ->
      [1, 2, 3, 4, 5]
      |> Enum.all?(fn i ->
        robots |> MapSet.member?(TVec.add(pos, {i, 0}))
      end) or
        [1, 2, 3, 4, 5]
        |> Enum.all?(fn i ->
          robots |> MapSet.member?(TVec.add(pos, {0, i}))
        end)
    end) > 3
  end

  def run do
    state =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(" ")
        |> Enum.map(fn vec ->
          [_, vec] = String.split(vec, "=")
          vec |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
        end)
        |> List.to_tuple()
      end)

    1..100_000
    |> Enum.reduce(state, fn i, state ->
      robots = state |> Enum.map(&elem(&1, 0)) |> MapSet.new()

      if has_christmas_like(robots) do
        print(state, i - 1)
      end

      state
      |> Enum.map(fn {pos, vel} ->
        {x, y} =
          TVec.add(pos, vel)

        pos = {wrap(x, width()), wrap(y, height())}

        {pos, vel}
      end)
    end)
    |> Enum.map(fn {{x, y}, _} ->
      midx = div(width(), 2)
      midy = div(height(), 2)

      cond do
        x < midx and y < midy -> :top_left
        x < midx and y > midy -> :bottom_left
        x > midx and y < midy -> :top_right
        x > midx and y > midy -> :bottom_right
        true -> nil
      end
    end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.product()
  end
end
