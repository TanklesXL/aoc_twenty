import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/set.{Set}

pub fn pt_1(input: List(Int)) -> Int {
  input
  |> list.split(25)
  |> fn(t) { find_not_sum_of_pair(pair.first(t), pair.second(t)) }
}

pub fn pt_2(input: List(Int)) -> Int {
  let sum = pt_1(input)

  input
  |> list.split_while(fn(i) { i != sum })
  |> pair.first()
  |> sum_ranges_until(sum)
  |> result.then(sum_min_and_max)
  |> result.unwrap(0)
}

fn find_not_sum_of_pair(prelude: List(Int), to_check: List(Int)) -> Int {
  let [h, ..rest] = to_check
  case prelude
  |> sum_pairs()
  |> set.contains(h) {
    False -> h
    True ->
      prelude
      |> list.drop(1)
      |> list.append([h])
      |> find_not_sum_of_pair(rest)
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
    [h, ..rest] ->
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
