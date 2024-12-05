defmodule Day5a do
  def conforms?([], _, _) do
    true
  end

  def conforms?([{ar, br} | tail], a, b) do
    if b == ar and a == br do
      false
    else
      conforms?(tail, a, b)
    end
  end

  def all_conform?([_], _) do
    true
  end

  def all_conform?([a | tail], rules) do
    all_conform?(tail, rules) and tail |> Enum.all?(fn b -> conforms?(rules, a, b) end)
  end

  def midpoint(list) do
    Enum.at(list, div(Enum.count(list), 2))
  end

  def run do
    [rules, pages] = File.read!(".input.txt") |> String.split("\n\n")

    rules =
      rules
      |> String.split("\n")
      |> Enum.map(fn l ->
        l
        |> String.split("|")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    pages =
      pages
      |> String.split("\n")
      |> Enum.map(fn l -> l |> String.split(",") |> Enum.map(&String.to_integer/1) end)

    pages
    |> Enum.filter(&all_conform?(&1, rules))
    |> Enum.map(&midpoint/1)
    |> Enum.sum()
  end
end

defmodule Day5b do
  def conforms?([], _, _) do
    true
  end

  def conforms?([{ar, br} | tail], a, b) do
    if b == ar and a == br do
      false
    else
      conforms?(tail, a, b)
    end
  end

  def non_conforming([_], _, _) do
    nil
  end

  def non_conforming([a | tail], i, rules) do
    j = tail |> Enum.find_index(fn b -> not conforms?(rules, a, b) end)

    if j do
      {i, j + i + 1}
    else
      non_conforming(tail, i + 1, rules)
    end
  end

  def all_conform?([_], _) do
    true
  end

  def all_conform?([a | tail], rules) do
    all_conform?(tail, rules) and tail |> Enum.all?(fn b -> conforms?(rules, a, b) end)
  end

  def midpoint(list) do
    Enum.at(list, div(Enum.count(list), 2))
  end

  def swap(list, i, j) do
    iv = Enum.at(list, i)
    jv = Enum.at(list, j)

    list
    |> List.replace_at(i, jv)
    |> List.replace_at(j, iv)
  end

  def make_correct(page, rules) do
    nc = page |> non_conforming(0, rules)

    if nc do
      {i, j} = nc
      make_correct(page |> swap(i, j), rules)
    else
      page
    end
  end

  def run do
    [rules, pages] = File.read!(".input.txt") |> String.split("\n\n")

    rules =
      rules
      |> String.split("\n")
      |> Enum.map(fn l ->
        l
        |> String.split("|")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    pages =
      pages
      |> String.split("\n")
      |> Enum.map(fn l -> l |> String.split(",") |> Enum.map(&String.to_integer/1) end)

    pages
    |> Enum.filter(&(not all_conform?(&1, rules)))
    |> Enum.map(&make_correct(&1, rules))
    |> Enum.map(&midpoint/1)
    |> Enum.sum()
  end
end
