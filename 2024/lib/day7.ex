defmodule Day7a do
  def is_possible?(num, [value]) do
    value == num
  end

  def is_possible?(num, [a | [b | rest]]) do
    is_possible?(num, [a * b | rest]) or is_possible?(num, [a + b | rest])
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [num, raw_operands] = String.split(line, ": ")

      {String.to_integer(num),
       raw_operands |> String.split(" ") |> Enum.map(&String.to_integer/1)}
    end)
    |> Enum.filter(fn {num, operands} -> is_possible?(num, operands) end)
    |> Enum.map(fn {num, _} -> num end)
    |> Enum.sum()
  end
end

defmodule Day7b do
  def concat(a, b) do
    String.to_integer("#{a}#{b}")
  end

  def is_possible?(num, [value]) do
    value == num
  end

  def is_possible?(num, [a | [b | rest]]) do
    is_possible?(num, [a * b | rest]) or is_possible?(num, [a + b | rest]) or
      is_possible?(num, [concat(a, b) | rest])
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [num, raw_operands] = String.split(line, ": ")

      {String.to_integer(num),
       raw_operands |> String.split(" ") |> Enum.map(&String.to_integer/1)}
    end)
    |> Enum.filter(fn {num, operands} -> is_possible?(num, operands) end)
    |> Enum.map(fn {num, _} -> num end)
    |> Enum.sum()
  end
end
