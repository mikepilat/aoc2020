defmodule Day9 do
  def run do
    {:ok, file} = File.read("priv/input/day9")

    input =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)

    preamble = Enum.take(input, 25)
    numbers = Enum.drop(input, 25)

    bad =
      numbers
      |> Enum.reduce_while(preamble, fn num, prev ->
        pairs =
          prev
          |> Enum.map(&(num - &1))
          |> MapSet.new()

        intersection = MapSet.intersection(MapSet.new(prev), pairs)

        if MapSet.size(intersection) > 0 do
          {:cont, Enum.drop(prev, 1) ++ [num]}
        else
          {:halt, num}
        end
      end)
      |> IO.inspect(label: "part 1")

    count = length(input)

    {first, last} =
      0..(count - 1)
      |> Stream.flat_map(fn x ->
        Stream.map(x..(count - 1), fn y ->
          {x, y}
        end)
      end)
      |> Enum.find(fn {x, y} ->
        input |> Enum.slice(x..y) |> Enum.sum() == bad
      end)

    range = Enum.slice(input, first..last)
    min = Enum.min(range)
    max = Enum.max(range)

    (min + max)
    |> IO.inspect(label: "part 2")
  end
end
