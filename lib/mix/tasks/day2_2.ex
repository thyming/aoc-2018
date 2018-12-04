defmodule Mix.Tasks.Day2Part2 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day2Part2.apply(["abcde","fghij","klmno","pqrst","fguij","axcye","wvxyz"])
      "fgij"

  """

  @impl Aoc2018
  def day, do: "2"

  @impl Aoc2018
  def apply(lines) do
    passes = lines
             |> Enum.at(0)
             |> String.length

    Range.new(0, passes)
    |> Enum.map(&(check(&1, lines)))
    |> Enum.reduce_while(
         "",
         fn
           {nil, _}, acc -> {:cont, acc}
           {x, _}, _ -> {:halt, x}
         end
       )
  end

  def check(col, lines) do
    f = filter_at(col)
    Enum.reduce_while(
      lines,
      {nil, MapSet.new()},
      fn line, {_, seen} ->
        s = f.(line)
        if MapSet.member?(seen, s) do
          {:halt, {s, nil}}
        else
          {:cont, {nil, MapSet.put(seen, s)}}
        end
      end
    )
  end

  def filter_at(i) do
    fn s1 ->
      Enum.zip(
        0..String.length(s1),
        String.graphemes(s1)
      )
      |> Enum.reject(fn {ix, _} -> ix == i end)
      |> Enum.map(fn {_, el} -> el end)
      |> Enum.join
    end
  end
end
