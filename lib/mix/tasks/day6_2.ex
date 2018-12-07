defmodule Mix.Tasks.Day6Part2 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day6Part2.apply(["1, 1","1, 6","8, 3","3, 4","5, 5","8, 9"])
      16

  """

  @impl Aoc2018
  def day, do: "6"

  @impl Aoc2018
  def apply(lines) do
    coords = parse_coords(lines)
    {min_x, min_y, max_x, max_y} = corners(coords)
    on_boundary = on_boundary(coords)

    grid =
      for x <- min_x..max_x,
          y <- min_y..max_y do
        {x, y}
      end

    grid
    |> Enum.map(fn coord ->
       coords |> Enum.map(&(distance(&1, coord))) |> Enum.sum
    end)
    |> Enum.filter(&(&1 < 10000))
    |> Enum.count()
  end

  def parse_coords(lines) do
    lines
    |> Enum.map(&String.split(&1, ", "))
    |> Enum.map(fn [x, y] ->
      {String.to_integer(x), String.to_integer(y)}
    end)
  end

  def distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def corners(coords) do
    min_x = coords |> Enum.map(&elem(&1, 0)) |> Enum.min()
    max_x = coords |> Enum.map(&elem(&1, 0)) |> Enum.max()
    min_y = coords |> Enum.map(&elem(&1, 1)) |> Enum.min()
    max_y = coords |> Enum.map(&elem(&1, 1)) |> Enum.max()
    {min_x, min_y, max_x, max_y}
  end

  # def boundary_pts(coords) do
  #   {min_x, min_y, max_x, max_y} = corners(coords)

  #   Enum.concat(
  #     for x <- min_x..max_x,
  #         y <- [min_y, max_y] do
  #       {x, y}
  #     end,
  #     for y <- min_y..max_y,
  #         x <- [min_x, max_x] do
  #       {x, y}
  #     end
  #   )
  #   |> MapSet.new()
  # end

  def on_boundary(coords) do
    {min_x, min_y, max_x, max_y} = corners(coords)

    fn {x, y} ->
      x == min_x || x == max_x || y == min_y || y == max_y
    end
  end
end
