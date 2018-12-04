defmodule Mix.Tasks.D03.P1 do
  use Mix.Task

  import AdventOfCode2018.Day03

  @shortdoc "Day 03 Part 1"
  def run(_) do
    input = File.stream!("lib/inputs/day_03.txt", [], :line)

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
