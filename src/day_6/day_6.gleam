import gleam/int
import gleam/io
import gleam/list
import gleam/string
import gleam/set.{Set}
import day_6/input

pub fn run() {
  // pt 1 solution: 6457
  io.println(string.append("Day 6 Part 1: ", int.to_string(pt_1(input.input))))
  // pt 2 solution: 3260
  io.println(string.append("Day 6 Part 2: ", int.to_string(pt_2(input.input))))
}

pub fn pt_1(input: String) -> Int {
  input
  |> pre_process()
  |> process(set.union)
}

pub fn pt_2(input: String) -> Int {
  input
  |> pre_process()
  |> process(set.intersection)
}

fn pre_process(input: String) -> List(List(Set(String))) {
  input
  |> string.split("\n\n")
  |> list.map(fn(s) {
    s
    |> string.split("\n")
    |> list.map(fn(s) {
      s
      |> string.to_graphemes()
      |> set.from_list()
    })
  })
}

fn process(
  input: List(List(Set(String))),
  comparator: fn(Set(String), Set(String)) -> Set(String),
) -> Int {
  input
  |> list.map(set_compare(_, comparator))
  |> list.map(set.size)
  |> list.fold(0, fn(answered, acc) { answered + acc })
}

fn set_compare(
  sets: List(Set(a)),
  comparator: fn(Set(a), Set(a)) -> Set(a),
) -> Set(a) {
  case sets {
    [sets] -> sets
    [h, ..t] -> comparator(h, set_compare(t, comparator))
  }
}
