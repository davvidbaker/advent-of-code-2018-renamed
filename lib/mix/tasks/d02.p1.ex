defmodule Mix.Tasks.D02.P1 do
  use Mix.Task

  import AdventOfCode2018.Day02

  @shortdoc "Day 02 Part 1"
  def run(_) do
    input = File.stream!("lib/inputs/day_02.txt", [], :line)

    input
    |> part1()
    |> IO.inspect(label: "Part 1 Results")
  end
end
