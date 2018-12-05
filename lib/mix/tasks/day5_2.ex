defmodule Mix.Tasks.Day5Part2 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day5Part2.apply(["dabAcCaCBAcCcaDA"])
      4

  """

  @impl Aoc2018
  def day, do: "5"

  @impl Aoc2018
  def apply([line]) do
    chars = String.graphemes(line)
    polymers = chars |> Enum.map(&String.upcase/1) |> Enum.uniq()

    polymers
    |> Enum.min_by(fn p ->
      reduce_ignoring_polymer(p, chars)
      |> length
    end)
    |> reduce_ignoring_polymer(chars)
    |> length
  end

  def reduce_ignoring_polymer(p, chars) do
    chars
    |> Enum.reject(&(String.upcase(&1) == p))
    |> Enum.reduce([], fn
      c, [] -> [c]
      c, [h | t] = acc -> if chars_match(c, h), do: t, else: [c | acc]
    end)
  end

  def chars_match(a, b), do: a != b && String.upcase(a) == String.upcase(b)
end
