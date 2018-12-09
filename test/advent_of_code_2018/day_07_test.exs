defmodule AdventOfCode2018.Day07Test do
  use ExUnit.Case

  import AdventOfCode2018.Day07

  @tag :skip
  test "part1" do
    {:ok, io} =
      StringIO.open("""
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
      Step A must be finished before step D can begin.
      Step B must be finished before step E can begin.
      Step D must be finished before step E can begin.
      Step F must be finished before step E can begin.
      """)

    result = part1(IO.stream(io, :line))

    assert result == "CABDFE"
  end

  @tag :skip
  test "part2" do
    {:ok, io} =
      StringIO.open("""
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
      Step A must be finished before step D can begin.
      Step B must be finished before step E can begin.
      Step D must be finished before step E can begin.
      Step F must be finished before step E can begin.
      """)

    num_workers = 2
    extra_time_per_step = 0

    result = part2(IO.stream(io, :line), num_workers, extra_time_per_step)

    assert result == 15
  end
end
