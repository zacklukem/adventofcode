import Bitwise

defmodule Day17a do
  def combo(registers, operand) do
    cond do
      operand in 0..3 -> operand
      operand in 4..6 -> elem(registers, operand - 4)
    end
  end

  def truncate(i) do
    # band(i, 0xFFFFFFFF)
    i
  end

  def exec(program, _registers, pc, output) when pc >= tuple_size(program) do
    Enum.reverse(output)
  end

  def exec(program, {a, b, c} = registers, pc, output) do
    {pc, output, registers} =
      case elem(program, pc) do
        0 ->
          lit = combo(registers, elem(program, pc + 1))
          denom = round(:math.pow(2, lit))
          a = truncate(div(a, denom))
          pc = pc + 2

          {pc, output, {a, b, c}}

        1 ->
          lit = elem(program, pc + 1)
          b = bxor(b, lit)
          pc = pc + 2

          {pc, output, {a, b, c}}

        2 ->
          lit = combo(registers, elem(program, pc + 1))
          b = rem(lit, 8)
          pc = pc + 2

          {pc, output, {a, b, c}}

        3 ->
          lit = elem(program, pc + 1)

          pc =
            if a == 0 do
              pc + 2
            else
              lit
            end

          {pc, output, {a, b, c}}

        4 ->
          b = bxor(b, c)
          pc = pc + 2

          {pc, output, {a, b, c}}

        5 ->
          lit = combo(registers, elem(program, pc + 1))
          output = [rem(lit, 8) | output]
          pc = pc + 2

          {pc, output, {a, b, c}}

        6 ->
          lit = combo(registers, elem(program, pc + 1))
          denom = round(:math.pow(2, lit))
          b = truncate(div(a, denom))
          pc = pc + 2

          {pc, output, {a, b, c}}

        7 ->
          lit = combo(registers, elem(program, pc + 1))
          denom = round(:math.pow(2, lit))
          c = truncate(div(a, denom))
          pc = pc + 2

          {pc, output, {a, b, c}}
      end

    exec(program, registers, pc, output)
  end

  def run do
    [registers, program] = File.read!(".input.txt") |> String.split("\n\n")

    registers =
      registers
      |> String.split("\n")
      |> Enum.map(fn line ->
        [_, num] = line |> String.split(": ")
        String.to_integer(num)
      end)
      |> List.to_tuple()

    [_, program] = program |> String.split(": ")

    program = program |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

    exec(program, registers, 0, [])
    |> Enum.join(",")
    |> IO.puts()
  end
end

defmodule Day17b do
  def combo(registers, operand) do
    cond do
      operand in 0..3 -> operand
      operand in 4..6 -> elem(registers, operand - 4)
    end
  end

  def truncate(i) do
    i
  end

  def exec(program, registers, pc \\ 0, output \\ [])

  def exec(program, _registers, pc, output) when pc >= tuple_size(program) do
    Enum.reverse(output)
  end

  def exec(program, {a, b, c} = registers, pc, output) do
    {pc, output, registers} =
      case elem(program, pc) do
        0 ->
          lit = combo(registers, elem(program, pc + 1))
          denom = round(:math.pow(2, lit))
          a = truncate(div(a, denom))
          pc = pc + 2

          {pc, output, {a, b, c}}

        1 ->
          lit = elem(program, pc + 1)
          b = bxor(b, lit)
          pc = pc + 2

          {pc, output, {a, b, c}}

        2 ->
          lit = combo(registers, elem(program, pc + 1))
          b = rem(lit, 8)
          pc = pc + 2

          {pc, output, {a, b, c}}

        3 ->
          lit = elem(program, pc + 1)

          pc =
            if a == 0 do
              pc + 2
            else
              lit
            end

          {pc, output, {a, b, c}}

        4 ->
          b = bxor(b, c)
          pc = pc + 2

          {pc, output, {a, b, c}}

        5 ->
          lit = combo(registers, elem(program, pc + 1))
          output = [rem(lit, 8) | output]
          pc = pc + 2

          {pc, output, {a, b, c}}

        6 ->
          lit = combo(registers, elem(program, pc + 1))
          denom = round(:math.pow(2, lit))
          b = truncate(div(a, denom))
          pc = pc + 2

          {pc, output, {a, b, c}}

        7 ->
          lit = combo(registers, elem(program, pc + 1))
          denom = round(:math.pow(2, lit))
          c = truncate(div(a, denom))
          pc = pc + 2

          {pc, output, {a, b, c}}
      end

    exec(program, registers, pc, output)
  end

  def run do
    [registers, program] = File.read!(".input.txt") |> String.split("\n\n")

    registers =
      registers
      |> String.split("\n")
      |> Enum.map(fn line ->
        [_, num] = line |> String.split(": ")
        String.to_integer(num)
      end)
      |> List.to_tuple()

    [_, program] = program |> String.split(": ")

    program = program |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

    asdf(program, registers, tuple_size(program) - 1)
    |> Enum.min()
  end

  def asdf(program, registers, list \\ [], i)

  def asdf(_program, _registers, list, i) when i < 0 do
    list
    |> Enum.with_index()
    |> Enum.map(fn {x, i} ->
      x * round(:math.pow(8, i))
    end)
    |> Enum.sum()
  end

  def asdf(program, registers, list, i) do
    0..7
    |> Enum.map(fn x ->
      a =
        [x | list]
        |> Enum.with_index()
        |> Enum.map(fn {x, i1} ->
          x * round(:math.pow(8, i + i1))
        end)
        |> Enum.sum()

      res = execa(program, registers, a)

      if Enum.at(res, i) == elem(program, i) do
        asdf(program, registers, [x | list], i - 1)
      end
    end)
    |> Enum.filter(&(&1 != nil))
    |> List.flatten()
  end

  def execa(program, registers, a) do
    registers = registers |> put_elem(0, a)
    exec(program, registers, 0, [])
  end
end
