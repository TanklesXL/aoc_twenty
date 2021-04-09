import gleam/int
import gleam/io
import gleam/string
import gleam/list
import gleam/pair
import gleam/result
import day_1/input

const sum = 2020

pub fn run() {
  io.println(string.append("Day 1 Part 1: ", int.to_string(pt_1(input.input))))
  io.println(string.append("Day 1 Part 2: ", int.to_string(pt_2(input.input))))
}

pub fn pt_1(input: List(Int)) -> Int {
  let Ok(#(a, b)) = find_two_that_sum(in: input, to: sum)

  a * b
}

pub fn pt_2(input: List(Int)) -> Int {
  let Ok(#(a, b, c)) = find_three_that_sum(in: input, to: sum)

  a * b * c
}

fn find_two_that_sum(in l: List(Int), to sum: Int) -> Result(#(Int, Int), Nil) {
  l
  |> list.find(fn(x) { list.contains(l, sum - x) })
  |> result.map(fn(x) { #(x, sum - x) })
}

fn find_three_that_sum(
  in l: List(Int),
  to sum: Int,
) -> Result(#(Int, Int, Int), Nil) {
  list.find_map(
    l,
    fn(x) {
      find_two_that_sum(in: l, to: sum - x)
      |> result.map(fn(found: #(Int, Int)) { #(found.0, found.1, x) })
    },
  )
}
