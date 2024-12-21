#!/bin/bash

day="$(date '+%d')"

cat > lib/day$day.ex <<- EOM
defmodule Day${day}a do
  def run do
    File.read!(".input.txt") |> run
  end

  def run(input) do
  end
end
EOM

cat > test/day${day}_test.exs <<- EOM
defmodule Day${day}Test do
  use ExUnit.Case

  def example, do: ""

  test "Part 1 Example" do
    assert Day${day}a.run(example()) == :todo
  end

#   test "Part 2 Example" do
#     assert Day${day}b.run(example()) == :todo
#   end
end
EOM