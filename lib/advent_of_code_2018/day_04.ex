defmodule AdventOfCode2018.Day04 do
  def part1(file_stream) do
    lines =
      file_stream
      # 💁 shuffling because the input order in the actual input is not
      # chronological, although the test input is
      |> Enum.shuffle()
      |> Enum.map(&parse_line(&1))
      # well this through me for a loop for a while
      |> Enum.sort_by(fn {date, _, _} ->
        {date.year, date.month, date.day, date.hour, date.minute}
      end)
      |> add_id_to_entries()
      |> map_entries_to_guard_minute_maps()
      |> select_guard_with_most_total_minutes()
      |> compute_guard_score()
  end

  def part2(file_stream) do
    file_stream
    # 💁 shuffling because the input order in the actual input is not
    # chronological, although the test input is
    |> Enum.shuffle()
    |> Enum.map(&parse_line(&1))
    # well this through me for a loop for a while
    |> Enum.sort_by(fn {date, _, _} ->
      {date.year, date.month, date.day, date.hour, date.minute}
    end)
    |> add_id_to_entries()
    |> map_entries_to_guard_minute_maps()
    |> select_guard_with_highest_single_minute()
    |> compute_guard_score()
  end

  defp compute_guard_score({id, minute_map, minutes_asleep}) do
    id = String.to_integer(id)

    {max_minute, _times_asleep} =
      minute_map
      |> Map.to_list()
      |> Enum.sort_by(fn {a, _b} -> a end)
      |> Enum.reduce({0, 0}, fn {minute, times_asleep}, {_max_minute, max_times_asleep} = acc ->
        if times_asleep >= max_times_asleep do
          {minute, times_asleep}
        else
          acc
        end
      end)

    id * max_minute
  end

  defp select_guard_with_highest_single_minute(guard_minute_maps) do
    guard_minute_maps
    |> Map.to_list()
    |> Enum.reduce({nil, nil, 0}, fn {id, minute_map},
                                     {_max_id, _max_minute_map, max_sleepiest_minute} = acc ->
      sleepiest_minute = Enum.max(Map.values(minute_map))

      if sleepiest_minute > max_sleepiest_minute do
        {id, minute_map, sleepiest_minute}
      else
        acc
      end
    end)
  end

  defp select_guard_with_most_total_minutes(guard_minute_maps) do
    guard_minute_maps
    |> Map.to_list()
    |> Enum.reduce({nil, nil, 0}, fn {id, minute_map},
                                     {_max_id, _max_minute_map, max_minutes_asleep} = acc ->
      total_minutes_asleep = Enum.sum(Map.values(minute_map))

      if total_minutes_asleep > max_minutes_asleep do
        {id, minute_map, total_minutes_asleep}
      else
        acc
      end
    end)
  end

  defp map_entries_to_guard_minute_maps(entries) do
    {acc_map, _last_id, _last_minute, _last_action} =
      Enum.reduce(entries, {%{}, nil, nil, nil}, fn {date, id, action},
                                                    {acc_map, last_id, last_minute, last_action} ->
        acc_map =
          if last_id !== id && last_action == :fall do
            Map.update(acc_map, last_id, new_minute_map(), fn x ->
              update_guard_minute_map(x, last_minute, 60)
            end)
          else
            Map.update(acc_map, id, new_minute_map(), fn x ->
              if(last_id == id && last_action == :fall && action == :wake) do
                if date.minute < last_minute, do: raise({:error, date.minute, last_minute})
                update_guard_minute_map(x, last_minute, date.minute)
              else
                x
              end
            end)
          end

        {acc_map, id, date.minute, action}
      end)

    acc_map
  end

  defp update_guard_minute_map(minute_map, from_minute, to_minute) do
    from_minute..(to_minute - 1)
    |> Enum.reduce(minute_map, fn minute, acc ->
      Map.update(acc, minute, 0, fn minute_total ->
        minute_total + 1
      end)
    end)
  end

  defp new_minute_map do
    0..59
    |> Enum.reduce(%{}, fn minute, acc -> Map.put(acc, minute, 0) end)
  end

  defp add_id_to_entries(entries) do
    entries
    |> Enum.scan(fn {date, id, action}, {_last_date, last_id, _action} ->
      id = if is_nil(id), do: last_id, else: id
      {date, id, action}
    end)
  end

  defp parse_line(str) do
    {date_str, id, action} =
      case Regex.run(~r/\[(.*)\](\sGuard\s#)?(\d+)?(.*)/, str) do
        [_match, date_str, _guard, "", rest] ->
          action = if String.contains?(rest, "falls"), do: :fall, else: :wake
          {date_str, nil, action}

        [_match, date_str, _guard, id, rest] ->
          {date_str, id, :begin}
      end

    {:ok, date} = NaiveDateTime.from_iso8601(date_str <> ":00")
    {date, id, action}
  end
end
