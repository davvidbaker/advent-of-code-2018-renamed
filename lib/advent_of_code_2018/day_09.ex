defmodule AdventOfCode2018.Day09 do
  alias __MODULE__.CircularList

  def part1(num_players, last_marble_value) do
    scorecard = Map.new(1..num_players, fn x -> {x, 0} end)
    initial_circle = CircularList.new([0])
    remaining_marbles = 1..last_marble_value |> Enum.to_list()

    results = play_game(scorecard, remaining_marbles, initial_circle, 1)

    IO.inspect(results, label: "results")

    results |> Map.values() |> Enum.max()
  end

  def part2(num_players, last_marble_value) do
    part1(num_players, last_marble_value * 100)
  end

  defp play_game(scorecard, [], _circle, _player) do
    scorecard
  end

  defp play_game(scorecard, remaining_marbles, circle, player) do
    # remaining_marbles will always be in order

    {circle, round_score, remaining_marbles} = place_marble(circle, remaining_marbles)

    scorecard = Map.update!(scorecard, player, &(&1 + round_score))

    player = rem(player, map_size(scorecard)) + 1

    play_game(scorecard, remaining_marbles, circle, player)
  end

  # ⚠️ slow!
  defp place_marble(circle, remaining_marbles) do
    [marble_to_be_placed | remaining_marbles] = remaining_marbles

    # current_marble_index = Enum.find_index(circle, fn marble -> marble == current_marble end)
    case rem(marble_to_be_placed, 23) do
      0 ->
        circle = 1..7 |> Enum.reduce(circle, fn _, acc -> CircularList.previous(acc) end)

        {removed_marble, circle} = CircularList.pop(circle)

        score_for_round = marble_to_be_placed + removed_marble

        {circle, score_for_round, remaining_marbles}

      _ ->
        circle =
          circle
          |> CircularList.next()
          |> CircularList.next()
          |> CircularList.insert(marble_to_be_placed)

        {circle, 0, remaining_marbles}
    end
  end

  # borrowed idea to use zipper from https://github.com/sasa1977/aoc/blob/master/lib/2018/day9.ex
  defmodule CircularList do
    def new(elements), do: {elements, []}

    def next({[], previous}), do: next({Enum.reverse(previous), []})
    def next({[current | rest], previous}), do: {rest, [current | previous]}

    def previous({next, []}), do: previous({[], Enum.reverse(next)})
    def previous({next, [last | rest]}), do: {[last | next], rest}

    def insert({next, previous}, element), do: {[element | next], previous}

    def pop({[], previous}), do: pop({Enum.reverse(previous), []})
    def pop({[current | rest], previous}), do: {current, {rest, previous}}
  end
end
