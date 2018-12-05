defmodule Mix.Tasks.D04.P2 do
  use Mix.Task

  import AdventOfCode2018.Day04

  @shortdoc "Day 04 Part 2"
  def run(_) do
    input = File.stream!("lib/inputs/day_04.txt", [], :line)

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")
  end
end
