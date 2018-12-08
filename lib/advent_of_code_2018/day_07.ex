defmodule AdventOfCode2018.Day07 do
  def part1(file_stream) do
    {instructions, instruction_prereq_map} = file_stream |> set_up()

    ordered_instructions =
      order_instructions(
        instructions,
        instruction_prereq_map,
        []
      )
      |> Enum.reverse()
      |> Enum.join()
  end

  def part2(file_stream, num_workers, extra_time_per_step) do
    {instructions, instruction_prereq_map} = file_stream |> set_up()

    instruction_time_map =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      |> String.split("", trim: true)
      |> Enum.with_index(1 + extra_time_per_step)
      |> Map.new(fn {instr, index} -> {instr, index} end)

    build_sleigh(
      instruction_time_map,
      instructions,
      instruction_prereq_map,
      [],
      num_workers,
      [],
      0
    )
  end

  defp build_sleigh(
         instruction_time_map,
         remaining_instructions,
         instruction_prereq_map,
         ordered_instructions,
         num_workers,
         occupied_workers,
         seconds_elapsed
       ) do
    available_workers =
      case num_workers - length(occupied_workers) do
        0 -> []
        num_available_workers -> 1..num_available_workers
      end

    instructions_ready_for_work = ready_for_work(instruction_prereq_map)

    new_workers_working =
      Enum.zip(available_workers, instructions_ready_for_work)
      |> Enum.map(fn {_worker_id, instruction} ->
        {instruction, Map.get(instruction_time_map, instruction)}
      end)

    workers_working =
      new_workers_working |> Enum.reduce(occupied_workers, fn w, acc -> [w | acc] end)

    updated_instruction_prereq_map = update_prereq_map(instruction_prereq_map, workers_working)

    # 💁 iterate
    {next_remaining_instructions, next_instruction_prereq_map, next_workers_working,
     next_ordered_instructions,
     next_seconds_elapsed} =
      iterate(
        remaining_instructions,
        updated_instruction_prereq_map,
        workers_working,
        ordered_instructions,
        seconds_elapsed
      )

    case length(next_remaining_instructions) do
      0 ->
        next_seconds_elapsed

      _ ->
        build_sleigh(
          instruction_time_map,
          next_remaining_instructions,
          next_instruction_prereq_map,
          next_ordered_instructions,
          num_workers,
          next_workers_working,
          next_seconds_elapsed
        )
    end
  end

  defp iterate(
         remaining_instructions,
         prereq_map,
         workers_working,
         ordered_instructions,
         seconds_elapsed
       ) do
    {just_completed_instructions, next_workers_working} =
      workers_working
      |> Enum.map(fn {instruction, seconds_remaining} ->
        {instruction, seconds_remaining - 1}
      end)
      |> Enum.reduce({[], []}, fn {instruction, seconds_remaining},
                                  {acc_instructions, acc_workers} ->
        if seconds_remaining <= 0,
          do: {[instruction | acc_instructions], acc_workers},
          else: {acc_instructions, [{instruction, seconds_remaining} | acc_workers]}
      end)

    next_remaining_instructions = remaining_instructions -- just_completed_instructions
    next_ordered_instructions = just_completed_instructions ++ ordered_instructions

    next_prereq_map =
      prereq_map
      |> Map.to_list()
      |> Enum.map(fn {instr, prereqs} -> {instr, prereqs -- next_ordered_instructions} end)
      |> Map.new()

    {next_remaining_instructions, next_prereq_map, next_workers_working,
     next_ordered_instructions, seconds_elapsed + 1}
  end

  defp update_prereq_map(prereq_map, workers_working) do
    working_on = workers_working |> Enum.map(&elem(&1, 0))

    prereq_map
    |> Map.to_list()
    |> Enum.filter(fn {instruction, _prereq} ->
      !(instruction in working_on)
    end)
    |> Map.new()
  end

  defp ready_for_work(instruction_prereq_map) do
    instruction_prereq_map
    |> Map.to_list()
    |> Enum.filter(fn {_instruction, prereqs} -> Enum.empty?(prereqs) end)
    |> Enum.map(&elem(&1, 0))
  end

  defp order_instructions(remaining_instructions, instruction_prereq_map, ordered_instructions) do
    instruction_prereq_map
    |> Map.to_list()
    |> Enum.reduce_while(ordered_instructions, fn {instr, prereqs}, acc ->
      case prereqs -- acc do
        [] ->
          {:halt,
           order_instructions(
             remaining_instructions -- [instr],
             Map.drop(instruction_prereq_map, [instr]),
             [
               instr | acc
             ]
           )}

        _ ->
          {:cont, acc}
      end
    end)
  end

  defp set_up(file_stream) do
    parsed_instructions = file_stream |> Enum.map(&parse_line(&1))

    instructions =
      parsed_instructions
      |> Enum.flat_map(&Tuple.to_list(&1))
      |> Enum.uniq()
      |> Enum.sort()

    initial_map = Map.new(instructions, fn instr -> {instr, []} end)

    instruction_prereq_map =
      parsed_instructions
      |> Enum.reduce(initial_map, fn {prereq, instruction}, acc ->
        Map.update(acc, instruction, [prereq], &[prereq | &1])
      end)

    {instructions, instruction_prereq_map}
  end

  defp parse_line(line) do
    [_match, prereq, instruction] = Regex.run(~r/Step\s(\w).*step\s(\w)/, line)

    {prereq, instruction}
  end
end
