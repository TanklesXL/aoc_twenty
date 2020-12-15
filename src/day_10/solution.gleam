import gleam/list
import gleam/map.{Map}
import gleam/int
import gleam/io
import gleam/float
import gleam/result
import gleam/pair
import gleam/bool
import gleam/string
import day_10/input

pub fn run() {
  io.println(string.append("Day 10 Part 1: ", int.to_string(pt_1(input.input))))
  io.println(string.append("Day 10 Part 2: ", int.to_string(pt_2(input.input))))
}

pub fn pt_1(input: List(Int)) -> Int {
  let counts =
    input
    |> setup()
    |> deltas(0, [])

  let singles =
    list.filter(counts, fn(x) { x == 1 })
    |> list.length()
  let triples =
    list.filter(counts, fn(x) { x == 3 })
    |> list.length()

  singles * triples
}

fn setup(l: List(Int)) -> List(Int) {
  let l = list.sort(l, int.compare)
  let max = last_or_zero(l)
  list.append(l, [max + 3])
}

fn last_or_zero(l: List(Int)) -> Int {
  let Ok(last) = list.at(l, list.length(l) - 1)
  last
}

fn deltas(l: List(Int), last: Int, acc: List(Int)) -> List(Int) {
  case l {
    [] -> acc
    [h, ..t] -> deltas(t, h, [h - last, ..acc])
  }
}

pub fn pt_2(input: List(Int)) -> Int {
  let input = setup(input)

  let Ok(output) =
    input
    |> list.fold(map.from_list([tuple(0, 1)]), accumulate_jolts)
    |> map.get(last_or_zero(input))

  output
}

fn accumulate_jolts(target_jolts: Int, options: Map(Int, Int)) -> Map(Int, Int) {
  map.insert(
    options,
    target_jolts,
    list.fold(
      [1, 2, 3],
      0,
      fn(diff, acc) {
        acc + {
          options
          |> map.get(target_jolts - diff)
          |> result.unwrap(0)
        }
      },
    ),
  )
}
