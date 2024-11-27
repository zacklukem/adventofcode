defmodule Day1a do
  def first([c | _]) when ?0 <= c and c <= ?9 do
    to_string([c])
  end

  def first([c | tail]) when ?0 > c or c > ?9 do
    first(tail)
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.to_integer(first(to_charlist(line)) <> first(Enum.reverse(to_charlist(line))))
    end)
    |> Enum.sum()
  end
end

defmodule Day1b do
  def map_match(res) do
    case res do
      {a, _} -> a
      :nomatch -> nil
    end
  end

  def first(str, [{x, num} | tail], min, val) do
    currIdx = str |> :binary.match(num) |> map_match()

    {newPrec, newVal} =
      if currIdx && currIdx <= min do
        {currIdx, x}
      else
        {min, val}
      end

    first(str, tail, newPrec, newVal)
  end

  def first(_, [], _, val) do
    to_string(val)
  end

  def run do
    numbers = [
      {0, "0"},
      {1, "1"},
      {2, "2"},
      {3, "3"},
      {4, "4"},
      {5, "5"},
      {6, "6"},
      {7, "7"},
      {8, "8"},
      {9, "9"},
      {0, "zero"},
      {1, "one"},
      {2, "two"},
      {3, "three"},
      {4, "four"},
      {5, "five"},
      {6, "six"},
      {7, "seven"},
      {8, "eight"},
      {9, "nine"}
    ]

    numbers_rev = numbers |> Enum.map(fn {x, num} -> {x, String.reverse(num)} end)

    File.read!(".input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.to_integer(
        first(line, numbers, 999_999_999_999, -1) <>
          first(String.reverse(line), numbers_rev, 999_999_999_999, -1)
      )
    end)
    |> Enum.sum()
  end
end
