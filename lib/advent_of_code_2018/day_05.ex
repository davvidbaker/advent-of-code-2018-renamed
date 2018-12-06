defmodule AdventOfCode2018.Day05 do
  def part1(str) do
    str
    |> Enum.join()
    |> String.split("", trim: true)
    |> collapse_chain()
    |> Enum.reverse()
    |> Enum.join()
  end

  def part2(str) do
    unreacted_chain =
      str
      |> Enum.join()
      |> String.split("", trim: true)

    uniq_types =
      unreacted_chain
      |> Enum.uniq_by(fn unit -> String.upcase(unit) end)
      |> Enum.map(&String.upcase(&1))

    uniq_types
    |> Enum.map(fn unit_type ->
      unreacted_chain
      |> Enum.filter(fn unit -> String.upcase(unit) != unit_type end)
      |> collapse_chain()
    end)
    |> Enum.map(&length(&1))
    |> Enum.min()
  end

  defp collapse_chain(chain) do
    chain
    |> Enum.reduce([], fn unit, acc ->
      if Enum.empty?(acc) do
        [unit]
      else
        [last_unit | tail] = acc

        case last_unit do
          ^unit ->
            [unit | acc]

          _ ->
            if String.upcase(unit) == last_unit || String.downcase(unit) == last_unit do
              tail
            else
              [unit | acc]
            end
        end
      end
    end)
  end
end
