defmodule Day3 do
  def run do
    part1()
    part2()
  end

  def part1 do
    {:ok, file} = File.read("priv/input/day3")

    file
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.count(&tree?/1)
    |> IO.inspect(label: "part1")
  end

  defp tree?({row, index}) do
    stream = Stream.cycle(row)

    last =
      stream
      |> Stream.take(index * 3 + 1)
      |> Enum.to_list()
      |> List.last()

    last == "#"
  end

  def part2 do
    slopes = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]

    {:ok, file} = File.read("priv/input/day3")

    input =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    slopes
    |> Enum.map(&run_slope(input, &1))
    |> Enum.reduce(1, fn x, acc -> x * acc end)
    |> IO.inspect(label: "part2")
  end

  defp run_slope(input, {right, down}) do
    input
    |> Enum.take_every(down)
    |> Enum.with_index()
    |> Enum.map(&tree2?(right, &1))
    |> Enum.count(fn b -> b end)
  end

  defp tree2?(offset, {row, index}) do
    stream = Stream.cycle(row)

    last =
      stream
      |> Stream.take(index * offset + 1)
      |> Enum.to_list()
      |> List.last()

    last == "#"
  end
end
