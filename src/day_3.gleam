import gleam/list
import gleam/map.{Map}
import gleam/result
import gleam/string

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

pub const pt_1_slope = Slope(right: 3, down: 1)

pub fn pt_1(input: String, slope: Slope) -> Int {
  input
  |> pre_process()
  |> count_trees(Pos(row_i: 0, column_i: 0), slope, 0)
}

pub const pt_2_slopes = [
  Slope(right: 1, down: 1),
  Slope(right: 3, down: 1),
  Slope(right: 5, down: 1),
  Slope(right: 7, down: 1),
  Slope(right: 1, down: 2),
]

pub fn pt_2(input: String, slopes: List(Slope)) -> Int {
  let count = count_trees(pre_process(input), Pos(row_i: 0, column_i: 0), _, 0)

  slopes
  |> list.map(with: fn(slope) { count(slope) })
  |> list.fold(1, fn(found, acc) { found * acc })
}

pub type Slope {
  Slope(down: Int, right: Int)
}

type Pos {
  Pos(row_i: Int, column_i: Int)
}

fn count_trees(
  input: Map(Int, Map(Int, String)),
  current: Pos,
  slope: Slope,
  found: Int,
) -> Int {
  let next_pos =
    Pos(
      row_i: current.row_i + slope.down,
      column_i: current.column_i + slope.right,
    )
  case map.get(input, current.row_i)
  |> result.then(fn(row) { map.get(row, current.column_i % map.size(row)) }) {
    Ok(space) -> {
      let found = case space {
        "." -> found
        "#" -> found + 1
      }
      count_trees(input, next_pos, slope, found)
    }
    _ -> found
  }
}
