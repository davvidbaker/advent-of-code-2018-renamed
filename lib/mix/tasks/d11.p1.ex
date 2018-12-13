defmodule Mix.Tasks.D11.P1 do
  use Mix.Task

  import AdventOfCode2018.Day11

  @shortdoc "Day 11 Part 1"
  def run(_) do
    input = 1723

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
