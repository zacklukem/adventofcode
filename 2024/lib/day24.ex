defmodule Day24a do
  import Bitwise

  def run do
    File.read!(".input.txt") |> run
  end

  def run(input) do
    [init, prog] = input |> String.split("\n\n")

    init =
      init
      |> String.split("\n")
      |> Enum.map(fn line -> line |> String.split(": ") |> List.to_tuple() end)
      |> Enum.map(fn {k, v} -> {k, String.to_integer(v)} end)
      |> Map.new()

    {ops, graph} =
      prog
      |> String.split("\n")
      |> Enum.reduce({%{}, Graph.new()}, fn line, {ops, graph} ->
        [expr, res] = line |> String.split(" -> ")
        [lhs, op, rhs] = expr |> String.split(" ")

        ops = ops |> Map.put(res, op)

        graph =
          graph
          |> Graph.add_edges([{lhs, res}, {rhs, res}])

        {ops, graph}
      end)

    graph
    |> Graph.topsort()
    |> Enum.reduce(init, fn vert, nets ->
      if Map.has_key?(ops, vert) do
        [a, b] = Graph.in_neighbors(graph, vert) |> Enum.map(&nets[&1])
        op = ops[vert]

        res =
          case op do
            "AND" -> band(a, b)
            "XOR" -> bxor(a, b)
            "OR" -> bor(a, b)
          end

        Map.put(nets, vert, res)
      else
        nets
      end
    end)
    |> Enum.reduce(0, fn {k, v}, val ->
      if String.starts_with?(k, "z") do
        idx = k |> String.trim_leading("z") |> String.to_integer()

        bor(val, bsl(v, idx))
      else
        val
      end
    end)
  end
end

defmodule Day24b do
  import Bitwise

  def run do
    File.read!(".input.txt") |> run
  end

  def num(nets, init) do
    nets
    |> Enum.reduce(0, fn {k, v}, val ->
      if String.starts_with?(k, init) do
        idx = k |> String.trim_leading(init) |> String.to_integer()

        bor(val, bsl(v, idx))
      else
        val
      end
    end)
  end

  def run(input) do
    [_init, prog] = input |> String.split("\n\n")

    swaps =
      %{
        "z07" => "rts",
        "rts" => "z07",
        "z12" => "jpj",
        "jpj" => "z12",
        "z26" => "kgj",
        "kgj" => "z26",
        "chv" => "vvw",
        "vvw" => "chv"
      }

    s = fn x -> swaps[x] || x end

    {ops, graph} =
      prog
      |> String.split("\n")
      |> Enum.reduce({%{}, Graph.new()}, fn line, {ops, graph} ->
        [expr, res] = line |> String.split(" -> ")
        [lhs, op, rhs] = expr |> String.split(" ")

        ops = ops |> Map.put(s.(res), String.to_atom(op))

        graph =
          graph
          |> Graph.add_edges([{lhs, s.(res)}, {rhs, s.(res)}])

        {ops, graph}
      end)

    1..44
    |> Enum.reduce("whb", fn n, c_in ->
      x = "x#{n |> to_string() |> String.pad_leading(2, "0")}"
      y = "y#{n |> to_string() |> String.pad_leading(2, "0")}"
      z = "z#{n |> to_string() |> String.pad_leading(2, "0")}"

      xo = Graph.out_neighbors(graph, x)
      yo = Graph.out_neighbors(graph, y)

      if MapSet.new(xo) != MapSet.new(yo) or length(xo) != 2 do
        IO.puts("bad first neighbors #{n}")
      end

      xor1op = if ops[hd(xo)] == :XOR, do: hd(xo), else: hd(tl(xo))
      and1op = if ops[hd(xo)] == :XOR, do: hd(tl(xo)), else: hd(xo)

      if ops[xor1op] != :XOR or ops[and1op] != :AND do
        IO.puts("bad op kind")
      end

      xor1opo = Graph.out_neighbors(graph, xor1op)

      if length(xor1opo) != 2 do
        IO.puts("bad xorop children:              #{xor1op}")

        orop? = Graph.out_neighbors(graph, and1op)

        if length(orop?) != 1 do
          IO.puts("bad and1op children:             #{orop?}")
        end

        orop? |> Enum.filter(&(not String.starts_with?(&1, "z"))) |> hd()
      else
        xor2op = if ops[hd(xor1opo)] == :XOR, do: hd(xor1opo), else: hd(tl(xor1opo))
        and2op = if ops[hd(xor1opo)] == :XOR, do: hd(tl(xor1opo)), else: hd(xor1opo)

        if xor2op != z do
          IO.puts("should be z:                     #{xor2op} (#{z})")
        end

        if ops[xor2op] != :XOR or ops[and2op] != :AND do
          IO.puts("bad op2 kind")
        end

        if Graph.out_neighbors(graph, c_in) |> Enum.find(&(&1 == and2op)) == nil do
          IO.puts("cin should direct to and2        #{c_in}")
        end

        if Graph.out_neighbors(graph, c_in) |> Enum.find(&(&1 == xor2op)) == nil do
          IO.puts("cin should direct to xor2        #{c_in}")
        end

        orop? =
          MapSet.intersection(
            MapSet.new(Graph.out_neighbors(graph, and1op)),
            MapSet.new(Graph.out_neighbors(graph, and2op))
          )
          |> MapSet.to_list()

        if length(orop?) == 1 do
          [orop] = orop?

          if ops[orop] != :OR do
            IO.puts("bad or op kind")
          end

          orop
        else
          orop? =
            MapSet.union(
              MapSet.new(Graph.out_neighbors(graph, and1op)),
              MapSet.new(Graph.out_neighbors(graph, and2op))
            )
            |> MapSet.to_list()

          [orop] = orop?

          if ops[orop] != :OR do
            IO.puts("bad or op kind")
          end

          orop
        end
      end
    end)

    graph =
      ops
      |> Enum.reduce(graph, fn {vert, op}, graph ->
        graph |> Graph.label_vertex(vert, op)
      end)

    dot = "digraph {\n"

    dot =
      graph
      |> Graph.vertices()
      |> Enum.sort_by(fn vert ->
        cond do
          vert |> String.match?(~r/[xy][0-9][0-9]/) ->
            n = vert |> String.slice(1, 2) |> String.to_integer()
            {n, vert |> to_charlist() |> hd()}

          vert |> String.match?(~r/z[0-9][0-9]/) ->
            n = vert |> String.slice(1, 2) |> String.to_integer()
            {n + 100, vert |> to_charlist() |> hd()}

          true ->
            {1000, vert}
        end
      end)
      |> Enum.reduce(dot, fn vert, dot ->
        label = Graph.vertex_labels(graph, vert)

        label =
          if label == [] do
            vert
          else
            [op] = label
            "#{op} -> #{vert}"
          end

        dot <> "#{vert}[label=\"#{label}\"]\n"
      end)

    dot =
      graph
      |> Graph.edges()
      |> Enum.reduce(dot, fn edge, dot ->
        dot <> "#{edge.v1} -> #{edge.v2}\n"
      end)

    dot = dot <> "}\n"

    File.write(".graph.dot", dot)

    swaps |> Map.keys() |> Enum.sort() |> Enum.join(",") |> IO.puts()
  end
end
