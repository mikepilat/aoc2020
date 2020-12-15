defmodule Day15 do
  @input [12, 1, 16, 3, 11, 0]
  def run do
    @input
    |> Enum.with_index()
    |> Enum.into(%{}, fn {x, i} -> {x, {i}} end)
    |> iterate(0, 6, 2020)
    |> IO.inspect(label: "part 1")

    @input
    |> Enum.with_index()
    |> Enum.into(%{}, fn {x, i} -> {x, {i}} end)
    |> iterate(0, 6, 30_000_000)
    |> IO.inspect(label: "part 2")
  end

  def iterate(map, last, c, target) do
    val = Map.get(map, last)

    speak =
      case val do
        nil -> 0
        {_} -> 0
        {b, a} -> b - a
      end

    new_map = Map.update(map, speak, {c}, fn x -> {c, elem(x, 0)} end)

    if c == target - 1 do
      speak
    else
      iterate(new_map, speak, c + 1, target)
    end
  end
end
