defmodule Day10 do
  defmodule Path do
    use Agent

    def start do
      Agent.start_link(fn -> %{} end, name: __MODULE__)
    end

    def paths([a, b]) when b - a <= 3, do: 1

    def paths([a, b | rest] = adapters) do
      cached_value = Agent.get(__MODULE__, &Map.get(&1, adapters))

      if cached_value do
        cached_value
      else
        v =
          cond do
            b - a <= 3 ->
              paths([a | rest]) + paths([b | rest])

            true ->
              0
          end

        Agent.update(__MODULE__, &Map.put(&1, adapters, v))
        v
      end
    end
  end

  def paths(_), do: 0

  def run do
    {:ok, file} = File.read("priv/input/day10")

    input =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()

    max = input |> Enum.max()
    chain = [0 | input] ++ [max + 3]

    deltas =
      chain
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    deltas
    |> Enum.frequencies()
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(1, fn x, acc -> x * acc end)
    |> IO.inspect(label: "part 1")

    {:ok, _} = Path.start()

    Path.paths(chain)
    |> IO.inspect(label: "part 2")
  end
end
