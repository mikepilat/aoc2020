defmodule Day7 do
  def run do
    {:ok, file} = File.read("priv/input/day7")

    graph =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&parse/1)
      |> Enum.reduce(%{}, &graph/2)

    walk(graph, "shiny gold")
    |> Enum.uniq()
    |> Enum.count()
    |> IO.inspect(label: "part 1")

    file
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse/1)
    |> Enum.reduce(%{}, &other_graph/2)
    |> walk2("shiny gold" |> String.to_atom())
    |> IO.inspect(label: "part 2")
  end

  def walk(graph, root) do
    case graph[root] do
      nil -> []
      list -> list ++ Enum.flat_map(list, fn e -> walk(graph, e) end)
    end
  end

  def walk2(graph, root) do
    case graph[root] do
      nil ->
        1

      list ->
        list
        |> Enum.reduce(1, fn {color, count}, acc ->
          acc + count * walk2(graph, color)
        end)
    end
  end

  def parse(line) do
    [_, container_color, rules] = Regex.run(~r/^(\w+ \w+) bags contain (.*)/, line)

    parsed_rules =
      case rules do
        "no other bags." ->
          []

        rules ->
          rules
          |> String.split(",")
          |> Enum.map(fn s ->
            [_, count, color] = Regex.run(~r/(\d+) (\w+ \w+)/, s)
            [count, color]
          end)
      end

    {container_color, parsed_rules}
  end

  def graph({container, rules}, map) do
    rules
    |> Enum.reduce(map, fn rule, acc ->
      case rule do
        [_count, color] ->
          Map.get_and_update(acc, color, fn val ->
            case val do
              # |> IO.inspect(label: "nil")
              nil -> {val, [container]}
              # |> IO.inspect(label: "got value for #{color}")
              list -> {val, [container | list]}
            end
          end)
          |> elem(1)

        ["no other"] ->
          acc
      end
    end)
  end

  def other_graph({container, rules}, map) do
    rules
    |> Enum.reduce(map, fn [count, color], acc ->
      Map.get_and_update(acc, String.to_atom(container), fn val ->
        case val do
          # |> IO.inspect(label: "nil")
          nil -> {val, [{String.to_atom(color), String.to_integer(count)}]}
          # |> IO.inspect(label: "got value for #{color}")
          list -> {val, [{String.to_atom(color), String.to_integer(count)} | list]}
        end
      end)
      |> elem(1)
    end)
  end
end
