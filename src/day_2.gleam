import gleam/int
import gleam/list
import gleam/result
import gleam/regex
import gleam/string

pub fn pt_1(input: List(String)) -> Int {
  input
  |> list.filter(satisfactory(_, is_valid_sled_policy))
  |> list.length()
}

pub fn pt_2(input: List(String)) -> Int {
  input
  |> list.filter(satisfactory(_, is_valid_toboggan_policy))
  |> list.length()
}

type Policy {
  Policy(left: Int, right: Int, letter: String, code: String)
}

fn to_policy(policy: String) -> Result(Policy, Nil) {
  let [range, letter, code] = string.split(policy, " ")
  let letter = string.drop_right(letter, 1)
  try tuple(left, right) = string.split_once(range, "-")
  try left = int.parse(left)
  try right = int.parse(right)
  Ok(Policy(left, right, letter, code))
}

fn to_policy_with_regex(policy: String) -> Result(Policy, Nil) {
  assert Ok(r) = regex.from_string("(\\d+)-(\\d+) (\\w): (\\w+)")
  let [_, left, right, letter, code, _] = regex.split(with: r, content: policy)
  try left = int.parse(left)
  try right = int.parse(right)
  Ok(Policy(left, right, letter, code))
}

fn satisfactory(s: String, validator: fn(Policy) -> Bool) -> Bool {
  case to_policy(s) {
    Ok(policy) -> validator(policy)
    _err -> False
  }
}

fn is_valid_sled_policy(policy: Policy) -> Bool {
  policy.code
  |> string.to_graphemes()
  |> list.filter(fn(letter) { letter == policy.letter })
  |> list.length()
  |> fn(count) { count >= policy.left && count <= policy.right }
}

fn is_valid_toboggan_policy(policy: Policy) -> Bool {
  let extract_left_and_right = fn(l) {
    try at_left = list.at(l, policy.left - 1)
    try at_right = list.at(l, policy.right - 1)
    Ok([at_left, at_right])
  }

  case policy.code
  |> string.to_graphemes()
  |> extract_left_and_right() {
    Ok(res) ->
      res
      |> list.filter(fn(letter) { letter == policy.letter })
      |> list.length()
      |> fn(count) { count == 1 }
    _err -> False
  }
}
