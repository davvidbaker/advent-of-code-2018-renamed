defmodule Mix.Tasks.D05.P2 do
  use Mix.Task

  import AdventOfCode2018.Day05

  @shortdoc "Day 05 Part 2"
  def run(_) do
    input = File.stream!("lib/inputs/day_05.txt", [], :line)

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")
  end
end
