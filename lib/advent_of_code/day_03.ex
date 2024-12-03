defmodule AdventOfCode.Day03 do
  @regex_part1 ~r/mul\(\d{1,3},\d{1,3}\)/
  @regex_part2 ~r/mul\(\d{1,3},\d{1,3}\)|do\(\)|don\'t\(\)/

  def part1(input) do
    Regex.scan(@regex_part1, input)
    |> List.flatten()
    |> Enum.map(fn instruction ->
      [n1, n2] = parse_mul_instruction(instruction)

      n1 * n2
    end)
    |> Enum.sum()
  end

  def part2(input) do
    Regex.scan(@regex_part2, input)
    |> List.flatten()
    |> Enum.reduce({0, :process}, fn x, {acc, mode} ->
      case {x, mode} do
        {"do()", _} ->
          {acc, :process}

        {"don't()", _} ->
          {acc, :skip}

        {instruction, :process} ->
          [n1, n2] = parse_mul_instruction(instruction)

          {acc + n1 * n2, :process}

        {_, _} ->
          {acc, :skip}
      end
    end)
    |> elem(0)
  end

  defp parse_mul_instruction(instruction) do
    instruction
    |> String.replace("mul(", "")
    |> String.replace(")", "")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
