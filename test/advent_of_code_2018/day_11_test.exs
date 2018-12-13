defmodule AdventOfCode2018.Day11Test do
  use ExUnit.Case

  import AdventOfCode2018.Day11

  # @tag :skip
  test "part1" do
    result = part1(18)
    assert result == {33, 45}

    result = part1(42)
    assert result == {21, 61}
  end

  @tag :skip
  test "part2" do
    result = part2(18)
    assert result == {90, 269, 16}

    result = part2(42)
    assert result == {232, 251, 12}
  end
end
