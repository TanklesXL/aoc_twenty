import gleam/iterator
import gleam/map.{Map}
import gleam/result
import gleam/list
import gleam/string
import gleam/pair
import gleam/io
import gleam/int
import day_15/input

pub fn run() {
  // pt 1 solution: 959
  io.println(string.append("Day 15 Part 1: ", int.to_string(pt_1(input.input))))
  // pt 2 solution: 116590
  io.println(string.append("Day 15 Part 2: ", int.to_string(pt_2(input.input))))
}

const steps_1 = 2020

const steps_2 = 30000000

pub fn pt_1(input: List(Int)) -> Int {
  execute(input, steps_1)
}

pub fn pt_2(input: List(Int)) -> Int {
  execute(input, steps_2)
}

fn execute(input: List(Int), iterations: Int) -> Int {
  assert starting = init(input)
  assert Ok(last_inserted) = list.at(input, list.length(input) - 1)
  let starting_acc = tuple(last_inserted, starting)

  iterator.range(list.length(input) + 1, iterations + 1)
  |> iterator.fold(starting_acc, speak)
  |> pair.first()
}

type Spoken {
  Never
  Once(first: Int)
  Multiple(last: Int, second_last: Int)
}

fn init(l: List(Int)) -> Map(Int, Spoken) {
  assert Ok(lt) = list.strict_zip(l, list.range(1, list.length(l) + 1))
  list.fold(
    lt,
    map.new(),
    fn(t, acc) {
      let tuple(val, i) = t
      map.insert(acc, val, Once(i))
    },
  )
}

fn speak(
  step: Int,
  acc: tuple(Int, Map(Int, Spoken)),
) -> tuple(Int, Map(Int, Spoken)) {
  let tuple(last_inserted, when_inserted) = acc
  assert Ok(when) = map.get(when_inserted, last_inserted)

  let to_update = case when {
    Once(_) -> 0
    Multiple(last: last, second_last: second_last) -> last - second_last
  }

  let updater = fn(res) {
    case result.unwrap(res, Never) {
      Never -> Once(first: step)
      Once(first: first) -> Multiple(last: step, second_last: first)
      Multiple(last: last, second_last: _) ->
        Multiple(last: step, second_last: last)
    }
  }

  tuple(to_update, map.update(when_inserted, to_update, updater))
}
