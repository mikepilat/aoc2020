defmodule Day5 do
  use Bitwise

  def run do
    {:ok, file} = File.read("priv/input/day5")

    ids =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn s ->
        s
        |> String.replace(["F", "L"], "0")
        |> String.replace(["R", "B"], "1")
        |> Integer.parse(2)
        |> elem(0)
      end)
      |> Enum.map(fn i ->
        (i >>> 3) * 8 + (i &&& 7)
      end)

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
end
