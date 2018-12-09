defmodule AdventOfCode2018.Day08Test do
  use ExUnit.Case

  import AdventOfCode2018.Day08

  @tag :skip
  test "part1" do
    {:ok, io} =
      StringIO.open("""
      2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
      """)

    result = part1(IO.stream(io, :line))

    assert result == 138
  end

  @tag :skip
  test "part2" do
    {:ok, io} =
      StringIO.open("""
      2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
      """)

    result = part2(IO.stream(io, :line))

    assert result == 66
  end
end
