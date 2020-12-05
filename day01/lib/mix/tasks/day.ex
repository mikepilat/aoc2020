defmodule Mix.Tasks.Day do
  def run([day]) do
    apply(String.to_existing_atom("Elixir.Day#{day}"), :run, [])
  end
end
