defmodule Mix.Tasks.Day3Part2 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task

  alias Mix.Tasks.Day3Part1.Cutout, as: Cutout

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day3Part2.apply(["#1 @ 1,3: 4x4","#2 @ 3,1: 4x4","#3 @ 5,5: 2x2"])
      "3"

  """

  @impl Aoc2018
  def day, do: 3

  @impl Aoc2018
  def apply(lines) do
    cutouts = lines
              |> Enum.map(&Cutout.parse/1)

    ids = cutouts
          |> Enum.map(&({Map.get(&1, :id), Cutout.size(&1)}))
          |> Enum.into(%{})

    cutouts
    |> Enum.reduce(
         %{},
         fn %Cutout{
              id: id,
              x_offset: x_offset,
              y_offset: y_offset,
              width: width,
              height: height
            }, acc ->
           coords = for i <- Range.new(x_offset, x_offset + width - 1),
                        j <- Range.new(y_offset, y_offset + height - 1), do: {i, j}
           coords
           |> Enum.reduce(
                acc,
                fn coord, acc ->
                  Map.update(acc, coord, MapSet.new([id]), &(MapSet.put(&1, id)))
                end
              )
         end
       )
    |> Enum.reduce(
         ids,
         fn {_, occupants}, ids ->
           if MapSet.size(occupants) > 1 do
             Map.drop(ids, occupants)
           else
             ids
           end
         end
       )
    |> Map.keys
    |> Enum.at(0)

  end
end