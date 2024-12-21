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

  def rot_cw({x, y}) do
    {-y, x}
  end

  def rot_ccw({x, y}) do
    {y, -x}
  end

  def invert({x, y}) do
    {-x, -y}
  end

  def dirs(opts \\ [])

  def dirs(diagonal: true) do
    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}]
  end

  def dirs(_) do
    [{0, 1}, {-1, 0}, {0, -1}, {1, 0}]
  end

  def manhattan({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end

defmodule Grid do
  def gridify(str, map \\ & &1) do
    str
    |> String.split("\n")
    |> Enum.map(fn row -> row |> String.to_charlist() |> Enum.map(map) end)
  end

  def gridify_tuple(str, map \\ & &1) do
    gridify(str, map)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

  def indices(grid) do
    0..(tuple_size(grid) - 1)
    |> Enum.reduce([], fn y, list ->
      0..(tuple_size(elem(grid, y)) - 1)
      |> Enum.reduce(list, fn x, list ->
        [{x, y} | list]
      end)
    end)
    |> Enum.reverse()
  end

  def set(grid, {x, y}, _)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    grid
  end

  def set(grid, {x, y}, value) do
    row = grid |> elem(y) |> put_elem(x, value)
    grid |> put_elem(y, row)
  end

  def get(_grid, _pos, _default \\ nil)

  def get(grid, {x, y}, default)
      when x < 0 or y < 0 or x >= tuple_size(elem(grid, 0)) or y >= tuple_size(grid) do
    default
  end

  def get(grid, {x, y}, _default) do
    grid |> elem(y) |> elem(x)
  end
end
