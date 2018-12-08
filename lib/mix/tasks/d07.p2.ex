defmodule Mix.Tasks.D07.P2 do
  use Mix.Task

  import AdventOfCode2018.Day07

  @shortdoc "Day 07 Part 2"
  def run(_) do
    input = File.stream!("lib/inputs/day_07.txt", [], :line)
    num_workers = 5
    extra_time_per_step = 60

    input
    |> part2(num_workers, extra_time_per_step)
    |> IO.inspect(label: "Part 2 Results")
  end
end
