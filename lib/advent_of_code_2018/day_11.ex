defmodule AdventOfCode2018.Day11 do
  @grid_dimension 300
  @spec part1(any()) :: any()
  def part1(serial_number) do
    power_grid = construct_power_grid(serial_number)
    power_mipmap = %{1 => power_grid}

    {coord, power, size, mipmap} =
      2..3
      |> Enum.reduce({{1, 1}, 0, 1, power_mipmap}, fn s,
                                                      {max_coord, max_power, max_size,
                                                       power_mipmap} = acc ->
        {coord, power, power_mipmap} = find_largest_s_by_s(power_grid, s, power_mipmap)

        IO.puts("\n")
        IO.inspect(s, label: "s")
        IO.inspect(coord, label: "coord")
        IO.inspect(power, label: "power")

        if power > max_power do
          {coord, power, s, power_mipmap}
        else
          {max_coord, max_power, max_size, power_mipmap}
        end
      end)

    # IO.inspect(mipmap, label: "mipmap")
    IO.inspect(coord, label: "result_coord")
    IO.inspect(power, label: "result_power")
    IO.inspect(size, label: "result_size")

    coord
  end

  # ⚠️ This actually errored out but the right answer was what had accumulated so far.
  def part2(serial_number) do
    power_grid = construct_power_grid(serial_number)
    power_mipmap = %{1 => power_grid}

    2..@grid_dimension
    |> Enum.reduce({{1, 1}, 0, 1, power_mipmap}, fn s,
                                                    {max_coord, max_power, max_size, power_mipmap} =
                                                      acc ->
      {coord, power, power_mipmap} = find_largest_s_by_s(power_grid, s, power_mipmap)

      IO.puts("\n")
      IO.inspect(s, label: "s")
      IO.inspect(coord, label: "coord")
      IO.inspect(power, label: "power")

      if power > max_power do
        {coord, power, s, power_mipmap}
      else
        acc
      end
    end)
  end

  # ⚠️ naive
  defp find_largest_s_by_s(power_grid, s, power_mipmap) do
    upper_range = @grid_dimension + 1 - s

    {coord, power, grid} =
      1..upper_range
      |> Enum.reduce({{1, 1}, 0, []}, fn x, {coord, power, grid} = acc ->
        {coord, power, col_powers} =
          1..upper_range
          |> Enum.reduce({coord, power, []}, fn y, {coord_2, power_2, col_powers} ->
            square_power = calculate_square_power({x, y}, power_grid, s, power_mipmap)

            col_powers = [square_power | col_powers]

            {{x, y}, square_power} =
              if square_power > power_2 do
                {{x, y}, square_power}
              else
                {coord_2, power_2}
              end

            {{x, y}, square_power, col_powers}
          end)

        {coord, power, [Enum.reverse(col_powers) | grid]}
      end)

    power_mipmap = Map.put(power_mipmap, s, Enum.reverse(grid))

    {coord, power, power_mipmap}
  end

  # strategy: break up the square into biggest smaller squares and add those together, since we have already calculated those
  defp calculate_square_power({x, y}, power_grid, s, power_mipmap) do
    biggest_smaller_square_size = div(s, 2)
    remaining = rem(s, 2)

    bigger_squares_sum =
      Enum.sum(
        for y <- [y - 1, y + biggest_smaller_square_size - 1],
            x <- [x - 1, x + biggest_smaller_square_size - 1] do
          # IO.inspect(Map.get(power_mipmap, biggest_smaller_square_size),
          #   label: "power_mipmap[biggest_smaller_square_size]"
          # )

          smaller_square_power =
            Map.get(power_mipmap, biggest_smaller_square_size) |> Enum.at(x) |> Enum.at(y)

          smaller_square_power
        end
      )

    edges_sum =
      case remaining do
        0 ->
          0

        1 ->
          right_edge_x = x + s - 2
          bottom_edge_y = y + s - 2

          # IO.inspect(s, label: "s")
          # IO.inspect(x, label: "x")
          # IO.inspect(y, label: "y")
          # IO.inspect(right_edge_x, label: "right_edge_x")
          # IO.inspect(bottom_edge_y, label: "bottom-edge_y")

          # IO.inspect(x, label: "x")
          # IO.inspect(y, label: "y")
          # IO.inspect(right_edge_x, label: "right_edge_x")
          # IO.inspect(bottom_edge_y, label: "bottom_edge_y")

          vertical_edge_sum =
            Enum.sum(
              for y <- (y - 1)..bottom_edge_y do
                # IO.inspect(right_edge_x, label: "right_edge_x")
                # IO.inspect(y, label: "y")

                power_grid
                |> Enum.at(right_edge_x)
                |> Enum.at(y)
              end
            )

          # IO.inspect(vertical_edge_sum, label: "vertical_edge_sum")

          horizontal_edge_sum =
            Enum.sum(
              # 💁 minus 1 so we don't duplicate the corner
              for x <- (x - 1)..(right_edge_x - 1) do
                # IO.inspect(right_edge_x, label: "bottom_edge_y")
                # IO.inspect(x, label: "x")

                power_grid
                |> Enum.at(x)
                |> Enum.at(bottom_edge_y)
              end
            )

          # IO.inspect(horizontal_edge_sum, label: "horizontal_edge_sum")

          horizontal_edge_sum + vertical_edge_sum
      end

    # IO.inspect(bigger_squares_sum, label: "bigger_squares_sum")
    # IO.inspect(edges_sum, label: "edges_sum")
    edges_sum + bigger_squares_sum
  end

  defp construct_power_grid(serial_number) do
    power_grid =
      for x <- 1..@grid_dimension, y <- 1..@grid_dimension do
        rack_id = x + 10

        rack_id
        |> Kernel.*(y)
        |> Kernel.+(serial_number)
        |> Kernel.*(rack_id)
        |> hundreds_digit
        |> Kernel.-(5)
      end

    Enum.chunk_every(power_grid, @grid_dimension)
  end

  defp hundreds_digit(num) do
    num
    |> Integer.digits()
    |> Enum.reverse()
    |> Enum.at(2, 0)
  end
end
