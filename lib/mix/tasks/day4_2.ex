defmodule Mix.Tasks.Day4Part2 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task
  use Timex

  alias Mix.Tasks.Day4Part1.GuardRecord, as: GuardRecord

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day4Part2.apply([
      ...>"[1518-11-01 00:00] Guard #10 begins shift",
      ...>"[1518-11-01 00:05] falls asleep",
      ...>"[1518-11-01 00:25] wakes up",
      ...>"[1518-11-01 00:30] falls asleep",
      ...>"[1518-11-02 00:40] falls asleep",
      ...>"[1518-11-04 00:36] falls asleep",
      ...>"[1518-11-02 00:50] wakes up",
      ...>"[1518-11-03 00:05] Guard #10 begins shift",
      ...>"[1518-11-01 23:58] Guard #99 begins shift",
      ...>"[1518-11-03 00:24] falls asleep",
      ...>"[1518-11-01 00:55] wakes up",
      ...>"[1518-11-03 00:29] wakes up",
      ...>"[1518-11-04 00:02] Guard #99 begins shift",
      ...>"[1518-11-04 00:46] wakes up",
      ...>"[1518-11-05 00:03] Guard #99 begins shift",
      ...>"[1518-11-05 00:45] falls asleep",
      ...>"[1518-11-05 00:55] wakes up"])
      4455

  """

  @impl Aoc2018
  def day, do: "4"

  @impl Aoc2018
  def apply(lines) do
    [fst | rst] =
      lines
      |> Enum.map(&GuardRecord.parse_log/1)
      |> Enum.sort_by(&Map.get(&1, :date_time), fn l, r ->
        case Timex.compare(l, r) do
          -1 -> true
          _ -> false
        end
      end)

    case Enum.chunk_while(
           rst,
           [fst],
           fn %{guard_id: guard_id} = record, acc ->
             case guard_id do
               nil -> {:cont, [record | acc]}
               _ -> {:cont, Enum.reverse(acc), [record]}
             end
           end,
           fn
             [] -> {:cont, []}
             acc -> {:cont, Enum.reverse(acc), []}
           end
         )
         |> Enum.map(&GuardRecord.parse_lines/1)
         |> Enum.group_by(fn %{id: id} -> id end)
         |> Enum.map(&aggregate_sleep_times/1)
         |> Enum.max_by(&elem(&1, 2)) do
      {id, x, _} -> id * x
    end
  end

  def total_sleep_time({_, records}) do
    records
    |> Enum.flat_map(&Map.get(&1, :activities))
    |> Enum.filter(fn
      %{activity: :asleep} -> true
      _ -> false
    end)
    |> Enum.map(&Interval.duration(Map.get(&1, :range), :minutes))
    |> Enum.sum()
  end

  def aggregate_sleep_times({id, records}) do
    case records
         |> Enum.flat_map(&Map.get(&1, :activities))
         |> Enum.filter(fn
           %{activity: :asleep} -> true
           _ -> false
         end)
         |> Enum.flat_map(fn %{range: range} ->
           Enum.to_list(range)
         end)
         |> Enum.map(&Map.get(&1, :minute))
         |> Mix.Tasks.Day2Part1.frequency()
         |> Enum.max_by(fn {_, v} -> v end, fn -> {0, 0} end) do
      {time, v} -> {id, time, v}
    end
  end
end
