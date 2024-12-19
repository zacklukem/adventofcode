defmodule Day19a do
  def asdf(_, [], cache) do
    {true, cache}
  end

  def asdf(towels, pattern, cache) do
    cached = Map.get(cache, pattern)

    if cached == nil do
      towels
      |> Enum.reduce_while({false, cache}, fn towel, {_, cache} ->
        if pattern |> List.starts_with?(towel) do
          pattern = pattern |> Enum.drop(length(towel))

          {is_possible, cache} = asdf(towels, pattern, cache)

          if is_possible do
            cache = cache |> Map.put(pattern, true)
            {:halt, {true, cache}}
          else
            cache = cache |> Map.put(pattern, false)
            {:cont, {false, cache}}
          end
        else
          cache = cache |> Map.put(pattern, false)
          {:cont, {false, cache}}
        end
      end)
    else
      {cached, cache}
    end
  end

  def contains([], _) do
    false
  end

  def contains(a, b) do
    if List.starts_with?(a, b) do
      true
    else
      contains(tl(a), b)
    end
  end

  def run do
    [towels, patterns] =
      File.read!(".input.txt")
      |> String.split("\n\n")

    towels = towels |> String.split(", ") |> Enum.map(&to_charlist/1)
    patterns = patterns |> String.split("\n") |> Enum.map(&to_charlist/1)

    total = length(patterns)

    {count, _} =
      patterns
      |> Enum.with_index()
      |> Enum.reduce({0, Map.new()}, fn {pattern, i}, {count, cache} ->
        IO.puts("#{i}/#{total}")

        towels =
          towels
          |> Enum.filter(fn towel ->
            pattern |> contains(towel)
          end)

        {is_valid, cache} = asdf(towels, pattern, cache)
        count = if is_valid, do: count + 1, else: count

        {count, cache}
      end)

    count
  end
end

defmodule Day19b do
  def asdf(_, [], cache) do
    {1, cache}
  end

  def asdf(towels, pattern, cache) do
    cached = Map.get(cache, pattern)

    if cached == nil do
      towels
      |> Enum.reduce({0, cache}, fn towel, {ways, cache} ->
        if pattern |> List.starts_with?(towel) do
          pattern = pattern |> Enum.drop(length(towel))

          {ways_p, cache} = asdf(towels, pattern, cache)

          cache = cache |> Map.put(pattern, ways_p)

          {ways + ways_p, cache}
        else
          cache = cache |> Map.put(pattern, ways)

          {ways, cache}
        end
      end)
    else
      {cached, cache}
    end
  end

  def contains([], _) do
    false
  end

  def contains(a, b) do
    if List.starts_with?(a, b) do
      true
    else
      contains(tl(a), b)
    end
  end

  def run do
    [towels, patterns] =
      File.read!(".input.txt")
      |> String.split("\n\n")

    towels = towels |> String.split(", ") |> Enum.map(&to_charlist/1)
    patterns = patterns |> String.split("\n") |> Enum.map(&to_charlist/1)

    total = length(patterns)

    {count, _} =
      patterns
      |> Enum.with_index()
      |> Enum.reduce({0, Map.new()}, fn {pattern, i}, {count, cache} ->
        IO.puts("#{i}/#{total}")

        towels =
          towels
          |> Enum.filter(fn towel ->
            pattern |> contains(towel)
          end)

        {ways, cache} = asdf(towels, pattern, cache)

        {ways + count, cache}
      end)

    count
  end
end
