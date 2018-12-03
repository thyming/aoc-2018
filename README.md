# aoc-2018
Advent of code, 2018

Put a file in `config/config.exs` with the contents:
```
use Mix.Config
     config :aoc2018, cookie: "YOUR SESSION COOKIE FROM adventofcode.com"
```
or you can provide a filename for input. 

Run the tasks with a mix command like:
```
mix day1_part1 {filename if using}
```
