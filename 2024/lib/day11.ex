defmodule Day11a do
  def blink(list) do
    list
    |> Enum.flat_map(fn x ->
      cond do
        x == "0" ->
          ["1"]

        rem(byte_size(x), 2) == 0 ->
          [
            String.slice(x, 0, div(byte_size(x), 2)),
            Integer.to_string(
              String.to_integer(String.slice(x, div(byte_size(x), 2), byte_size(x)))
            )
          ]

        true ->
          [Integer.to_string(String.to_integer(x) * 2024)]
      end
    end)
  end

  def run do
    input =
      File.read!(".input.txt")
      |> String.split(" ")

    1..25
    |> Enum.reduce(input, fn _, acc -> blink(acc) end)
    |> Enum.count()
  end
end

defmodule Day11b do
  def remove_leading_zero([x | rest] = str) do
    cond do
      str == ~c"0" -> "0"
      x == ?0 -> remove_leading_zero(rest)
      true -> to_string(str)
    end
  end

  def blinkn(stone, n) do
    cond do
      n == 0 ->
        1

      stone == "0" ->
        blinkn("1", n - 1)

      rem(byte_size(stone), 2) == 0 ->
        [a, b] = [
          String.byte_slice(stone, 0, div(byte_size(stone), 2)),
          remove_leading_zero(
            String.to_charlist(
              String.byte_slice(stone, div(byte_size(stone), 2), byte_size(stone))
            )
          )
        ]

        blinkn(a, n - 1) + blinkn(b, n - 1)

      true ->
        x = Integer.to_string(String.to_integer(stone) * 2024)
        blinkn(x, n - 1)
    end
  end

  def run do
    File.read!(".input.txt")
    |> String.split(" ")
    |> Enum.with_index()
    |> Enum.map(fn {x, i} ->
      IO.puts(i)
      blinkn(x, 75)
    end)
    |> Enum.sum()
  end
end
