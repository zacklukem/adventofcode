defmodule Day1a do
  def run do
    File.read!(".input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sort/1)
    |> List.zip()
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end
end

defmodule Day1b do
  def run do
    [left, right] =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)

    right_freq =
      right
      |> Enum.reduce(Map.new(), fn x, acc ->
        acc |> Map.update(x, 1, &(&1 + 1))
      end)

    left
    |> Enum.map(fn x -> x * Map.get(right_freq, x, 0) end)
    |> Enum.sum()
  end
end
