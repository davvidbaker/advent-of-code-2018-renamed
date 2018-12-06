defmodule AdventOfCode2018.Day06 do
  def part1(file_stream) do
    coords =
      file_stream
      |> parse_coords()

    {{min_x, _y}, {max_x, _y2}} = coords |> Enum.min_max_by(fn {x, _y} -> x end)
    {{_x, min_y}, {_x2, max_y}} = coords |> Enum.min_max_by(fn {_x, y} -> y end)

    grid = create_grid_1(min_x, max_x, min_y, max_y, coords)

    # 💁 any coordinate that is closest to one of the edges will have an infinite area, so we don't care about those
    infinite_area_coords =
      grid
      |> Map.to_list()
      |> Enum.reduce([], fn {x, y_map}, acc ->
        y_map
        |> Map.to_list()
        |> Enum.reduce(acc, fn {y, coord_index}, acc_2 ->
          unless(coord_index == nil) do
            if x == min_x || x == max_x do
              [coord_index | acc_2]
            else
              if y == min_y || y == max_y do
                [coord_index | acc_2]
              else
                acc_2
              end
            end
          else
            acc_2
          end
        end)
      end)
      |> Enum.uniq()

    coord_areas(infinite_area_coords, grid)
  end

  def part2(file_stream, area_upper_bound) do
    coords =
      file_stream
      |> parse_coords()

    {{min_x, _y}, {max_x, _y2}} = coords |> Enum.min_max_by(fn {x, _y} -> x end)
    {{_x, min_y}, {_x2, max_y}} = coords |> Enum.min_max_by(fn {_x, y} -> y end)

    grid = create_grid_2(min_x, max_x, min_y, max_y, coords)

    grid
    |> Map.values()
    |> Enum.flat_map(&Map.values(&1))
    |> Enum.filter(fn area -> area < area_upper_bound end)
    |> length
  end

  defp coord_areas(infinite_area_coords, grid) do
    grid
    |> Map.values()
    |> Enum.flat_map(&Map.values(&1))
    |> Enum.filter(fn coord_index ->
      !is_nil(coord_index) && !Enum.any?(infinite_area_coords, fn iac -> iac == coord_index end)
    end)
    |> Enum.group_by(fn x -> x end)
    |> Map.values()
    |> Enum.map(&length(&1))
    |> Enum.max()
  end

  defp create_grid_1(min_x, max_x, min_y, max_y, coords) do
    min_x..max_x
    |> Enum.reduce(%{}, fn x, acc ->
      Map.put(
        acc,
        x,
        min_y..max_y
        |> Enum.reduce(%{}, fn y, acc_2 -> Map.put(acc_2, y, closest_coordinate(x, y, coords)) end)
      )
    end)
  end

  defp create_grid_2(min_x, max_x, min_y, max_y, coords) do
    min_x..max_x
    |> Enum.reduce(%{}, fn x, acc ->
      Map.put(
        acc,
        x,
        min_y..max_y
        |> Enum.reduce(%{}, fn y, acc_2 ->
          Map.put(acc_2, y, distance_to_all_coordinates(x, y, coords))
        end)
      )
    end)
  end

  defp distance_to_all_coordinates(x, y, coords) do
    coords
    |> Enum.map(&distance(&1, {x, y}))
    |> Enum.sum()
  end

  defp closest_coordinate(x, y, coords) do
    big_number = :math.pow(2, 20)

    coords
    |> Enum.map(&distance(&1, {x, y}))
    |> Enum.with_index()
    |> Enum.reduce({big_number, 0}, fn {distance, index}, {min_distance, coord_index} = acc ->
      if distance == min_distance do
        {min_distance, nil}
      else
        if distance < min_distance do
          {distance, index}
        else
          acc
        end
      end
    end)
    |> elem(1)

    # |> Enum.min_by(fn {distance, _index} -> distance end)
  end

  # 💁 manhattan_distance
  defp distance({x1, y1}, {x2, y2}) do
    abs(x2 - x1) + abs(y2 - y1)
  end

  defp parse_coords(file_stream) do
    file_stream
    |> Stream.map(fn line -> String.trim(line) end)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn [x_str, y_str] ->
      [x_str, y_str]
      |> Enum.map(&String.trim(&1))
      |> Enum.map(&String.to_integer(&1))
      |> List.to_tuple()
    end)
  end
end
