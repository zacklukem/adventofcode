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
