defmodule Day5 do
  def run do
    {:ok, file} = File.read("priv/input/day5")

    ids =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&parse/1)

    max =
      ids
      |> Enum.max()
      |> IO.inspect(label: "max id")

    MapSet.difference(
      MapSet.new(1..max),
      MapSet.new(ids)
    )
    |> MapSet.to_list()
    |> IO.inspect(label: "missing seats")
  end

  def parse(list) do
    row =
      list
      |> Enum.take(7)
      |> partition(128, "F", "B")

    seat =
      list
      |> Enum.drop(7)
      |> partition(8, "L", "R")

    trunc(row) * 8 + trunc(seat)
  end

  def partition(partitions, num, lower, upper) do
    partitions
    |> Enum.reduce([0, num - 1], fn e, acc ->
      [min, max] = acc

      case e do
        ^lower ->
          [min, min + (max - min - 1) / 2]

        ^upper ->
          [min + (max - min + 1) / 2, max]
      end
    end)
    |> hd
  end
end
