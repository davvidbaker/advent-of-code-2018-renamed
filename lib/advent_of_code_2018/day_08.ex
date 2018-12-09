defmodule Day8Node do
  defstruct(meta: [], children: [])
end

defmodule AdventOfCode2018.Day08 do
  def part1(file_stream) do
    integer_list = parse(file_stream)
    {root_node, _tail} = build_tree(integer_list)

    sum_all_meta(root_node, 0)
  end

  def part2(file_stream) do
    integer_list = parse(file_stream)
    {root_node, _tail} = build_tree(integer_list)

    compute_value_of_node(root_node)
  end

  defp compute_value_of_node(node) do
    case node.children do
      [] ->
        Enum.sum(node.meta)

      children ->
        node.meta
        |> Enum.map(fn child_index ->
          Enum.at(children, child_index - 1, %Day8Node{children: [], meta: [0]})
          |> compute_value_of_node
        end)
        |> Enum.sum()
    end
  end

  defp sum_all_meta(node, total) do
    Enum.sum(node.meta) +
      (node.children |> Enum.reduce(total, fn child, acc -> sum_all_meta(child, acc) end))
  end

  defp build_tree(integer_list) do
    {[num_child_nodes, num_meta], tail} = Enum.split(integer_list, 2)

    {children, tail} =
      List.duplicate(nil, num_child_nodes)
      |> Enum.reduce({[], tail}, fn _x, {acc_children, acc_tail} ->
        {child_node, new_tail} = build_tree(acc_tail)
        {[child_node | acc_children], new_tail}
      end)

    {meta, tail} = Enum.split(tail, num_meta)
    node = %Day8Node{children: Enum.reverse(children), meta: meta}

    {node, tail}
  end

  defp parse(file_stream) do
    file_stream
    |> Enum.join()
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end
end
