import gleam/list
import gleam/map.{Map}
import gleam/result
import gleam/string
import gleam/io
import gleam/int
import day_3/input

const pt_1_slope = Slope(right: 3, down: 1)

pub fn run() {
  io.println(string.append("Day 3 Part 1: ", int.to_string(pt_1(input.input))))
  io.println(string.append("Day 3 Part 2: ", int.to_string(pt_2(input.input))))
}

pub fn pt_1(input: String) -> Int {
  input
  |> pre_process()
  |> count_trees(
    from: Pos(row_i: 0, column_i: 0),
    along: pt_1_slope,
    with_acc: 0,
  )
}

const pt_2_slopes = [
  Slope(right: 1, down: 1),
  Slope(right: 3, down: 1),
  Slope(right: 5, down: 1),
  Slope(right: 7, down: 1),
  Slope(right: 1, down: 2),
]

pub fn pt_2(input: String) -> Int {
  let count = count_trees(
    in: pre_process(input),
    from: Pos(row_i: 0, column_i: 0),
    along: _,
    with_acc: 0,
  )

  pt_2_slopes
  |> list.map(count)
  |> int.product()
}

fn pre_process(input: String) -> Map(Int, Map(Int, String)) {
  input
  |> string.split(on: "\n")
  |> list.index_map(fn(i, row) { tuple(i, string.to_graphemes(row)) })
  |> map.from_list()
  |> map.map_values(fn(_, row) {
    list.range(0, list.length(row))
    |> list.zip(row)
    |> map.from_list()
  })
}

type Slope {
  Slope(down: Int, right: Int)
}

type Pos {
  Pos(row_i: Int, column_i: Int)
}

fn count_trees(
  in input: Map(Int, Map(Int, String)),
  from current: Pos,
  along slope: Slope,
  with_acc found: Int,
) -> Int {
  case input
  |> map.get(current.row_i)
  |> result.then(fn(row) { map.get(row, current.column_i % map.size(row)) }) {
    Ok(space) -> {
      let found = case space {
        "." -> found
        "#" -> found + 1
      }
      let next =
        Pos(
          row_i: current.row_i + slope.down,
          column_i: current.column_i + slope.right,
        )
      count_trees(in: input, from: next, along: slope, with_acc: found)
    }
    _ -> found
  }
}
