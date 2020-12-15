import gleam/bitwise
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import gleam/string
import day_5/input

pub fn run() {
  io.println(string.append("Day 5 Part 1: ", int.to_string(pt_1(input.input))))
  io.println(string.append("Day 5 Part 2: ", int.to_string(pt_2(input.input))))
}

pub fn pt_1(input: String) -> Int {
  let ids = sorted_ids(input)

  list.at(ids, list.length(ids) - 1)
  |> result.unwrap(0)
}

pub fn pt_2(input: String) -> Int {
  input
  |> sorted_ids()
  |> find_missing()
}

fn sorted_ids(input: String) -> List(Int) {
  input
  |> string.split("\n")
  |> list.map(calculate_seat_id)
  |> list.sort(int.compare)
}

fn calculate_seat_id(ticket: String) -> Int {
  ticket
  |> string.to_graphemes()
  |> list.reverse()
  |> list.index_map(fn(i, val) {
    case val {
      "L" | "F" -> 0
      "R" | "B" -> bitwise.shift_left(1, i)
    }
  })
  |> list.fold(0, fn(val, acc) { val + acc })
}

fn find_missing(seats: List(Int)) -> Int {
  let [l, r, ..rest] = seats
  case r - l {
    2 -> r - 1
    _ -> find_missing([r, ..rest])
  }
}
