defmodule Aoc2018 do

  defmacro __using__(_context) do
    quote do
      def run(args) do
        input = if length(args) > 0 do
          File.stream! Enum.at(args, 0), [:utf, :read]
        else
          HTTPoison.start
          day = Aoc2018.day(__MODULE__)
          cookie = Application.get_env(:aoc2018, :cookie)
          HTTPoison.get!(
            "https://adventofcode.com/2018/day/#{day}/input",
            %{},
            hackney: [
              cookie: ["session=#{cookie}"]
            ]
          ).body
          |> String.trim
          |> String.split("\n")
        end

        IO.puts(
          :stdio,
          Aoc2018.apply!(
            __MODULE__,
            input
            |> Enum.map(&String.trim/1)
          )
        )
      end
    end
  end

  @callback apply([String.t]) :: Any
  @callback day() :: String

  def apply!(implementation, input) do
    implementation.apply(input)
  end
  def day(implementation) do
    implementation.day
  end



end
