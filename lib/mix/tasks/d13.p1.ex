defmodule Mix.Tasks.D13.P1 do
  use Mix.Task

  import AdventOfCode2018.Day13

  @shortdoc "Day 13 Part 1"
  def run(_) do
    input = File.stream!("lib/inputs/day_13.txt", [], :line)

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
