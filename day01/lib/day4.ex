defmodule Day4 do
  @required ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  def run do
    part1()
    part2()
  end

  def part1 do
    {:ok, file} = File.read("priv/input/day4")

    file
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse/1)
    |> Enum.count(&has_required?/1)
    |> IO.inspect(label: "part1")
  end

  def has_required?(items) do
    have =
      items
      |> Enum.map(&List.first/1)
      |> MapSet.new()

    diff =
      @required
      |> MapSet.new()
      |> MapSet.difference(have)
      |> MapSet.to_list()

    diff == []
  end

  def part2 do
    {:ok, file} = File.read("priv/input/day4")

    file
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse/1)
    |> Enum.filter(&has_required?/1)
    |> Enum.count(&valid?/1)
    |> IO.inspect(label: "part2")
  end

  def parse(line) do
    line
    |> String.split(~r/\s+/m, trim: true)
    |> Enum.map(&String.split(&1, ":"))
  end

  defp valid?(item) do
    item
    |> Enum.map(&valid_item?/1)
    |> Enum.reduce(true, fn x, acc -> x && acc end)
  end

  defp valid_item?(["byr", y]) do
    {year, _} = Integer.parse(y)
    year >= 1920 && year <= 2002
  end

  defp valid_item?(["iyr", y]) do
    {year, _} = Integer.parse(y)
    year >= 2010 && year <= 2020
  end

  defp valid_item?(["eyr", y]) do
    {year, _} = Integer.parse(y)
    year >= 2020 && year <= 2030
  end

  defp valid_item?(["hcl", hcl]) do
    Regex.match?(~r/^#[a-f0-9]{6}$/, hcl)
  end

  defp valid_item?(["cid", _]), do: true

  defp valid_item?(["ecl", c]) when c in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],
    do: true

  defp valid_item?(["pid", pid]) do
    Regex.match?(~r/^[0-9]{9}$/, pid)
  end

  # If cm, the number must be at least 150 and at most 193.
  # If in, the number must be at least 59 and at most 76.
  defp valid_item?(["hgt", h]) do
    case Integer.parse(h) do
      {measure, "in"} -> measure >= 59 && measure <= 76
      {measure, "cm"} -> measure >= 150 && measure <= 193
      _ -> false
    end
  end

  defp valid_item?(_), do: false
end
