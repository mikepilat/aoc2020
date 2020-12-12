defmodule Day12 do
  @directions [
    {1, 0},
    {0, 1},
    {-1, 0},
    {0, -1}
  ]

  def run do
    {:ok, file} = File.read("priv/input/day12")

    input =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn <<dir, distance::binary>> ->
        {List.to_string([dir]), String.to_integer(distance)}
      end)

    input
    |> Enum.reduce({{0, 0}, 0}, fn {command, dist}, {{x, y}, dir} ->
      case command do
        "N" -> {{x, y - dist}, dir}
        "S" -> {{x, y + dist}, dir}
        "E" -> {{x + dist, y}, dir}
        "W" -> {{x - dist, y}, dir}
        "L" -> {{x, y}, mod(dir - div(dist, 90), 4)}
        "R" -> {{x, y}, mod(dir + div(dist, 90), 4)}
        "F" -> {move_dir({x, y}, dir, dist), dir}
      end
    end)
    |> elem(0)
    |> Tuple.to_list()
    |> Enum.map(&abs/1)
    |> Enum.sum()
    |> IO.inspect(label: "part 1")

    input
    |> Enum.reduce({{0, 0}, {10, -1}}, fn {command, dist}, {{x, y}, {wx, wy}} ->
      case command do
        "N" ->
          {{x, y}, {wx, wy - dist}}

        "S" ->
          {{x, y}, {wx, wy + dist}}

        "E" ->
          {{x, y}, {wx + dist, wy}}

        "W" ->
          {{x, y}, {wx - dist, wy}}

        "L" ->
          {{x, y}, rotate_waypoint({wx, wy}, "L", dist)}

        "R" ->
          {{x, y}, rotate_waypoint({wx, wy}, "R", dist)}

        "F" ->
          {{x + wx * dist, y + wy * dist}, {wx, wy}}
      end
    end)
    |> elem(0)
    |> Tuple.to_list()
    |> Enum.map(&abs/1)
    |> Enum.sum()
    |> IO.inspect(label: "part 2")
  end

  defp rotate_waypoint(waypoint, dir, dist) do
    0..(div(dist, 90) - 1)
    |> Enum.reduce(
      waypoint,
      fn _, w -> _rotate(w, dir) end
    )
  end

  defp _rotate({wx, wy}, dir) do
    case dir do
      "R" -> {-1 * wy, wx}
      "L" -> {wy, -1 * wx}
    end
  end

  defp move_dir({x, y}, dir, dist) do
    {dx, dy} = Enum.at(@directions, dir)

    {x + dx * dist, y + dy * dist}
  end

  defp mod(n, d) do
    r = rem(n, d)

    if r < 0 do
      d + r
    else
      r
    end
  end
end
