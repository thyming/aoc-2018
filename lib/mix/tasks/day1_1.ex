defmodule Mix.Tasks.Day1Part1 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task


  @impl Aoc2018
  def apply(lines) do
    lines
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
    |> Integer.to_string
  end
end