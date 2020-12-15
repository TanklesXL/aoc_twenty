import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/string
import gleam/result
import gleam/set.{Set}
import day_9/input

pub fn run() {
  io.println(string.append("Day 9 Part 1: ", int.to_string(pt_1(input.input))))
  io.println(string.append("Day 9 Part 2: ", int.to_string(pt_2(input.input))))
}

pub fn pt_1(input: List(Int)) -> Int {
  find_not_sum_of_pair(input, 25)
}

pub fn pt_2(input: List(Int)) -> Int {
  let sum = find_not_sum_of_pair(input, 25)

  input
  |> list.split_while(fn(i) { i != sum })
  |> pair.first()
  |> sum_ranges_until(sum)
  |> result.then(sum_min_and_max)
  |> result.unwrap(0)
}

fn find_not_sum_of_pair(l: List(Int), preamble_size: Int) -> Int {
  let tuple(preamble, [h, ..]) = list.split(l, preamble_size)
  case preamble
  |> sum_pairs()
  |> set.contains(h) {
    False -> h
    True ->
      l
      |> list.drop(1)
      |> find_not_sum_of_pair(preamble_size)
  }
}

fn sum_pairs(l: List(Int)) -> Set(Int) {
  list.fold(
    l,
    set.new(),
    fn(num_1, sums) {
      l
      |> list.map(fn(num_2) { num_1 + num_2 })
      |> set.from_list()
      |> set.union(sums)
    },
  )
}

fn sum_ranges_until(l: List(Int), sum: Int) -> Result(List(Int), Nil) {
  case l {
    [] | [_] -> Error(Nil)
    [_h, ..rest] ->
      case sum_until(l, sum, 0, []) {
        Error(_) -> sum_ranges_until(rest, sum)
        res -> res
      }
  }
}

fn sum_until(
  l: List(Int),
  sum: Int,
  current_sum: Int,
  acc: List(Int),
) -> Result(List(Int), Nil) {
  case l {
    [] -> Error(Nil)
    [h, ..rest] ->
      case h + current_sum {
        x if x == sum -> Ok([h, ..acc])
        x -> sum_until(rest, sum, x, [h, ..acc])
      }
  }
}

fn sum_min_and_max(l: List(Int)) -> Result(Int, Nil) {
  let l = list.sort(l, int.compare)
  try min = list.head(l)
  try max = list.at(l, list.length(l) - 1)
  Ok(min + max)
}
