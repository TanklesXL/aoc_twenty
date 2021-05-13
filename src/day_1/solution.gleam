import gleam/int
import gleam/io
import gleam/string
import gleam/list
import gleam/pair
import gleam/result
import day_1/input

const sum = 2020

pub fn run() {
  io.println(string.append(
    "Day 1 Part 1: ",
    int.to_string(pt_1(input.input, sum)),
  ))
  io.println(string.append(
    "Day 1 Part 2: ",
    int.to_string(pt_2(input.input, sum)),
  ))
}

pub fn pt_1(input: List(Int), sum: Int) -> Int {
  assert Ok(#(a, b)) =
    input
    |> list.combination_pairs()
    |> list.find(fn(pair) {
      let #(a, b) = pair
      a + b == sum
    })

  a * b
}

pub fn pt_2(input: List(Int), sum: Int) -> Int {
  assert Ok(#(a, b, c)) =
    input
    |> list.combinations(by: 3)
    |> list.find_map(fn(triplet) {
      assert [a, b, c] = triplet
      case a + b + c == sum {
        True -> Ok(#(a, b, c))
        False -> Error(Nil)
      }
    })

  a * b * c
}
