import gleam/int
import gleam/list
import gleam/pair
import gleam/result

const sum = 2020

pub fn pt_1(input: List(Int)) -> Int {
  let Ok(tuple(a, b)) = find_two_that_sum(in: input, to: sum)

  a * b
}

pub fn pt_2(input: List(Int)) -> Int {
  let Ok(tuple(a, b, c)) = find_three_that_sum(in: input, to: sum)

  a * b * c
}

fn find_two_that_sum(
  in l: List(Int),
  to sum: Int,
) -> Result(tuple(Int, Int), Nil) {
  l
  |> list.find(fn(x) { list.contains(l, sum - x) })
  |> result.map(fn(x) { tuple(x, sum - x) })
}

fn find_three_that_sum(
  in l: List(Int),
  to sum: Int,
) -> Result(tuple(Int, Int, Int), Nil) {
  list.find_map(
    l,
    fn(x) {
      find_two_that_sum(in: l, to: sum - x)
      |> result.map(fn(found) {
        tuple(pair.first(found), pair.second(found), x)
      })
    },
  )
}
