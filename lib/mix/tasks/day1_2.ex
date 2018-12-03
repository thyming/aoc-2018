defmodule Mix.Tasks.Day1Part2 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day1Part2.apply(["+3", "+3", "+4", "-2", "-4"])
      10

  """

  @impl Aoc2018
  def apply(lines) do
    lines
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Stream.cycle
    |> Enum.reduce_while(
         {MapSet.new(), 0},
         fn el, {seen, acc} ->
           new_freq = acc + el
           if MapSet.member?(seen, new_freq) do
             {:halt, new_freq}
           else
             {:cont, {MapSet.put(seen, new_freq), new_freq}}
           end
         end
       )
  end
end