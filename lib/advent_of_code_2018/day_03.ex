defmodule AdventOfCode2018.Day03 do
  def part1(file_stream) do
    file_stream
    |> Enum.map(&parse_claim(&1))
    |> Enum.reduce(%{}, fn claim, diagram -> draw_claim(claim, diagram) end)
    |> print_diagram()
    |> count_overlaps()
  end

  def part2(file_stream) do
    claims =
      file_stream
      |> Enum.map(&parse_claim(&1))

    str_diagram =
      claims
      |> Enum.reduce(%{}, fn claim, diagram -> draw_claim(claim, diagram) end)
      |> print_diagram()

    areas(claims)
    |> find_untouched(String.codepoints(str_diagram))
  end

  defp areas(claims) do
    claims
    |> Enum.reduce(%{}, fn {id, _x, _y, width, height}, acc ->
      Map.put(acc, id, width * height)
    end)
  end

  # ⚠️ not optimal
  defp find_untouched(claim_areas, diagram_codepoints) do
    Map.keys(claim_areas)
    |> Enum.reduce_while(nil, fn claim_id, answer ->
      area = Map.get(claim_areas, claim_id)

      claim_tile_count =
        Enum.count(diagram_codepoints, fn c -> c == <<String.to_integer(claim_id)::utf8>> end)

      if area == claim_tile_count, do: {:halt, claim_id}, else: {:cont, nil}
    end)
  end

  defp count_overlaps(str) do
    length(Regex.scan(~r/(X)/, str))
  end

  defp print_diagram(diagram) do
    str =
      1..Enum.max(Map.keys(diagram))
      |> Enum.reduce("\n", fn x, str ->
        col = if Map.has_key?(diagram, x), do: Map.get(diagram, x), else: %{}

        return_str =
          1..Enum.max(Map.keys(col))
          |> Enum.reduce(
            "",
            fn y, col_str ->
              col_str <> if Map.has_key?(col, y), do: Map.get(col, y), else: "•"
            end
          )
          |> (fn str -> str <> "\n" end).()

        str <> return_str
      end)

    str
  end

  defp draw_claim({id, x, y, width, height}, diagram) do
    x..(x + width - 1)
    |> Enum.reduce(diagram, fn i, grid ->
      existing_column = if Map.has_key?(diagram, i), do: Map.get(diagram, i), else: %{}

      column =
        y..(y + height - 1)
        |> Enum.reduce(existing_column, fn j, column_map ->
          grid_value = if Map.get(column_map, j), do: "X", else: <<String.to_integer(id)::utf8>>
          column_map |> Map.put(j, grid_value)
        end)

      Map.put(
        grid,
        i,
        column
      )
    end)
  end

  defp parse_claim(line) do
    [hash_id, _at, coords, width_by_height] = line |> String.split(" ")

    [_, id] = Regex.run(~r/#(.*)/, hash_id)
    [_, x, y] = Regex.run(~r/(\d+),(\d+)/, coords)
    [_, width, height] = Regex.run(~r/(\d+)x(\d+)/, width_by_height)

    [x, y, width, height] = [x, y, width, height] |> Enum.map(&String.to_integer(&1))

    {id, x, y, width, height}
  end
end
