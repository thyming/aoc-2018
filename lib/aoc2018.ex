defmodule Aoc2018 do

  defmacro __using__(_context) do
    quote do
      def run(args) do
        input = if length(args) > 0 do
          File.stream! Enum.at(args, 0), [:utf, :read]
        else
          IO.stream(:stdio, :line)
        end
        IO.puts(:stdio, Aoc2018.apply!(__MODULE__, input |> Enum.map(&String.trim/1)))
      end
    end
  end

  @callback apply([String.t]) :: Any
  def apply!(implementation, input) do
    implementation.apply(input)
  end

end
