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
  def concat(a, b, bases \\ [10, 100, 1000, 10000])

  def concat(a, b, [base | _]) when b < base do
    a * base + b
  end

  def concat(a, b, [_ | rest]) do
    concat(a, b, rest)
  end

  def concat(a, b, []) do
    a * :math.pow(10, :math.ceil(:math.log10(b))) + b
  end

  def is_possible?(num, [value]) do
    value == num
  end

  def is_possible?(num, [a | _]) when a > num do
    false
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
    |> Task.async_stream(fn {num, operands} -> {num, is_possible?(num, operands)} end)
    |> Stream.map(fn {:ok, val} -> val end)
    |> Stream.filter(fn {_, possible} -> possible end)
    |> Stream.map(fn {num, _} -> num end)
    |> Enum.sum()
  end
end
