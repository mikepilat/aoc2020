defmodule Mix.Tasks.Day01 do
  def run([part]) do
    case part do
      "2" ->
        Day01.part2()

      _ ->
        Day01.part1()
    end
  end

  def run([]) do
    run(["1"])
  end
end
