defmodule Day25a do
  def run do
    File.read!(".input.txt") |> run
  end

  def fits?(a, b) do
    Enum.zip(a, b)
    |> Enum.all?(fn {a, b} -> a + b <= 5 end)
  end

  def run(input) do
    {locks, keys} =
      input
      |> String.split("\n\n")
      |> Enum.reduce({[], []}, fn pattern, {locks, keys} ->
        pattern =
          pattern
          |> String.split("\n")
          |> Enum.map(&(&1 |> String.to_charlist()))

        heights =
          pattern
          |> tl()
          |> Enum.take(5)
          |> Enum.reduce([0, 0, 0, 0, 0], fn line, heights ->
            Enum.zip(heights, line)
            |> Enum.map(fn {h, cell} -> h + if cell == ?#, do: 1, else: 0 end)
          end)

        if hd(pattern) == ~c"#####" do
          {[heights | locks], keys}
        else
          {locks, [heights | keys]}
        end
      end)

    locks
    |> Enum.map(fn lock ->
      keys |> Enum.count(fn key -> fits?(lock, key) end)
    end)
    |> Enum.sum()
  end
end
