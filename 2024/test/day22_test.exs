defmodule Day22Test do
  use ExUnit.Case

  def example, do: "1
10
100
2024"

  test "Part 1 Example" do
    assert Day22a.run(example()) == 37_327_623
  end

  # test "Part 2 Example" do
  #   assert Day22b.run(example()) == 24
  # end
end
