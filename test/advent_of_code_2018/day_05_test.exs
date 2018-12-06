defmodule AdventOfCode2018.Day05Test do
  use ExUnit.Case

  import AdventOfCode2018.Day05

  @tag :skip
  test "part1" do
    {:ok, io} = StringIO.open("aA")
    result = part1(IO.stream(io, :line))
    assert result == ""

    {:ok, io} = StringIO.open("abBA")
    result = part1(IO.stream(io, :line))
    assert result == ""

    {:ok, io} = StringIO.open("abAB")
    result = part1(IO.stream(io, :line))
    assert result == "abAB"

    {:ok, io} = StringIO.open("aabAAB")
    result = part1(IO.stream(io, :line))
    assert result == "aabAAB"

    {:ok, io} = StringIO.open("dabAcCaCBAcCcaDA")
    result = part1(IO.stream(io, :line))
    assert result == "dabCBAcaDA"
  end

  @tag :skip
  test "part2" do
    {:ok, io} = StringIO.open("dabAcCaCBAcCcaDA")
    result = part2(IO.stream(io, :line))
    assert result == 4
  end
end
