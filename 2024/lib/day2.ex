defmodule Day2a do
  def check(list, inc? \\ nil)

  def check([_ | tail], _) when tail == [] do
    true
  end

  def check([x | tail], inc?) when tail != [] do
    y = hd(tail)

    diff = x - y

    incp? = diff > 0

    cond do
      inc? != nil and inc? != incp? -> false
      abs(diff) < 1 or abs(diff) > 3 -> false
      true -> check(tail, incp?)
    end
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(&check/1)
    |> Enum.count()
  end
end

defmodule Day2b do
  def check(list, inc? \\ nil)

  def check([_ | tail], _) when tail == [] do
    true
  end

  def check([x | tail], inc?) when tail != [] do
    y = hd(tail)

    diff = x - y

    incp? = diff > 0

    cond do
      inc? != nil and inc? != incp? -> false
      abs(diff) < 1 or abs(diff) > 3 -> false
      true -> check(tail, incp?)
    end
  end

  def check2(list) do
    if check(list) do
      true
    else
      len = length(list)

      Enum.any?(0..(len - 1), fn i ->
        check(List.delete_at(list, i))
      end)
    end
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(&check2/1)
    |> Enum.count()
  end
end
