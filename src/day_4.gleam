import gleam/function
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

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

fn byr_validate(byr: String) -> Bool {
  validate_as_int(byr, 1920, 2002)
}

fn iyr_validate(iyr: String) {
  validate_as_int(iyr, 2010, 2020)
}

fn eyr_validate(eyr: String) {
  validate_as_int(eyr, 2020, 2030)
}

fn hgt_validate(hgt: String) -> Bool {
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
}

fn hcl_validate(hcl: String) -> Bool {
  case string.to_graphemes(hcl) {
    ["#", ..body] -> {
      let acceptable = [
        "a", "b", "c", "d", "e", "f", "0", "1", "2", "3", "4", "5", "6", "7", "8",
        "9",
      ]
      list.length(body) == 6 && list.all(body, list.contains(acceptable, _))
    }
    _ -> False
  }
}

fn ecl_validate(ecl: String) -> Bool {
  list.contains(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], ecl)
}

fn pid_validate(pid: String) -> Bool {
  string.length(pid) == 9 && result.is_ok(int.parse(pid))
}

fn is_valid_passport(passport: List(tuple(String, String))) -> Bool {
  [
    tuple("byr", byr_validate),
    tuple("iyr", iyr_validate),
    tuple("eyr", eyr_validate),
    tuple("hgt", hgt_validate),
    tuple("hcl", hcl_validate),
    tuple("ecl", ecl_validate),
    tuple("pid", pid_validate),
  ]
  |> list.all(fn(validator) {
    case list.key_find(passport, pair.first(validator)) {
      Ok(val) -> pair.second(validator)(val)
      _ -> False
    }
  })
}
