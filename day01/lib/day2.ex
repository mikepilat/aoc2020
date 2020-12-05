defmodule Day2 do
  def run do
    part1()
    part2()
  end

  def part1 do
    {:ok, file} = File.read("priv/input/day2")

    file
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, " ") end)
    |> Enum.count(&valid_password/1)
    |> IO.inspect(label: "part1")
  end

  def valid_password([policy, letter, password]) do
    [{min, _}, {max, _}] =
      policy
      |> String.split("-")
      |> Enum.map(&Integer.parse/1)

    char = String.first(letter)

    count =
      String.graphemes(password)
      |> Enum.count(fn c -> c == char end)

    min <= count && count <= max
  end

  def part2 do
    {:ok, file} = File.read("priv/input/day2")

    file
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, " ") end)
    |> Enum.count(&valid_password_2/1)
    |> IO.inspect(label: "part2")
  end

  def valid_password_2([policy, letter, password]) do
    [{pos1, _}, {pos2, _}] =
      policy
      |> String.split("-")
      |> Enum.map(&Integer.parse/1)

    char = String.first(letter)

    xor(
      String.at(password, pos1 - 1) == char,
      String.at(password, pos2 - 1) == char
    )
  end

  def xor(true, false), do: true
  def xor(false, true), do: true
  def xor(_, _), do: false
end
