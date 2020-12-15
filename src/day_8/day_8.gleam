import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/map.{Map}
import gleam/string
import day_8/input

pub fn run() {
  // pt 1 solution: 1859
  io.println(string.append("Day 8 Part 1: ", int.to_string(pt_1(input.input))))
  // pt 2 solution: 1235
  io.println(string.append("Day 8 Part 2: ", int.to_string(pt_2(input.input))))
}

pub fn pt_1(input: String) -> Int {
  input
  |> pre_process()
  |> execute(0, 0)
  |> pair.first()
}

pub fn pt_2(input: String) -> Int {
  let Ok(tuple(acc, _)) =
    input
    |> pre_process()
    |> permutations_with_swaps()
    |> list.find_map(fn(ops) {
      let res = execute(ops, 0, 0)
      case res
      |> pair.second() == map.size(ops) {
        True -> Ok(res)
        False -> Error(Nil)
      }
    })

  acc
}

type Op {
  NOP(by: Int)
  ACC(by: Int)
  JMP(by: Int)
}

fn permutations_with_swaps(ops: Map(Int, Op)) -> List(Map(Int, Op)) {
  ops
  |> map.filter(filter_only_jmp_and_nop)
  |> map.keys()
  |> list.map(map.update(ops, _, swap_jmp_and_nop))
}

fn filter_only_jmp_and_nop(_name: Int, op: Op) -> Bool {
  case op {
    NOP(_) | JMP(_) -> True
    _ -> False
  }
}

fn swap_jmp_and_nop(op: Result(Op, Nil)) -> Op {
  case op {
    Ok(NOP(i)) -> JMP(i)
    Ok(JMP(i)) -> NOP(i)
  }
}

fn pre_process(input: String) -> Map(Int, Op) {
  input
  |> string.split("\n")
  |> list.index_map(fn(idx, line) { tuple(idx, to_op(line)) })
  |> map.from_list()
}

fn to_op(line: String) -> Op {
  case string.split(line, " ") {
    ["nop", i] -> NOP(by: parse_signed_int(i))
    ["acc", i] -> ACC(by: parse_signed_int(i))
    ["jmp", i] -> JMP(by: parse_signed_int(i))
  }
}

fn parse_signed_int(s: String) -> Int {
  let Ok(tuple(sign, num)) = string.pop_grapheme(s)
  let Ok(i) = int.parse(num)

  case sign {
    "+" -> i
    "-" -> int.negate(i)
  }
}

fn execute(ops: Map(Int, Op), to_exec: Int, acc: Int) -> tuple(Int, Int) {
  case map.get(ops, to_exec) {
    Error(_) -> tuple(acc, to_exec)
    Ok(op) ->
      case op {
        NOP(_) -> execute(map.delete(ops, to_exec), to_exec + 1, acc)
        ACC(i) -> execute(map.delete(ops, to_exec), to_exec + 1, acc + i)
        JMP(i) -> execute(map.delete(ops, to_exec), to_exec + i, acc)
      }
  }
}
