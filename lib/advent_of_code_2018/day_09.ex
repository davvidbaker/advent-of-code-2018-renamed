defmodule AdventOfCode2018.Day09 do
  def part1(num_players, last_marble_value) do
    scorecard = Map.new(1..num_players, fn x -> {x, 0} end)
    initial_circle = [0]
    remaining_marbles = 1..last_marble_value |> Enum.to_list()

    results = play_game(scorecard, remaining_marbles, 0, initial_circle, 1, 1)

    IO.inspect(results, label: "results")

    results |> Map.values() |> Enum.max()
  end

  def part2(args) do
  end

  defp play_game(scorecard, [], _current_marble, _circle, _player, _circle_size) do
    scorecard
  end

  defp play_game(scorecard, remaining_marbles, current_marble, circle, player, circle_size) do
    # remaining_marbles will always be in order

    {circle, current_marble, round_score, remaining_marbles, circle_size} =
      place_marble(circle, current_marble, remaining_marbles, circle_size)

    scorecard = Map.update!(scorecard, player, &(&1 + round_score))

    player = if player + 1 > map_size(scorecard), do: 1, else: player + 1

    play_game(scorecard, remaining_marbles, current_marble, circle, player, circle_size)
  end

  # ⚠️ slow!
  defp place_marble(circle, current_marble, remaining_marbles, circle_size) do
    [marble_to_be_placed | remaining_marbles] = remaining_marbles

    current_marble_index = Enum.find_index(circle, fn marble -> marble == current_marble end)

    case rem(marble_to_be_placed, 23) do
      0 ->
        # negative indices work just fine
        {removed_marble, new_circle} = List.pop_at(circle, current_marble_index - 7)
        current_marble = Enum.at(circle, current_marble_index - 6)

        score_for_round = marble_to_be_placed + removed_marble

        # remaining_marbles = Enum.sort([remaining_marbles])
        {new_circle, current_marble, score_for_round, remaining_marbles, circle_size - 1}

      _ ->
        split_at_index = current_marble_index + 2

        split_at_index =
          if(split_at_index >= circle_size) do
            rem(split_at_index, circle_size)
          else
            split_at_index
          end

        circle = List.insert_at(circle, split_at_index, marble_to_be_placed)

        current_marble = marble_to_be_placed

        {circle, current_marble, 0, remaining_marbles, circle_size + 1}
    end
  end
end
