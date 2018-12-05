defmodule Mix.Tasks.Day5Part1 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day5Part1.apply(["dabAcCaCBAcCcaDA"])
      10

  """

  @impl Aoc2018
  def day, do: "5"

  @impl Aoc2018
  def apply([line]) do
    String.graphemes(line)
    |> Enum.reduce([], fn
      c, [] -> [c]
      c, [h | t] -> if chars_match(c, h), do: t, else: [c | [h | t]]
    end)
    |> length
  end

  def chars_match(a, b), do: a != b && String.upcase(a) == String.upcase(b)
end
