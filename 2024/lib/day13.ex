alias Decimal, as: D

defmodule Day13a do
  def parse(str) do
    [a, b, prize] =
      str
      |> String.split("\n")
      |> Enum.map(fn line ->
        [_, pos] = line |> String.split(": ")

        [x, y] =
          pos |> String.split(", ") |> Enum.map(&String.byte_slice(&1, 2, byte_size(&1) - 1))

        {String.to_integer(x), String.to_integer(y)}
      end)

    {a, b, prize}
  end

  def divv(a, b) when is_integer(a) and is_integer(b) and rem(a, b) == 0 do
    div(a, b)
  end

  def divv(a, b) do
    a / b
  end

  def solve({{a1, a2}, {b1, b2}, {p1, p2}}) do
    a =
      0..100
      |> Enum.find(fn a ->
        b = divv(p1 - a1 * a, b1)

        p1r = a1 * a + b1 * b
        p2r = a2 * a + b2 * b

        is_integer(a) and is_integer(b) and p1r == p1 and p2r == p2
      end)

    if a != nil do
      b = divv(p1 - a1 * a, b1)

      a * 3 + b
    else
      0
    end
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n\n")
    |> Enum.map(&parse/1)
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end
end

defmodule Day13b do
  def parse(str) do
    [a, b, {px, py}] =
      str
      |> String.split("\n")
      |> Enum.map(fn line ->
        [_, pos] = line |> String.split(": ")

        [x, y] =
          pos |> String.split(", ") |> Enum.map(&String.byte_slice(&1, 2, byte_size(&1) - 1))

        {D.new(x), D.new(y)}
      end)

    {a, b, {D.add(px, 10_000_000_000_000), D.add(py, 10_000_000_000_000)}}
  end

  def divv(a, b) when is_integer(a) and is_integer(b) and rem(a, b) == 0 do
    div(a, b)
  end

  def divv(a, b) do
    a / b
  end

  def solve({{a1, a2}, {b1, b2}, {p1, p2}}) do
    b =
      D.div(
        D.sub(p2, D.div(D.mult(a2, p1), a1)),
        D.sub(b2, D.div(D.mult(a2, b1), a1))
      )

    a = D.div(D.sub(p1, D.mult(b1, b)), a1)

    is_int =
      [a, b]
      |> Enum.all?(fn v ->
        D.lt?(
          D.abs(D.sub(v, D.round(v))),
          D.new("0.0000000001")
        )
      end)

    if is_int do
      D.to_integer(D.round(a)) * 3 + D.to_integer(D.round(b))
    else
      0
    end
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n\n")
    |> Enum.map(&parse/1)
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end
end
