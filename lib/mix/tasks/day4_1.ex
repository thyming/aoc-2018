defmodule Mix.Tasks.Day4Part1 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task
  use Timex

  defmodule GuardRecord do
    @type activity :: :begin_shift | :wake_up | :fall_asleep
    defstruct [:id, :activities]

    @date_time_format "{YYYY}-{0M}-{0D} {h24}:{m}"
    @time_format "{h24}:{m}"
    @record_regex ~r/\[(.{11}(\d{2}:\d{2}))\] (Guard #(\d+) )?(.*)/

    def parse_log(line) do
      [_, start_date_time_string, start_time_string, _, id, msg] = Regex.run(@record_regex, line)
      start_time = Timex.parse!(start_time_string, @time_format)

      start_time =
        if Timex.after?(
             start_time,
             Timex.shift(Timex.to_naive_datetime(Timex.zero()), hours: 1)
           ),
           do: Timex.to_naive_datetime(Timex.zero()),
           else: start_time

      start_date_time = Timex.parse!(start_date_time_string, @date_time_format)

      id =
        case id do
          "" -> nil
          _ -> String.to_integer(id)
        end

      activity =
        case msg do
          "falls asleep" -> :asleep
          "begins shift" -> :awake
          "wakes up" -> :awake
        end

      %{
        guard_id: id,
        time: start_time,
        date_time: start_date_time,
        activity: activity
      }
    end

    def parse_lines([%{guard_id: guard_id} | _] = lines) do
      activities =
        lines
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reject(fn [%{time: start_time}, %{time: end_time}] -> start_time == end_time end)
        |> Enum.map(fn [
                         %{time: start_time, activity: activity},
                         %{time: end_time}
                       ] ->
          time_range =
            case Interval.new(
                   from: start_time,
                   until: end_time,
                   step: [
                     minutes: 1
                   ]
                 ) do
              {:error, :invalid_until} ->
                raise "Invalid until: #{inspect(end_time)} (from: #{inspect(start_time)}, id: #{
                        inspect(guard_id)
                      }, lines: #{inspect(lines)})"

              interval ->
                interval
            end

          %{activity: activity, range: time_range}
        end)

      %GuardRecord{
        id: guard_id,
        activities: activities
      }
    end
  end

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day4Part1.apply([
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
      240

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
         |> Enum.max_by(&total_sleep_time/1)
         |> aggregate_sleep_times do
      {id, time} -> id * time
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
         |> Enum.max_by(fn {_, v} -> v end) do
      {time, _} -> {id, time}
    end
  end
end
