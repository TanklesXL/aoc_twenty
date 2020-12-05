import gleam/int
import gleam/pair
import gleam/list
import gleam/result
import gleam/string

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
  |> list.split(at: 7)
  |> fn(codes) {
    let tuple(row, column) = codes
    8 * position(row, tuple(0, 127)) + position(column, tuple(0, 7))
  }
}

fn position(code: List(String), range: tuple(Int, Int)) -> Int {
  let tuple(min, max) = range
  case code {
    ["B"] | ["R"] -> {
      let tuple(_, res) = range
      res
    }
    ["F"] | ["L"] -> {
      let tuple(res, _) = range
      res
    }
    ["B", ..rest] | ["R", ..rest] -> {
      let new_range = tuple(min + { max - min } / 2 + 1, max)
      position(rest, new_range)
    }
    ["F", ..rest] | ["L", ..rest] -> {
      let new_range = tuple(min, max - { max - min } / 2 - 1)
      position(rest, new_range)
    }
  }
}

fn find_missing(seats: List(Int)) -> Int {
  let [l, r, ..rest] = seats
  case r - l {
    2 -> r - 1
    _ -> find_missing([r, ..rest])
  }
}
