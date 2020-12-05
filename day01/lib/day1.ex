defmodule Day1 do
  def run do
    part1()
    part2()
  end

  def part1 do
    {:ok, file} = File.read("priv/input/day1")

    inputs =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&Integer.parse(&1))
      |> Enum.map(&elem(&1, 0))

    pairs =
      inputs
      |> Enum.map(&(2020 - &1))

    input_set = MapSet.new(inputs)
    pair_set = MapSet.new(pairs)

    intersection = MapSet.intersection(input_set, pair_set)

    intersection
    |> MapSet.to_list()
    |> Enum.reduce(
      1,
      fn x, acc -> x * acc end
    )
    |> IO.inspect()
  end

  def part2 do
    {:ok, file} = File.read("priv/input/day1")

    inputs =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&Integer.parse(&1))
      |> Enum.map(&elem(&1, 0))

    partials =
      inputs
      |> Enum.map(fn i ->
        Enum.map(inputs, &(&1 + i))
      end)
      |> List.flatten()
      |> Enum.map(&(2020 - &1))

    input_set = MapSet.new(inputs)
    partial_set = MapSet.new(partials)

    intersection = MapSet.intersection(input_set, partial_set)

    intersection
    |> MapSet.to_list()
    |> Enum.reduce(
      1,
      fn x, acc -> x * acc end
    )
    |> IO.inspect()
  end
end
