defmodule AdventOfCode2018.Day10 do
  def part1(file_stream) do
    positions_and_velocities = parse_input(file_stream)

    1..20000
    |> Enum.reduce(positions_and_velocities, fn idx, acc ->
      positions_and_velocities = move_points(acc)
      IO.inspect(idx, label: "idx")

      plot(positions_and_velocities |> Enum.map(&elem(&1, 0)), idx)

      positions_and_velocities
    end)
  end

  def part2(args) do
  end

  defp move_points(positions_and_velocities) do
    positions_and_velocities
    |> Enum.map(fn {{p_x, p_y}, {v_x, v_y}} -> {{p_x + v_x, p_y + v_y}, {v_x, v_y}} end)
  end

  defp parse_input(file_stream) do
    file_stream
    |> Enum.map(fn line ->
      [_match, p_x, p_y, v_x, v_y] = Regex.run(~r/<(.*),(.*)>.*<(.*),(.*)>/, line)

      position =
        {p_x |> String.trim() |> String.to_integer(), p_y |> String.trim() |> String.to_integer()}

      velocity =
        {v_x |> String.trim() |> String.to_integer(), v_y |> String.trim() |> String.to_integer()}

      {position, velocity}
    end)
  end

  defp plot(coords, iteration) do
    {{min_x, _y}, {max_x, _y2}} = coords |> Enum.min_max_by(fn {x, _y} -> x end)
    {{_x, min_y}, {_x2, max_y}} = coords |> Enum.min_max_by(fn {_x, y} -> y end)

    # empty_grid = create_grid(min_x, max_x, min_y, max_y, coords)
    grid_width = max_x - min_x + 4
    grid_height = max_y - min_y + 4

    # grid = Enum.chunk_every(empty_grid, grid_width)

    IO.inspect(grid_width, label: "grid_width")
    IO.inspect(grid_height, label: "grid_height")

    if grid_width < 500 do
      image = :egd.create(grid_width, grid_height)

      for {x, y} <- coords do
        :egd.filledRectangle(
          image,
          {x - min_x + 1, y - min_y + 1},
          {2 + x - min_x, 2 + y - min_y},
          :egd.color({0, 0, 0})
        )
      end

      image = :egd.render(image)
      File.write!("lib/output/day_10_#{iteration}.png", image)
    end

    # # end)
  end

  defp create_grid(min_x, max_x, min_y, max_y, coords) do
    for x <- min_x..max_x, y <- min_y..max_y do
      "."
    end

    # min_x..max_x
    # |> Enum.reduce(%{}, fn x, acc ->
    #   Map.put(
    #     acc,
    #     x,
    #     min_y..max_y
    #     |> Enum.reduce(%{}, fn y, acc_2 -> Map.put(acc_2, y, closest_coordinate(x, y, coords)) end)
    #   )
    # end)
  end
end
