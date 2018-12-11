defmodule Mix.Tasks.D09.P2 do
  use Mix.Task

  import AdventOfCode2018.Day09

  @shortdoc "Day 09 Part "
  def run(_) do
    part2(416, 71975)
    |> IO.inspect(label: "Part 1 Results")
  end
end
