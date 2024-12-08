defmodule Day8a do
  def pair_antinodes({x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1

    [{x2 + dx, y2 + dy}, {x1 - dx, y1 - dy}]
  end

  def freq_antinodes([], _, acc, _) do
    acc
  end

  def freq_antinodes([pos1 | rest], prev, acc, {xmax, ymax} = maxs) do
    acc =
      Stream.concat(prev, rest)
      |> Enum.reduce(acc, fn pos2, acc ->
        pair_antinodes(pos1, pos2)
        |> Enum.filter(fn {x, y} -> x >= 0 and x < xmax and y >= 0 and y < ymax end)
        |> Enum.reduce(acc, fn {x, y}, acc -> MapSet.put(acc, {x, y}) end)
      end)

    freq_antinodes(rest, [pos1 | prev], acc, maxs)
  end

  def run do
    input =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    antennas =
      input
      |> Enum.with_index()
      |> Enum.reduce(Map.new(), fn {line, y}, acc ->
        line
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {ch, x}, acc ->
          if ch != ?. do
            Map.update(acc, ch, [{x, y}], fn rest -> [{x, y} | rest] end)
          else
            acc
          end
        end)
      end)

    xmax = input |> hd() |> length()
    ymax = input |> length()

    Map.values(antennas)
    |> Enum.reduce(MapSet.new(), fn antennaGroup, acc ->
      freq_antinodes(antennaGroup, [], acc, {xmax, ymax})
    end)
    |> MapSet.size()
  end
end

defmodule Day8b do
  def pair_antinodes(set, {x, y}, _, {xmax, ymax})
      when x < 0 or x >= xmax or y < 0 or y >= ymax do
    set
  end

  def pair_antinodes(set, {x, y}, {dx, dy}, {xmax, ymax}) do
    pair_antinodes(MapSet.put(set, {x, y}), {x + dx, y + dy}, {dx, dy}, {xmax, ymax})
  end

  def freq_antinodes([], _, acc, _) do
    acc
  end

  def freq_antinodes([{x1, y1} = pos1 | rest], prev, acc, maxs) do
    acc =
      Stream.concat(prev, rest)
      |> Enum.reduce(acc, fn {x2, y2} = pos2, acc ->
        dx = x2 - x1
        dy = y2 - y1

        acc
        |> pair_antinodes(pos2, {dx, dy}, maxs)
        |> pair_antinodes(pos1, {-dx, -dy}, maxs)
      end)

    freq_antinodes(rest, [pos1 | prev], acc, maxs)
  end

  def run do
    input =
      File.read!(".input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    antennas =
      input
      |> Enum.with_index()
      |> Enum.reduce(Map.new(), fn {line, y}, acc ->
        line
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {ch, x}, acc ->
          if ch != ?. do
            Map.update(acc, ch, [{x, y}], fn rest -> [{x, y} | rest] end)
          else
            acc
          end
        end)
      end)

    xmax = input |> hd() |> length()
    ymax = input |> length()

    Map.values(antennas)
    |> Enum.reduce(MapSet.new(), fn antennaGroup, acc ->
      freq_antinodes(antennaGroup, [], acc, {xmax, ymax})
    end)
    |> MapSet.size()
  end
end
