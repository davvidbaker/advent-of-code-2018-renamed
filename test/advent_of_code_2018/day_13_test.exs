defmodule AdventOfCode2018.Day13Test do
  use ExUnit.Case

  import AdventOfCode2018.Day13

  # @tag :skip
  test "part1" do
    input = File.stream!("lib/inputs/day_13_test.txt", [], :line)
    result = part1(input)

    assert result == %{x: 7, y: 3}

    input = File.stream!("lib/inputs/day_13_2_4_test.txt", [], :line)
    result = part1(input)

    assert result == %{x: 83, y: 49}
  end

  # @tag :skip
  test "part2" do
    input = File.stream!("lib/inputs/day_13_2_test.txt", [], :line)
    result = part2(input)

    assert result == %{x: 6, y: 4}

    input = File.stream!("lib/inputs/day_13_2_2_test.txt", [], :line)
    result = part2(input)

    assert result == %{x: 0, y: 0}

    input = File.stream!("lib/inputs/day_13_2_3_test.txt", [], :line)
    result = part2(input)

    assert result == %{x: 0, y: 0}

    input = File.stream!("lib/inputs/day_13_2_4_test.txt", [], :line)
    result = part2(input)

    assert result == %{x: 73, y: 36}
  end
end
