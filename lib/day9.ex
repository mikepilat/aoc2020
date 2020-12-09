defmodule Day9 do
  def run do
    {:ok, file} = File.read("priv/input/day9")

    input =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)

    {preamble, numbers} = Enum.split(input, 25)

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

    range =
      0..(count - 1)
      |> Stream.flat_map(fn x ->
        Stream.map(x..(count - 1), fn y ->
          x..y
        end)
      end)
      |> Enum.find(fn range ->
        input |> Enum.slice(range) |> Enum.sum() == bad
      end)

    input
    |> Enum.slice(range)
    |> Enum.min_max()
    |> Tuple.to_list()
    |> Enum.sum()
    |> IO.inspect(label: "part 2")
  end
end
