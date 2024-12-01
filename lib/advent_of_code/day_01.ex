defmodule AdventOfCode.Day01 do
  def part1(input) do
    result =
      get_and_parse_input(input)
      |> Tuple.to_list()
      |> Enum.map(&Enum.sort/1)
      |> Enum.zip_reduce(0, fn [first, second], acc ->
        acc + abs(first - second)
      end)

    result
  end

  def part2(input) do
    {first, second} = get_and_parse_input(input)

    frequencies_of_second = Enum.frequencies(second)

    result =
      first
      |> Enum.reduce(0, fn value, acc ->
        frequency_of_value = Map.get(frequencies_of_second, value, 0)
        acc + frequency_of_value * value
      end)

    result
  end

  defp get_and_parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn value ->
      [first, second] =
        String.split(value, "   ")
        |> Enum.map(&String.to_integer/1)

      {first, second}
    end)
    |> Enum.unzip()
  end
end
