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
    8 * calculate_position(pair.first(codes), list.range(0, 128)) + calculate_position(
      pair.second(codes),
      list.range(0, 8),
    )
  }
}

fn calculate_position(code: List(String), range: List(Int)) -> Int {
  case code {
    ["B"] | ["R"] -> {
      let [_, res] = range
      res
    }
    ["F"] | ["L"] -> {
      let [res, _] = range
      res
    }
    ["B", ..rest] | ["R", ..rest] ->
      calculate_position(rest, list.drop(range, list.length(range) / 2))
    ["F", ..rest] | ["L", ..rest] ->
      calculate_position(rest, list.take(range, list.length(range) / 2))
  }
}

fn find_missing(seats: List(Int)) -> Int {
  let [l, r, ..rest] = seats
  case r - l {
    2 -> r - 1
    _ -> find_missing([r, ..rest])
  }
}
