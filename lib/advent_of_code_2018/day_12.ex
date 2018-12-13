defmodule AdventOfCode2018.Day12 do
  def part1(file_stream) do
    {state, patterns} = parse(file_stream)

    final_state =
      1..20
      |> Enum.reduce(state, fn _, state ->
        iterate(state, patterns)
      end)

    final_state.list
    |> Enum.with_index(final_state.leftmost_index)
    |> Enum.filter(fn {pot, index} ->
      pot
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  # 💁 looking at results to this, withouth going all the way to 50_000_000_000, you can see that things
  # reach a steady state at generation 101, at which point it has a score of 724,
  # and from then on the score goes up by 5 on every iteration. So some math:
  #
  #   iex> 50_000_000_000 - 101
  #   49999999899
  #
  #   iex> 49999999899 * 5
  #   249999999495
  #
  # 249999999495 + 724
  # 😃 250000000219 😃

  def part2(file_stream) do
    {state, patterns} = parse(file_stream)

    final_state =
      1..500
      |> Enum.reduce(state, fn iteration, state ->
        if rem(iteration, 1) == 0 do
          # IO.inspect(iteration, label: "iteration")
          IO.inspect(score(state), label: "score(state)")
          IO.puts(iteration)
        end

        iterate(state, patterns)
      end)

    score(final_state)
  end

  defp score(state) do
    state.list
    |> Enum.with_index(state.leftmost_index)
    |> Enum.filter(fn {pot, index} ->
      pot
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  defp iterate(%{leftmost_index: leftmost_index, list: list} = state, patterns) do
    list = pad(list)
    {first_four, rest} = Enum.split(list, 4)

    {list, old_list} =
      rest
      |> Enum.reduce({[], Enum.reverse(first_four)}, fn right_pot, {acc_new, acc_old} ->
        acc_old = [right_pot | acc_old]

        match_on = Enum.take(acc_old, 5) |> Enum.reverse()

        produces_plant =
          patterns
          |> Enum.reduce_while(false, fn pattern, produces_plant ->
            if elem(pattern, 0) == match_on do
              {:halt, elem(pattern, 1)}
            else
              {:cont, produces_plant}
            end
          end)

        {[produces_plant | acc_new], acc_old}
      end)

    {cutoff_tail, list} = Enum.split(list, Enum.find_index(list, fn x -> x == true end))

    list = Enum.reverse(list)

    first_index_with_pot = Enum.find_index(list, fn x -> x == true end)

    {cut_off, list} = Enum.split(list, first_index_with_pot)

    IO.inspect(leftmost_index, label: "leftmost_index")
    log(list)
    %{leftmost_index: leftmost_index - 2 + first_index_with_pot, list: list}
  end

  defp pad(list) do
    [false, false, false, false] ++ list ++ [false, false, false, false]
  end

  defp log(list) do
    IO.puts(
      Enum.map_join(list, "", fn x ->
        case x do
          true -> "#"
          false -> "."
        end
      end)
    )
  end

  defp parse(file_stream) do
    [first_line | rest] = Enum.to_list(file_stream)

    [match] = Regex.run(~r/[#.]+/, first_line)

    # state shape
    # {left_most_pot_index, [...pot_list...]}
    state = %{leftmost_index: 0, list: to_true_false(match)}

    patterns =
      rest
      |> Enum.map(fn line ->
        IO.inspect(line, label: "line")

        case Regex.run(~r/([#.]+)\s=>\s([#.])/, line) do
          [match, pattern, outcome] -> {to_true_false(pattern), true_false_char(outcome)}
          _ -> nil
        end
      end)
      |> Enum.reject(&is_nil(&1))

    {state, patterns}
  end

  defp to_true_false(str) do
    str
    |> String.split("", trim: true)
    |> Enum.map(fn x ->
      true_false_char(x)
    end)
  end

  defp true_false_char(x) do
    case x do
      "#" -> true
      "." -> false
    end
  end
end
