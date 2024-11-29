defmodule Day3a do
  def parse_line(line) do
    line
    |> String.to_charlist()
    |> Enum.map(fn
      ch when ch in ?0..?9 -> ch - ?0
      ch when ch in [?., ?\n] -> :empty
      _ -> :symbol
    end)
    |> List.to_tuple()
  end

  def get(grid, x, y)
      when 0 <= y and y < tuple_size(grid) and 0 <= x and x < tuple_size(elem(grid, 0)) do
    grid |> elem(y) |> elem(x)
  end

  def get(_, _, _) do
    :empty
  end

  def has_adj?(grid, x, y) do
    Enum.any?([-1, 0, 1], fn dx ->
      Enum.any?([-1, 0, 1], fn dy ->
        get(grid, x + dx, y + dy) == :symbol
      end)
    end)
  end

  def matching_nums(grid, x \\ 0, y \\ 0, acc \\ [], curr_num \\ 0, has_adj \\ false)

  def matching_nums(grid, x, y, acc, curr_num, has_adj) when y >= tuple_size(grid) do
    [if(has_adj, do: curr_num, else: 0) | acc]
  end

  def matching_nums(grid, x, y, acc, curr_num, has_adj) when x >= tuple_size(elem(grid, 0)) do
    matching_nums(grid, 0, y + 1, acc, curr_num, has_adj)
  end

  def matching_nums(grid, x, y, acc, curr_num, has_adj) do
    case grid |> get(x, y) do
      digit when is_integer(digit) ->
        matching_nums(grid, x + 1, y, acc, curr_num * 10 + digit, has_adj or has_adj?(grid, x, y))

      _ ->
        matching_nums(grid, x + 1, y, [if(has_adj, do: curr_num, else: 0) | acc], 0, false)
    end
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> List.to_tuple()
    |> IO.inspect()
    |> matching_nums()
    |> Enum.filter(&(&1 > 0))
    |> IO.inspect()
    |> Enum.sum()
  end
end
