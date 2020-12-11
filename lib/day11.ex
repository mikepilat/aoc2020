defmodule Day11 do
  @directions [
    {0, -1},
    {0, 1},
    {-1, 0},
    {1, 0},
    {1, -1},
    {1, 1},
    {-1, -1},
    {-1, 1}
  ]

  def run do
    {:ok, file} = File.read("priv/input/day11")

    input =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    width =
      input
      |> Enum.at(0)
      |> length

    height = length(input)

    room =
      input
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, x}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {chair, y}, acc ->
          case chair do
            "L" ->
              Map.put(acc, {x, y}, :empty)

            _ ->
              acc
          end
        end)
      end)

    room
    |> iterate(&part_one/3, {width, height})
    |> Enum.count(fn {_, seat} -> seat == :occupied end)
    |> IO.inspect(label: "part 1")

    room
    |> iterate(&part_two/3, {width, height})
    |> Enum.count(fn {_, seat} -> seat == :occupied end)
    |> IO.inspect(label: "part 2")
  end

  defp iterate(room, fun, extents) do
    new_room = for seat <- room, into: %{}, do: fun.(room, seat, extents)

    if new_room == room do
      room
    else
      iterate(new_room, fun, extents)
    end
  end

  defp part_one(state, {{x, y}, current}, _) do
    adjacent =
      @directions
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.map(fn pos ->
        Map.get(state, pos, :empty)
      end)

    cond do
      current == :empty && Enum.all?(adjacent, &empty?/1) ->
        {{x, y}, :occupied}

      current == :occupied && Enum.count(adjacent, &occupied?/1) >= 4 ->
        {{x, y}, :empty}

      true ->
        {{x, y}, current}
    end
  end

  defp part_two(state, {{x, y}, current}, {max_x, max_y}) do
    adjacent =
      @directions
      |> Enum.map(&check_direction(state, {x, y}, &1, {max_x, max_y}))

    cond do
      current == :empty && Enum.all?(adjacent, &empty?/1) ->
        {{x, y}, :occupied}

      current == :occupied && Enum.count(adjacent, &occupied?/1) >= 5 ->
        {{x, y}, :empty}

      true ->
        {{x, y}, current}
    end
  end

  def check_direction(room, {x, y}, {dx, dy}, {max_x, max_y}) do
    {px, py} = {x + dx, y + dy}
    next_seat = Map.get(room, {px, py}, :floor)

    cond do
      px < 0 || px > max_x || py < 0 || py > max_y -> :empty
      next_seat != :floor -> next_seat
      true -> check_direction(room, {px, py}, {dx, dy}, {max_x, max_y})
    end
  end

  defp empty?(:empty), do: true
  defp empty?(:occupied), do: false

  defp occupied?(:occupied), do: true
  defp occupied?(:empty), do: false
end
