defmodule AdventOfCode.Day02 do
  def part1(input) do
    parse_input(input)
    |> Enum.count(&safe?/1)
  end

  def part2(input) do
    parse_input(input)
    |> Enum.count(&dampener?/1)
  end

  defp dampener?(levels) do
    case safe?(levels) do
      true ->
        true

      false ->
        Enum.any?(
          0..(length(levels) - 1),
          fn dampen ->
            value = List.delete_at(levels, dampen)
            safe?(value)
          end
        )
    end
  end

  defp safe?(value) do
    diffs =
      Enum.chunk_every(value, 2, 1, :discard)
      |> Enum.map(fn [first, second] ->
        first - second
      end)

    levels_increasing_or_decresing?(diffs) && Enum.all?(diffs, &safe_diff?(&1))
  end

  defp levels_increasing_or_decresing?(value) do
    is_only_increasing = Enum.all?(value, fn number -> number >= 0 end)
    is_only_decreasing = Enum.all?(value, fn number -> number <= 0 end)

    is_only_increasing or is_only_decreasing
  end

  defp safe_diff?(level) do
    abs(level) >= 1 && abs(level) <= 3
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn value ->
      value
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
