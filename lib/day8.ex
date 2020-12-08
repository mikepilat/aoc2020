defmodule Day8 do
  defmodule Parser do
    import NimbleParsec

    op_nop = string("nop")
    op_acc = string("acc")
    op_jmp = string("jmp")

    argument =
      ascii_string([?+, ?-], max: 1)
      |> concat(integer(min: 1))
      |> reduce({Enum, :join, []})

    newline = string("\n")

    opcode =
      choice([op_nop, op_acc, op_jmp])
      |> ignore(string(" "))
      |> concat(argument)
      |> ignore(newline)
      |> reduce(:reduce_opcode)

    defparsec(:opcodes, repeat(opcode))

    defp reduce_opcode([inst, arg]) do
      {String.to_atom(inst), String.to_integer(arg)}
    end
  end

  def run do
    {:ok, file} = File.read("priv/input/day8")

    {:ok, opcodes, "", _, _, _} =
      file
      |> Parser.opcodes()

    compute(opcodes)
    |> IO.inspect(label: "part 1")

    opcodes
    |> Enum.with_index()
    |> Enum.filter(fn {{op, _arg}, _i} -> op != :acc end)
    |> Enum.reduce_while(0, fn {{op, arg}, idx}, _acc ->
      new_op =
        case op do
          :nop -> :jmp
          :jmp -> :nop
        end

      result =
        opcodes
        |> List.replace_at(idx, {new_op, arg})
        |> compute()

      case result do
        {:error, _} -> {:cont, :error}
        {:ok, acc} -> {:halt, {:ok, acc}}
      end
    end)
    |> IO.inspect(label: "part 2")
  end

  def compute(opcodes) do
    max = Enum.count(opcodes)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({MapSet.new(), 0, 0}, fn _i, {seen, ip, acc} ->
      {inst, arg} = Enum.at(opcodes, ip)
      {new_ip, new_acc} = apply_opcode(inst, arg, ip, acc)

      cond do
        MapSet.member?(seen, new_ip) -> {:halt, {:error, acc}}
        new_ip >= max -> {:halt, {:ok, new_acc}}
        true -> {:cont, {MapSet.put(seen, ip), new_ip, new_acc}}
      end
    end)
  end

  defp apply_opcode(:nop, _, ip, acc), do: {ip + 1, acc}
  defp apply_opcode(:acc, arg, ip, acc), do: {ip + 1, acc + arg}
  defp apply_opcode(:jmp, arg, ip, acc), do: {ip + arg, acc}
end
