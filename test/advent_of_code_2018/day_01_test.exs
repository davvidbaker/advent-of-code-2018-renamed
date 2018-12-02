defmodule AdventOfCode2018.Day01Test do
  use ExUnit.Case

  import AdventOfCode2018.Day01
  @tag :skip
  test "part1" do
    input = ~w[1 -2 3 1]
    result = part1(input)

    assert result == 3
  end

  @tag :skip
  test "part2" do
    input = ~w[+7 +7 -2 -7 -4]
    result = part2(input)
    assert result == 14

    input = ~w[-6 +3 +8 +5 -6]
    result = part2(input)
    assert result == 5
  end
end
