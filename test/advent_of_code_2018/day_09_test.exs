defmodule AdventOfCode2018.Day09Test do
  use ExUnit.Case

  import AdventOfCode2018.Day09

  # @tag :skip
  test "part1" do
    assert part1(9, 25) == 32
    assert part1(10, 1618) == 8317
    assert part1(13, 7999) == 146_373
    assert part1(17, 1104) == 2764
    assert part1(21, 6111) == 54718
    assert part1(30, 5807) == 37305
  end
end
