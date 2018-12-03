defmodule Mix.Tasks.Day3Part1 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day3Part1.apply(["#1 @ 1,3: 4x4","#2 @ 3,1: 4x4","#3 @ 5,5: 2x2"])
      4

  """

  defmodule Cutout do
    defstruct [:id, :x_offset, :y_offset, :width, :height]

    def parse(line) do
      [id, spec] = String.split(line, " @ ")
      [position, dims] = String.split(spec, ": ")
      [x, y] = String.split(position, ",")
      [width, height] = String.split(dims, "x")
      %Cutout{
        id: String.trim_leading(id, "#"),
        x_offset: String.to_integer(x),
        y_offset: String.to_integer(y),
        width: String.to_integer(width),
        height: String.to_integer(height)
      }
    end

    def size(%Cutout{width: w, height: h}) do
      w * h end

  end

  @impl Aoc2018
  def day, do: 3

  @impl Aoc2018
  def apply(lines) do
    lines
    |> Enum.map(&Cutout.parse/1)
    |> Enum.reduce(
         %{},
         fn %Cutout{
              x_offset: x_offset,
              y_offset: y_offset,
              width: width,
              height: height
            }, acc ->
           coords = for i <- Range.new(x_offset, x_offset + width - 1),
                        j <- Range.new(y_offset, y_offset + height - 1), do: {i, j}
           coords
           |> Enum.reduce(acc, fn coord, acc -> Map.update(acc, coord, 1, &(&1 + 1)) end)
         end
       )
    |> Map.values
    |> Enum.filter(&(&1 > 1))
    |> Enum.count
  end
end