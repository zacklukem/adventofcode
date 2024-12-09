defmodule Day9a do
  def build([], _, acc) do
    Enum.reverse(acc)
  end

  def build([{_, i1} | _], [{_, i2} | _], acc) when i2 < i1 do
    Enum.reverse(acc)
  end

  def build(input, [{nil, _} | rev], acc) do
    build(input, rev, acc)
  end

  def build([{nil, _} | input], [{r, _} | rev], acc) do
    build(input, rev, [r | acc])
  end

  def build([{x, _} | input], rev, acc) do
    build(input, rev, [x | acc])
  end

  def run do
    input =
      File.read!(".input.txt")
      |> String.to_charlist()
      |> Enum.map(&(&1 - ?0))
      |> Enum.with_index()
      |> Enum.reduce([], fn {block_size, i}, acc ->
        if rem(i, 2) == 0 do
          acc ++ Enum.map(0..(block_size - 1)//1, fn _ -> div(i, 2) end)
        else
          acc ++ Enum.map(0..(block_size - 1)//1, fn _ -> nil end)
        end
      end)

    with_idx = input |> Enum.with_index()

    build(with_idx, Enum.reverse(with_idx), [])
    |> Enum.with_index()
    |> Enum.map(fn {x, i} -> x * i end)
    |> Enum.sum()
  end
end

defmodule Day9b do
  def is_free(ty) do
    ty == nil
  end

  def find_free(_, i0, _, max) when i0 >= max do
    nil
  end

  def find_free(list, i0, block_size, max) do
    {free, block_type} = list |> elem(i0)

    cond do
      not is_free(block_type) -> find_free(list, i0 + 1, block_size, max)
      free >= block_size -> {free - block_size, i0}
      true -> find_free(list, i0 + 1, block_size, max)
    end
  end

  def build(list, i1) when i1 < 0 do
    list
  end

  def build(list, i1) do
    {block_size, block_kind} = list |> elem(i1)

    if block_kind == nil do
      build(list, i1 - 1)
    else
      free? = find_free(list, 0, block_size, i1)

      if free? != nil do
        {free, i0} = free?

        list = put_elem(list, i0, {block_size, block_kind})
        list = put_elem(list, i1, {block_size, nil})

        {list, i1} =
          if free == 0 do
            {list, i1 - 1}
          else
            {Tuple.insert_at(list, i0 + 1, {free, nil}), i1}
          end

        build(list, i1)
      else
        build(list, i1 - 1)
      end
    end
  end

  def run do
    input =
      File.read!(".input.txt")
      |> String.to_charlist()
      |> Enum.map(&(&1 - ?0))

    with_idx =
      input
      |> Enum.with_index()
      |> Enum.map(fn {x, i} -> {x, if(rem(i, 2) == 1, do: nil, else: div(i, 2))} end)
      |> List.to_tuple()

    with_idx
    |> build(tuple_size(with_idx) - 1)
    |> Tuple.to_list()
    |> Enum.reduce([], fn {block_size, i}, acc ->
      acc ++ Enum.map(0..(block_size - 1)//1, fn _ -> i end)
    end)
    |> Enum.with_index()
    |> Enum.map(fn {x, i} -> if(x == nil, do: 0, else: x) * i end)
    |> Enum.sum()
  end
end
