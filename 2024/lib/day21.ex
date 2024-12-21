defmodule Day21a do
  @type action() :: ?A | ?< | ?^ | ?> | ?v
  @type dir_state() :: action()

  @spec dir_pos(action()) :: TVec.t2()
  def dir_pos(?^), do: {1, 0}
  def dir_pos(?A), do: {2, 0}
  def dir_pos(?<), do: {0, 1}
  def dir_pos(?v), do: {1, 1}
  def dir_pos(?>), do: {2, 1}

  def num_pos(?0), do: {1, 3}
  def num_pos(?A), do: {2, 3}
  def num_pos(?1), do: {0, 2}
  def num_pos(?2), do: {1, 2}
  def num_pos(?3), do: {2, 2}
  def num_pos(?4), do: {0, 1}
  def num_pos(?5), do: {1, 1}
  def num_pos(?6), do: {2, 1}
  def num_pos(?7), do: {0, 0}
  def num_pos(?8), do: {1, 0}
  def num_pos(?9), do: {2, 0}

  @spec dir_pos(TVec.t2()) :: action()
  def dir_action({1, 0}), do: ?>
  def dir_action({-1, 0}), do: ?<
  def dir_action({0, 1}), do: ?v
  def dir_action({0, -1}), do: ?^

  @spec cost(list(dir_state()), action()) :: {integer(), list(dir_state())}
  def cost(state, action)

  def cost([], _action) do
    {1, []}
  end

  def cost([state], action) do
    {TVec.manhattan(dir_pos(state), dir_pos(action)) + 1, [action]}
  end

  # cost for nth dpad robot
  def cost([state | state_tail], action) do
    {cost, state_tail} =
      moves_between(dir_pos(state), dir_pos(action), {0, 0})
      |> Enum.map(fn moves ->
        (moves ++ [?A])
        |> Enum.reduce({0, state_tail}, fn move, {total_cost, state} ->
          {cost, state} = cost(state, move)
          {total_cost + cost, state}
        end)
      end)
      |> Enum.min_by(&elem(&1, 0))

    {cost, [action | state_tail]}
  end

  def cost_num([state | state_tail], action) do
    {cost, state_tail} =
      moves_between(num_pos(state), num_pos(action), {0, 3})
      |> Enum.map(fn moves ->
        (moves ++ [?A])
        |> Enum.reduce({0, state_tail}, fn move, {total_cost, state} ->
          {cost, state} = cost(state, move)
          {total_cost + cost, state}
        end)
      end)
      |> Enum.min_by(&elem(&1, 0))

    {cost, [action | state_tail]}
  end

  def moves_between({x1, y1}, {x2, y2}, exclude) do
    cond do
      x1 == x2 ->
        [y1..y2 |> Enum.map(&{x1, &1})]

      y1 == y2 ->
        [x1..x2 |> Enum.map(&{&1, y1})]

      true ->
        [
          Enum.map(x1..(x2 + if(x2 > x1, do: -1, else: 1)), &{&1, y1}) ++
            Enum.map(y1..y2, &{x2, &1}),
          Enum.map(y1..(y2 + if(y2 > y1, do: -1, else: 1)), &{x1, &1}) ++
            Enum.map(x1..x2, &{&1, y2})
        ]
        |> Enum.filter(&(not Enum.member?(&1, exclude)))
    end
    |> Enum.map(fn pos_list ->
      Enum.zip(pos_list, pos_list |> Enum.drop(1))
      |> Enum.map(fn {a, b} ->
        dir_action(TVec.sub(b, a))
      end)
    end)
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n")
    |> Enum.map(fn code ->
      state = ~c"AAA"

      {cost, _} =
        code
        |> String.to_charlist()
        |> Enum.reduce({0, state}, fn move, {total_cost, state} ->
          {cost, state} = cost_num(state, move)
          {cost + total_cost, state}
        end)

      code_num =
        code
        |> String.trim_leading("0")
        |> String.trim_trailing("A")
        |> String.to_integer()

      code_num * cost
    end)
    |> Enum.sum()
  end
end

defmodule Day21b do
  @type action() :: ?A | ?< | ?^ | ?> | ?v
  @type dir_state() :: action()

  @spec dir_pos(action()) :: TVec.t2()
  def dir_pos(?^), do: {1, 0}
  def dir_pos(?A), do: {2, 0}
  def dir_pos(?<), do: {0, 1}
  def dir_pos(?v), do: {1, 1}
  def dir_pos(?>), do: {2, 1}

  def num_pos(?0), do: {1, 3}
  def num_pos(?A), do: {2, 3}
  def num_pos(?1), do: {0, 2}
  def num_pos(?2), do: {1, 2}
  def num_pos(?3), do: {2, 2}
  def num_pos(?4), do: {0, 1}
  def num_pos(?5), do: {1, 1}
  def num_pos(?6), do: {2, 1}
  def num_pos(?7), do: {0, 0}
  def num_pos(?8), do: {1, 0}
  def num_pos(?9), do: {2, 0}

  @spec dir_pos(TVec.t2()) :: action()
  def dir_action({1, 0}), do: ?>
  def dir_action({-1, 0}), do: ?<
  def dir_action({0, 1}), do: ?v
  def dir_action({0, -1}), do: ?^

  @spec cost(list(dir_state()), action(), map()) :: {integer(), list(dir_state()), map()}
  def cost(state, action, cache)

  def cost([], _action, cache) do
    {1, [], cache}
  end

  def cost([state], action, cache) do
    {TVec.manhattan(dir_pos(state), dir_pos(action)) + 1, [action], cache}
  end

  def cost([state | state_tail] = states, action, cache) do
    if cache |> Map.has_key?({states, action}) do
      {cost, state} = Map.get(cache, {states, action})
      {cost, state, cache}
    else
      {cost, state_tail, cache} =
        moves_between(dir_pos(state), dir_pos(action), {0, 0})
        |> Enum.reduce({nil, state_tail, cache}, fn moves, {min, old_state, cache} ->
          {val, state, cache} =
            (moves ++ [?A])
            |> Enum.reduce({0, state_tail, cache}, fn move, {total_cost, state, cache} ->
              {cost, state, cache} = cost(state, move, cache)
              {total_cost + cost, state, cache}
            end)

          if val < min do
            {val, state, cache}
          else
            {min, old_state, cache}
          end
        end)

      cache = cache |> Map.put({states, action}, {cost, [action | state_tail]})

      {cost, [action | state_tail], cache}
    end
  end

  def cost_num([state | state_tail] = states, action, cache) do
    if cache |> Map.has_key?({states, action}) do
      {cost, state} = Map.get(cache, {states, action})
      {cost, state, cache}
    else
      {cost, state_tail, cache} =
        moves_between(num_pos(state), num_pos(action), {0, 3})
        |> Enum.reduce({nil, state_tail, cache}, fn moves, {min, old_state, cache} ->
          {val, state, cache} =
            (moves ++ [?A])
            |> Enum.reduce({0, state_tail, cache}, fn move, {total_cost, state, cache} ->
              {cost, state, cache} = cost(state, move, cache)
              {total_cost + cost, state, cache}
            end)

          if val < min do
            {val, state, cache}
          else
            {min, old_state, cache}
          end
        end)

      cache = cache |> Map.put({states, action}, {cost, [action | state_tail]})

      {cost, [action | state_tail], cache}
    end
  end

  def moves_between({x1, y1}, {x2, y2}, exclude) do
    cond do
      x1 == x2 ->
        [y1..y2 |> Enum.map(&{x1, &1})]

      y1 == y2 ->
        [x1..x2 |> Enum.map(&{&1, y1})]

      true ->
        [
          Enum.map(x1..(x2 + if(x2 > x1, do: -1, else: 1)), &{&1, y1}) ++
            Enum.map(y1..y2, &{x2, &1}),
          Enum.map(y1..(y2 + if(y2 > y1, do: -1, else: 1)), &{x1, &1}) ++
            Enum.map(x1..x2, &{&1, y2})
        ]
        |> Enum.filter(&(not Enum.member?(&1, exclude)))
    end
    |> Enum.map(fn pos_list ->
      Enum.zip(pos_list, pos_list |> Enum.drop(1))
      |> Enum.map(fn {a, b} ->
        dir_action(TVec.sub(b, a))
      end)
    end)
  end

  def run do
    File.read!(".input.txt")
    |> String.split("\n")
    |> Enum.map(fn code ->
      state = 0..25 |> Enum.map(fn _ -> ?A end)

      {cost, _} =
        code
        |> String.to_charlist()
        |> Enum.reduce({0, state}, fn move, {total_cost, state} ->
          {cost, state, _} = cost_num(state, move, %{})
          {cost + total_cost, state}
        end)

      code_num =
        code
        |> String.trim_leading("0")
        |> String.trim_trailing("A")
        |> String.to_integer()

      code_num * cost
    end)
    |> Enum.sum()
  end
end
