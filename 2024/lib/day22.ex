defmodule Day22a do
  import Bitwise

  def prune(sec) do
    rem(sec, 16_777_216)
  end

  def mix(x, sec) do
    bxor(sec, x)
  end

  def evolve(sec) do
    sec = mix(sec * 64, sec) |> prune()
    sec = mix(div(sec, 32), sec) |> prune()
    sec = mix(sec * 2048, sec) |> prune()
    sec
  end

  def run do
    File.read!(".input.txt") |> run
  end

  def run(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(fn sec ->
      1..2000
      |> Enum.reduce(sec, fn _, sec ->
        evolve(sec)
      end)
    end)
    |> Enum.sum()
  end
end

defmodule Day22b do
  import Bitwise

  def prune(sec) do
    rem(sec, 16_777_216)
  end

  def mix(x, sec) do
    bxor(sec, x)
  end

  def evolve(sec) do
    sec = mix(sec * 64, sec) |> prune()
    sec = mix(div(sec, 32), sec) |> prune()
    sec = mix(sec * 2048, sec) |> prune()
    sec
  end

  def run do
    File.read!(".input.txt") |> run
  end

  def run(input) do
    maps =
      input
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(fn sec ->
        {diffs, _} =
          1..2000
          |> Enum.map_reduce(sec, fn _, sec ->
            secp = evolve(sec)
            {{rem(secp, 10) - rem(sec, 10), secp}, secp}
          end)

        Enum.zip(0..3 |> Enum.map(&Enum.drop(diffs, &1)))
        |> Enum.map(fn x ->
          {
            x |> Tuple.to_list() |> Enum.map(&elem(&1, 0)) |> List.to_tuple(),
            rem(x |> elem(3) |> elem(1), 10)
          }
        end)
        |> Enum.reverse()
        |> Map.new()
      end)

    maps
    |> Enum.reduce(fn a, b ->
      Map.merge(a, b, fn _, a, b -> a + b end)
    end)
    |> Map.values()
    |> Enum.max()
  end
end
