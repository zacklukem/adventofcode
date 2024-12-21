defmodule Day21Test do
  use ExUnit.Case

  def example, do: "029A
980A
179A
456A
379A"

  test "Part 1 Example" do
    assert Day21a.run(example()) == 126_384
  end

  test "Part 2 Example" do
    assert Day21b.run(example()) == 154_115_708_116_294
  end
end
