defmodule Mix.Tasks.Day6Part1 do
  @behaviour Aoc2018

  use Aoc2018
  use Mix.Task

  @doc ~S"""
  ## Examples

      iex> Mix.Tasks.Day6Part1.apply(["1, 1","1, 6","8, 3","3, 4","5, 5","8, 9"])
      17

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
      [{d1, c1}, {d2, _} | _] = coords |> Enum.map(&{distance(&1, coord), &1}) |> Enum.sort()
      if d1 == d2, do: nil, else: c1
    end)
    |> Enum.zip(grid)
    |> Enum.group_by(fn {c, _} -> c end)
    |> Enum.reject(fn {c, _} -> is_nil(c) end)
    |> Enum.reject(fn {_, vs} -> Enum.any?(vs, fn {_, pt} -> on_boundary.(pt) end) end)
    |> Enum.map(fn {_, vs} -> length(vs) end)
    |> Enum.max()
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
