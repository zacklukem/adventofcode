defmodule TVec do
  @type t2 :: {number(), number()}

  @spec add(t2(), t2()) :: t2()
  def add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  @spec sub(t2(), t2()) :: t2()
  def sub({x1, y1}, {x2, y2}), do: {x1 - x2, y1 - y2}

  @spec mult(t2(), number()) :: t2()
  def mult({x, y}, a), do: {x * a, y * a}

  @spec div(t2(), number()) :: t2()
  def div({x, y}, a), do: {x / a, y / a}

  @spec map(t2(), (number() -> number())) :: t2()
  def map({x, y}, fun), do: {fun.(x), fun.(y)}
end

defmodule Grid do
  def gridify(str) do
    str |> String.split("\n") |> Enum.map(&String.to_charlist/1)
  end

  def gridify_tuple(str) do
    gridify(str) |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
  end

  def set(grid, {x, y}, _)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    grid
  end

  def set(grid, {x, y}, value) do
    row = grid |> elem(y) |> put_elem(x, value)
    grid |> put_elem(y, row)
  end

  def get(grid, {x, y})
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    nil
  end

  def get(grid, {x, y}) do
    grid |> elem(y) |> elem(x)
  end
end
