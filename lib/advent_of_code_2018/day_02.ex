defmodule AdventOfCode2018.Day02 do
  def part1(file_stream) do
    file_stream
    |> letter_arrays()
    |> Stream.map(&points_for_word(&1))
    |> Enum.reduce([0, 0], fn [d, t], [num_doubles, num_triples] ->
      [num_doubles + d, num_triples + t]
    end)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  def part2(file_stream) do
    words = file_stream |> Enum.map(&String.trim(&1))

    words
    |> Enum.map(fn word ->
      words
      |> Enum.reduce({nil, nil, 0}, fn w, {word_1, word_2, max_score} ->
        jd = String.jaro_distance(w, word)

        if jd > max_score && jd < 1.00, do: {w, word, jd}, else: {word_1, word_2, max_score}
      end)
    end)
    |> Enum.max_by(fn {_w1, _w2, score} -> score end)
    |> common_letters()
  end

  defp common_letters({word_1, word_2, _score}) do
    word_2 = String.split(word_2, "", trim: true)

    word_1
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {letter, index} ->
      case Enum.at(word_2, index) do
        ^letter -> letter
        _ -> nil
      end
    end)
    |> Enum.join()
  end

  defp letter_arrays(file_stream) do
    file_stream
    |> Stream.map(fn word ->
      word
      |> String.trim()
      |> String.split("", trim: true)
    end)
  end

  defp points_for_word(letter_arr) do
    letter_arr
    |> Enum.reduce_while({nil, nil}, fn letter, {double_letter, triple_letter} ->
      if !is_nil(double_letter) && !is_nil(triple_letter) do
        {:halt, {double_letter, triple_letter}}
      else
        letter_arr
        |> Enum.filter(fn x -> x == letter end)
        |> (fn filtered ->
              case length(filtered) do
                2 -> {:cont, {letter, triple_letter}}
                3 -> {:cont, {double_letter, letter}}
                _ -> {:cont, {double_letter, triple_letter}}
              end
            end).()
      end
    end)
    |> Tuple.to_list()
    |> Enum.map(fn x ->
      case x do
        nil ->
          0

        _ ->
          1
      end
    end)
  end
end
