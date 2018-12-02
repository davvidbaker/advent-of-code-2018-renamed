defmodule AdventOfCode2018.Day01 do
  def part1(args) do
    args |> Enum.map(&String.to_integer(&1)) |> Enum.sum()
  end

  def part2(args) do
    frequency_changes = args |> Enum.map(&String.to_integer(&1))

    my_func([0], frequency_changes, frequency_changes, 0)
  end

  def my_func(frequencies, frequency_changes, original_frequency_changes, iteration) do
    new_freq = List.last(frequencies) + List.first(frequency_changes)

    new_frequencies = frequencies ++ [new_freq]

    last_frequency = List.last(new_frequencies)

    if Enum.find(frequencies, fn x -> x == last_frequency end) do
      last_frequency
    else
      [_head | tail] = frequency_changes

      # 💁 just printing this out to see how many times I had to go through the input list
      if Enum.empty?(tail), do: IO.puts(iteration)

      if Enum.empty?(tail),
        do:
          my_func(
            new_frequencies,
            original_frequency_changes,
            original_frequency_changes,
            iteration + 1
          ),
        else: my_func(new_frequencies, tail, original_frequency_changes, iteration)
    end
  end
end
