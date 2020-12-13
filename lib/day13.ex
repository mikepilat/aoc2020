defmodule Day13 do
  def run do
    {:ok, file} = File.read("priv/input/day13")

    {earliest, buses} =
      file
      |> String.trim()
      |> String.split("\n")
      |> parse

    bus =
      buses
      |> Enum.min_by(fn {t, _} -> t - rem(earliest, t) end)
      |> elem(0)

    ((bus - rem(earliest, bus)) * bus)
    |> IO.inspect(label: "part 1")

    n =
      buses
      |> Enum.reduce(1, fn {x, _}, acc -> x * acc end)

    buses
    |> Enum.map(fn {ni, ai} ->
      nibar = div(n, ni)
      -ai * nibar * u(ni, nibar)
    end)
    |> Enum.sum()
    |> Integer.mod(n)
    |> IO.inspect(label: "part 2")
  end

  def u(modulus, nibar, ui \\ 1) do
    if Integer.mod(nibar * ui, modulus) == 1 do
      ui
    else
      u(modulus, nibar, ui + 1)
    end
  end

  defp parse([t, b]) do
    {String.to_integer(t),
     b
     |> String.split(",")
     |> Enum.with_index()
     |> Enum.reject(fn {x, _} -> x == "x" end)
     |> Enum.map(fn {x, i} -> {String.to_integer(x), i} end)}
  end
end
