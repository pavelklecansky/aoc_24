defmodule AdventOfCode.Day05 do
  def part1(input) do
    [ordering_rules_map, updates] = parse_input(input)

    updates
    |> Enum.filter(&correct_update?(&1, ordering_rules_map))
    |> Enum.map(fn update ->
      middle_index = update |> length() |> div(2)
      Enum.at(update, middle_index)
    end)
    |> Enum.sum()
  end

  defp correct_update?(update, ordering_rules_map) do
    Enum.all?(evaluate_update(update, ordering_rules_map), & &1)
  end

  defp evaluate_update([], _), do: []

  defp evaluate_update([head | tail], ordering_rules_map) do
    rules = Map.get(ordering_rules_map, head, [])
    [Enum.all?(tail, fn x -> x in rules end) | evaluate_update(tail, ordering_rules_map)]
  end

  def part2(input) do
    [ordering_rules_map, updates] = parse_input(input)

    updates
    |> Enum.filter(&uncorrect_update?(&1, ordering_rules_map))
    |> Enum.map(&fix_uncorrect_update(&1, ordering_rules_map))
    |> Enum.map(fn update ->
      middle_index = update |> length() |> div(2)
      Enum.at(update, middle_index)
    end)
    |> Enum.sum()
  end

  defp uncorrect_update?(update, ordering_rules_map) do
    not correct_update?(update, ordering_rules_map)
  end

  defp fix_uncorrect_update(update, ordering_rules_map) do
    update
    |> Enum.reduce([], fn element, acc -> insert_element(acc, element, ordering_rules_map) end)
  end

  defp insert_element(acc, element, rules) do
    dependencies = Map.get(rules, element, [])

    {before_list, after_list} =
      Enum.split_with(acc, fn x -> not Enum.member?(dependencies, x) end)

    before_list ++ [element] ++ after_list
  end

  defp parse_input(input) do
    [ordering_rules, updates] =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    ordering_rules =
      ordering_rules
      |> Enum.reduce(%{}, fn rule, map ->
        [first, second] =
          String.split(rule, "|", trim: true)
          |> Enum.map(&String.to_integer/1)

        Map.update(map, first, [second], fn existing ->
          [second | existing]
        end)
      end)

    updates =
      updates
      |> Enum.map(fn update ->
        update
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    [ordering_rules, updates]
  end
end
