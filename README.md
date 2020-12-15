# aoc_twenty

Advent of code 2020 in gleam! (gleam v0.12.1)

I'm new to gleam but I took the opportunity to try something new this year and learn.

Inspiration for setting up main and running with escript from [jakobht/aoc_2020](https://github.com/jakobht/aoc_2020).

## Quick start

```sh
# Build the project
rebar3 compile

# Run the eunit tests
rebar3 eunit

# Run the Erlang REPL
rebar3 shell
```

## Execute A Run

Print the output for both parts of a given day:

```sh
# Build the escript
rebar3 escriptize

# Run for a specific day
_build/default/bin/aoc_twenty <day>
```
