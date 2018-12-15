defmodule AdventOfCode2018.Day13 do
  def part1(file_stream) do
    IO.puts("\n")
    diagram = file_stream |> Enum.to_list()

    carts = extract_carts_from_diagram(diagram)

    diagram = diagram_without_carts(diagram)

    print_diagram_with_carts(diagram, carts)

    carts = iterate(carts, diagram)

    carts
    |> Enum.group_by(& &1)
    |> Enum.filter(fn
      {_, [_, _ | _]} -> true
      _ -> false
    end)
    |> Enum.map(fn {x, _} -> x end)
    |> List.first()
    # |> elem(1)
    |> Map.get(:position)

    # |> Map.get(:position)
  end

  def part2(file_stream) do
    IO.puts("\n")
    diagram = file_stream |> Enum.to_list()

    carts = extract_carts_from_diagram(diagram)

    carts = carts |> Enum.with_index() |> Enum.map(fn {c, ind} -> {ind, c} end) |> Map.new()

    diagram = diagram_without_carts(diagram)

    cart = iterate_with_removal(carts, diagram)

    IO.inspect(cart, label: "cart")

    elem(cart, 1) |> Map.get(:position)
  end

  defp iterate_with_removal(cart_map, diagram) do
    cart_list =
      cart_map
      |> Map.to_list()
      |> Enum.sort_by(fn {_ind, x} ->
        sort_by_mapper(x)
      end)

    cart_list =
      cart_list
      |> Enum.reduce(
        cart_list,
        fn {id, cart}, acc ->
          {_id, existing} = Enum.find(acc, fn {acc_id, _cart} -> id == acc_id end)
          # IO.inspect(existing, label: "existing")

          if is_nil(existing) do
            acc
          else
            index = Enum.find_index(acc, fn {acc_id, _acc_art} -> acc_id == id end)

            acc =
              List.replace_at(
                acc,
                index,
                {id, move_cart(cart, diagram)}
              )

            # check if two carts are in the same position
            just_positions =
              acc
              |> Enum.map(fn
                {_id, %{position: position}} -> %{position: position}
                {id, nil} -> %{position: id * 10000}
              end)

            acc =
              if(length(just_positions) != length(Enum.dedup(just_positions))) do
                remove_crashed(acc)
              else
                acc
              end

            acc
          end
        end
      )

    l = cart_list |> Enum.filter(fn {_ind, c} -> !is_nil(c) end) |> length()

    if l == 1,
      do:
        cart_list
        |> IO.inspect()
        |> Enum.filter(fn {_ind, c} -> !is_nil(c) end)
        |> List.first(),
      else: iterate_with_removal(Map.new(cart_list), diagram)
  end

  defp remove_crashed(cart_list) do
    cart_list
    |> Enum.group_by(fn {id, cart} -> if is_nil(cart), do: id, else: cart.position end)
    # |> IO.inspect()
    |> Enum.map(fn
      {a, [{id_1, _}, {id_2, _}]} -> {a, [{id_1, nil}, {id_2, nil}]}
      b -> b
    end)
    |> Enum.flat_map(&elem(&1, 1))

    # |> IO.inspect()
  end

  defp sort_by_mapper(coord) do
    case coord do
      nil ->
        -1

      _ ->
        coord.position.y * 100_000_000 + coord.position.x
    end
  end

  defp iterate(carts, diagram) do
    # IO.inspect(carts, label: "carts")
    # print_diagram_with_carts(diagram, carts)

    iteration_result =
      carts
      |> Enum.sort_by(fn x ->
        sort_by_mapper(x)
      end)
      |> Enum.with_index()
      |> Enum.reduce_while(
        carts,
        fn {cart, ind}, acc ->
          acc = List.replace_at(acc, ind, move_cart(cart, diagram))

          # check if two carts are in the same position
          just_positions = acc |> Enum.map(fn %{position: position} -> %{position: position} end)

          if(length(just_positions) != length(Enum.dedup(just_positions))) do
            {:halt, {:done, just_positions}}
          else
            {:cont, acc}
          end
        end
      )

    case iteration_result do
      {:done, positions} -> positions
      carts -> iterate(carts, diagram)
    end
  end

  defp move_cart(nil, _diagram) do
    nil
  end

  defp move_cart(
         %{position: position, velocity: velocity, intersections_hit: intersections_hit},
         diagram
       ) do
    position = %{x: position.x + velocity.x, y: position.y + velocity.y}

    char_cart_is_over =
      diagram
      |> Enum.at(position.y)
      |> String.split("")
      |> Enum.at(position.x + 1)

    {velocity, intersections_hit} =
      case(char_cart_is_over) do
        "-" ->
          {velocity, intersections_hit}

        "|" ->
          {velocity, intersections_hit}

        "/" ->
          case velocity do
            %{x: 0, y: -1} -> {%{x: 1, y: 0}, intersections_hit}
            %{x: 0, y: 1} -> {%{x: -1, y: 0}, intersections_hit}
            %{x: 1, y: 0} -> {%{x: 0, y: -1}, intersections_hit}
            %{x: -1, y: 0} -> {%{x: 0, y: 1}, intersections_hit}
          end

        "\\" ->
          case velocity do
            %{x: 0, y: -1} -> {%{x: -1, y: 0}, intersections_hit}
            %{x: 0, y: 1} -> {%{x: 1, y: 0}, intersections_hit}
            %{x: 1, y: 0} -> {%{x: 0, y: 1}, intersections_hit}
            %{x: -1, y: 0} -> {%{x: 0, y: -1}, intersections_hit}
          end

        "+" ->
          case(rem(intersections_hit, 3)) do
            # turn left
            0 ->
              case velocity do
                %{x: 0, y: -1} -> {%{x: -1, y: 0}, intersections_hit + 1}
                %{x: 0, y: 1} -> {%{x: 1, y: 0}, intersections_hit + 1}
                %{x: 1, y: 0} -> {%{x: 0, y: -1}, intersections_hit + 1}
                %{x: -1, y: 0} -> {%{x: 0, y: 1}, intersections_hit + 1}
              end

            # go straight
            1 ->
              {velocity, intersections_hit + 1}

            # turn right
            2 ->
              case velocity do
                %{x: 0, y: -1} -> {%{x: 1, y: 0}, intersections_hit + 1}
                %{x: 0, y: 1} -> {%{x: -1, y: 0}, intersections_hit + 1}
                %{x: 1, y: 0} -> {%{x: 0, y: 1}, intersections_hit + 1}
                %{x: -1, y: 0} -> {%{x: 0, y: -1}, intersections_hit + 1}
              end
          end
      end

    %{position: position, velocity: velocity, intersections_hit: intersections_hit}
  end

  defp print_diagram_with_carts(diagram, carts) do
    IO.puts("\n")

    diagram
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      String.split(line, "", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        carts
        |> Enum.reduce_while(char, fn %{position: position, velocity: velocity}, acc ->
          if position.x == x && position.y == y do
            case velocity do
              %{x: 0, y: 1} -> {:halt, "v"}
              %{x: 0, y: -1} -> {:halt, "^"}
              %{x: -1, y: 0} -> {:halt, "<"}
              %{x: 1, y: 0} -> {:halt, ">"}
            end
          else
            {:cont, acc}
          end
        end)
      end)
    end)
    |> Enum.map(&IO.write(&1))

    IO.puts("\n")
  end

  defp diagram_without_carts(diagram) do
    diagram
    |> Enum.map(fn line ->
      line
      |> String.replace(~r/v|\^/, "|")
      |> String.replace(~r/<|>/, "-")
    end)
  end

  # 💁 assuming that no carts start on intersections or corners
  defp extract_carts_from_diagram(diagram) do
    diagram
    |> Enum.with_index()
    |> Enum.map(fn
      {line, line_number} ->
        case(Regex.scan(~r/[v^><]/, line, return: :index)) do
          [] ->
            nil

          matches ->
            matches
            |> Enum.flat_map(fn x -> x end)
            |> Enum.map(fn {byte_index, _match_length} ->
              cart_character = String.at(line, byte_index)

              cart_velocity =
                case cart_character do
                  # {byte_index, _match_length}
                  "v" ->
                    %{x: 0, y: 1}

                  "^" ->
                    %{x: 0, y: -1}

                  ">" ->
                    %{x: 1, y: 0}

                  "<" ->
                    %{x: -1, y: 0}
                end

              x = byte_index
              y = line_number

              %{position: %{x: x, y: y}, velocity: cart_velocity, intersections_hit: 0}
            end)
        end
    end)
    |> Enum.filter(fn x -> !is_nil(x) end)
    |> Enum.flat_map(fn x -> x end)
  end
end
