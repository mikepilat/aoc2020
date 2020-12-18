defmodule Day18 do
  defmodule Parser do
    import NimbleParsec

    number = integer(min: 1) |> unwrap_and_tag(:number)

    open_parens = ignore(string("("))
    close_parens = ignore(string(")"))

    defparsec(
      :tokens,
      repeat(
        times(
          choice([
            number,
            string(" + ") |> replace({:add, 1}),
            string(" * ") |> replace({:mult, 1}),
            open_parens |> replace({:open, 1}),
            close_parens |> replace({:close, 1})
          ]),
          min: 1
        )
        |> reduce({Function, :identity, []})
        |> ignore(string("\n"))
      )
    )
  end

  def run do
    {:ok, file} = File.read("priv/input/day18")

    {:ok, input, "", _, _, _} =
      file
      |> Parser.tokens()

    input
    |> Enum.map(&:day18_part1_parser.parse/1)
    |> Enum.map(fn {:ok, expr} -> reduce(expr) end)
    |> Enum.sum()
    |> IO.inspect(label: "part 1")

    input
    |> Enum.map(&:day18_part2_parser.parse/1)
    |> Enum.map(fn {:ok, expr} -> reduce(expr) end)
    |> Enum.sum()
    |> IO.inspect(label: "part 2")
  end

  def reduce({{:mult, _}, lhs, rhs}), do: reduce(lhs) * reduce(rhs)
  def reduce({{:add, _}, lhs, rhs}), do: reduce(lhs) + reduce(rhs)
  def reduce({:number, n}), do: n
end
