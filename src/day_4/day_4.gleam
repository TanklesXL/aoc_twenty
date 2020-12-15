import gleam/function
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import gleam/io
import day_4/input

pub fn run() {
  // pt 1 solution: 233
  io.println(string.append("Day 4 Part 1: ", int.to_string(pt_1(input.input))))
  // pt 2 solution: 111
  io.println(string.append("Day 4 Part 2: ", int.to_string(pt_2(input.input))))
}

const mandatory_keys = ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"]

pub fn pt_1(input: String) -> Int {
  input
  |> pre_process()
  |> list.filter(has_keys(_, mandatory_keys))
  |> list.length()
}

pub fn pt_2(input: String) -> Int {
  input
  |> pre_process()
  |> list.filter(is_valid_passport)
  |> list.length()
}

fn pre_process(input: String) -> List(List(tuple(String, String))) {
  input
  |> string.split("\n\n")
  |> list.map(with: process_passport)
}

fn process_passport(passport: String) -> List(tuple(String, String)) {
  passport
  |> string.split("\n")
  |> list.map(string.split(_, " "))
  |> list.flatten()
  |> list.map(fn(pair) {
    let [key, val] = string.split(pair, ":")
    tuple(key, val)
  })
}

fn has_keys(passport: List(tuple(String, String)), keys: List(String)) -> Bool {
  list.all(keys, function.compose(list.key_find(passport, _), result.is_ok))
}

fn validate_as_int(s: String, min: Int, max: Int) -> Bool {
  case int.parse(s) {
    Ok(i) -> i >= min && i <= max
    _ -> False
  }
}

fn is_valid_passport(passport: List(tuple(String, String))) -> Bool {
  [
    tuple("byr", validate_as_int(_, 1920, 2002)),
    tuple("iyr", validate_as_int(_, 2010, 2020)),
    tuple("eyr", validate_as_int(_, 2020, 2030)),
    tuple(
      "hgt",
      fn(hgt) {
        case string.slice(hgt, -2, 2) {
          "cm" ->
            hgt
            |> string.drop_right(2)
            |> validate_as_int(150, 193)
          "in" ->
            hgt
            |> string.drop_right(2)
            |> validate_as_int(59, 76)
          _ -> False
        }
      },
    ),
    tuple(
      "hcl",
      fn(hcl) {
        case string.to_graphemes(hcl) {
          ["#", ..body] -> {
            let acceptable = [
              "a", "b", "c", "d", "e", "f", "0", "1", "2", "3", "4", "5", "6", "7",
              "8", "9",
            ]
            list.length(body) == 6 && list.all(
              body,
              list.contains(acceptable, _),
            )
          }
          _ -> False
        }
      },
    ),
    tuple(
      "ecl",
      list.contains(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], _),
    ),
    tuple(
      "pid",
      fn(pid) { string.length(pid) == 9 && result.is_ok(int.parse(pid)) },
    ),
  ]
  |> list.all(fn(validator) {
    case list.key_find(passport, pair.first(validator)) {
      Ok(val) -> pair.second(validator)(val)
      _ -> False
    }
  })
}
