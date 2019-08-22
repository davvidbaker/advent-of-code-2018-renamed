defmodule AdventOfCode2018.Day14Test do
  use ExUnit.Case

  import AdventOfCode2018.Day14

  # @tag :skip
  test "part1" do
    assert part1(9) == 5_158_916_779
    assert part1(5) == 0_124_515_891
    assert part1(18) == 9_251_071_085
    assert part1(2018) == 5_941_429_882
  end

  @tag :skip
  test "part2" do
    {:ok, io} = StringIO.open()
    result = part2(IO.stream(io, :line))

    assert result
  end
end
