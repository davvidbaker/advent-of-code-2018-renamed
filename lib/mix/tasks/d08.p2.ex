defmodule Mix.Tasks.D08.P2 do
  use Mix.Task

  import AdventOfCode2018.Day08

  @shortdoc "Day 08 Part 2"
  def run(_) do
    input = File.stream!("lib/inputs/day_08.txt", [], :line)

    input
    |> part2()
    |> IO.inspect(label: "Part 2 Results")
  end
end
