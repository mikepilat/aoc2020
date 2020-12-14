defmodule Day14 do
  import Bitwise

  defmodule Parser do
    import NimbleParsec

    mask =
      ignore(string("mask = "))
      |> ascii_string([?0, ?1, ?X], max: 36)
      |> reduce(:reduce_mask)

    mem =
      ignore(string("mem["))
      |> concat(integer(min: 1))
      |> ignore(string("] = "))
      |> concat(integer(min: 1))
      |> reduce(:reduce_mem)

    newline = string("\n")

    defparsec(:input, repeat(choice([mask, mem]) |> ignore(newline)))

    def reduce_mask([mask]), do: {:mask, mask}

    def reduce_mem([addr, value]), do: {:mem, addr, value}
  end

  def run do
    {:ok, file} = File.read("priv/input/day14")

    {:ok, commands, "", _, _, _} =
      file
      |> Parser.input()

    commands
    |> Enum.reduce({nil, %{}}, &compute/2)
    |> elem(1)
    |> Enum.reduce(0, fn {_, x}, acc -> x + acc end)
    |> IO.inspect(label: "part 1")

    commands
    |> Enum.reduce({nil, %{}}, &compute2/2)
    |> elem(1)
    |> Enum.map(fn {floaty, val} ->
      num_x =
        floaty
        |> String.graphemes()
        |> Enum.count(fn x -> x == "X" end)

      :math.pow(2, num_x) * val
    end)
    |> Enum.sum()
    |> trunc
    |> IO.inspect(label: "part 2")
  end

  defp compute({:mask, mask}, {_, mem}), do: {mask, mem}

  defp compute({:mem, addr, value}, {mask, mem}) do
    {mask, Map.put(mem, addr, apply_mask(value, mask))}
  end

  defp apply_mask(value, mask) do
    bitmask =
      mask |> String.replace(~r/[01]/, "1") |> String.replace("X", "0") |> String.to_integer(2)

    bitvalue = mask |> String.replace("X", "0") |> String.to_integer(2)

    (value &&& bnot(bitmask)) ||| (bitvalue &&& bitmask)
  end

  defp compute2({:mask, mask}, {_, mem}) do
    {mask, mem}
  end

  defp compute2({:mem, addr, value}, {mask, mem}) do
    addrs =
      addr
      |> apply_addr_mask(mask)

    {mask, addrs |> Enum.reduce(mem, fn a, acc -> Map.put(acc, a, value) end)}
  end

  defp apply_addr_mask(addr, mask) do
    addr
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.graphemes()
    |> Enum.zip(mask |> String.graphemes())
    |> Enum.map(fn pair ->
      case pair do
        {a, "0"} -> a
        {_, "1"} -> "1"
        {_, "X"} -> "X"
      end
    end)
    |> Enum.reduce([""], fn c, acc ->
      case c do
        "X" ->
          Enum.map(acc, fn s -> s <> "0" end) ++ Enum.map(acc, fn s -> s <> "1" end)

        d ->
          Enum.map(acc, fn s -> s <> d end)
      end
    end)
  end
end
