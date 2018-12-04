defmodule Mix.Tasks.Day2Part1 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day2Part1.apply(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"])
      12

  """

  @impl Aoc2018
  def day, do: "2"

  @impl Aoc2018
  def apply(lines) do
    lines
    |> Enum.map(&String.trim/1)
    |> Enum.map(
         fn x ->
           String.graphemes(x)
           |> frequency
           |> Enum.reduce(
                %{},
                fn {_, cnt}, acc ->
                  Map.update(acc, cnt, 1, &(&1 + 1))
                end
              )
           |> Map.take([2, 3])
         end
       )
    |> Enum.flat_map(&Map.keys/1)
    |> frequency
    |> Map.values
    |> Enum.reduce(&(&1 * &2))
  end

  def frequency(map) do
    Enum.reduce(map, %{}, fn c, acc -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end
end
