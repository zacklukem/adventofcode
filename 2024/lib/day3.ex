defmodule Day3a do
  def run do
    reg = ~r/mul\((\d+),(\d+)\)/
    src = File.read!(".input.txt")

    Regex.scan(reg, src)
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end
end

defmodule Day3b do
  def asdf(arr, doo? \\ true, acc \\ 0)

  def asdf([["don't()" | _] | tail], _, acc) do
    asdf(tail, false, acc)
  end

  def asdf([["do()" | _] | tail], _, acc) do
    asdf(tail, true, acc)
  end

  def asdf([[_, _, x, y] | tail], doo?, acc) do
    asdf(tail, doo?, acc + if(doo?, do: String.to_integer(x) * String.to_integer(y), else: 0))
  end

  def asdf([], _, acc) do
    acc
  end

  def run do
    reg = ~r/(mul\((\d+),(\d+)\)|do\(\)|don't\(\))/
    src = File.read!(".input.txt")

    Regex.scan(reg, src)
    |> asdf()
  end
end
