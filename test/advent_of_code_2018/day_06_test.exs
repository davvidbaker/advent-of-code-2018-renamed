defmodule AdventOfCode2018.Day06Test do
  use ExUnit.Case

  import AdventOfCode2018.Day06

  @tag :skip
  test "part1" do
    {:ok, io} =
      StringIO.open("""
      1, 1
      1, 6
      8, 3
      3, 4
      5, 5
      8, 9
      """)

    result = part1(IO.stream(io, :line))

    assert result == 17
  end

  # @tag :skip
  test "part2" do
    {:ok, io} =
      StringIO.open("""
      1, 1
      1, 6
      8, 3
      3, 4
      5, 5
      8, 9
      """)

    result = part2(IO.stream(io, :line), 32)

    assert result == 16
  end
end
