defmodule Mix.Tasks.D06.P1 do
  use Mix.Task

  import AdventOfCode2018.Day06

  @shortdoc "Day 06 Part 1"
  def run(_) do
    input = File.stream!("lib/inputs/day_06.txt", [], :line)

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
