defmodule Mix.Tasks.D10.P2 do
  use Mix.Task

  import AdventOfCode2018.Day10

  @shortdoc "Day 10 Part 2"
  def run(_) do
    input = File.stream!("lib/inputs/day_10.txt", [], :line)

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")
  end
end
