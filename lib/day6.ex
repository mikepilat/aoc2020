defmodule Day6 do
  def run do
    {:ok, file} = File.read("priv/input/day6")

    groups =
      file
      |> String.trim()
      |> String.split("\n\n")

    groups
    |> Enum.map(fn s ->
      s
      |> String.replace(~r/\s+/, "")
      |> String.graphemes()
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
    |> IO.inspect(label: "part1")

    groups
    |> Enum.map(fn s ->
      s
      |> String.split("\n")
      |> Enum.map(fn s -> s |> String.graphemes() |> MapSet.new() end)
      |> Enum.reduce(fn p, acc -> MapSet.intersection(p, acc) end)
      |> MapSet.size()
    end)
    |> Enum.sum()
    |> IO.inspect(label: "part2")
  end
end
