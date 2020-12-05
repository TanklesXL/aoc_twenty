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
  |> list.reverse()
  |> list.index_map(fn(i, val) {
    case val {
      "L" | "F" -> 0
      "R" | "B" ->
        // need to do 2 ^ i this way because language doesn't seem to have exponents (yet)
        2
        |> list.repeat(i)
        |> list.fold(1, fn(val, acc) { val * acc })
    }
  })
  |> list.fold(0, fn(num, acc) { num + acc })
}

fn find_missing(seats: List(Int)) -> Int {
  let [l, r, ..rest] = seats
  case r - l {
    2 -> r - 1
    _ -> find_missing([r, ..rest])
  }
}
