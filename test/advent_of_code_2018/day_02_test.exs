defmodule AdventOfCode2018.Day02Test do
  use ExUnit.Case

  import AdventOfCode2018.Day02

  @tag :skip
  test "part1" do
    {:ok, io} =
      StringIO.open("""
      abcdef
      abbcde
      abcccd
      aabcdd
      abcdee
      ababab
      bababc
      """)

    result = part1(IO.stream(io, :line))
    assert result == 12

    {:ok, io} =
      StringIO.open("""
      abcccd
      aabcdd
      """)

    result = part1(IO.stream(io, :line))
    assert result == 1

    {:ok, io} =
      StringIO.open("""
      abcccb
      aabcdd
      aabcdd
      fffggg
      """)

    result = part1(IO.stream(io, :line))
    assert result == 6
  end

  @tag :skip
  test "part2" do
    {:ok, io} =
      StringIO.open("""
      abcde
      fghij
      klmno
      pqrst
      fguij
      axcye
      wvxyz
      """)

    result = part2(IO.stream(io, :line))

    assert result == "fgij"
  end
end
