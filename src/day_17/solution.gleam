import day_17/input
import gleam/io
import gleam/int
import gleam/string
import gleam/list
import gleam/iterator.{Iterator}
import gleam/result
import gleam/set
import gleam/map.{Map}

pub fn run() {
  io.println(string.append("Day 17 Part 1: ", int.to_string(pt_1(input.input))))
  io.println(string.append("Day 17 Part 2: ", int.to_string(pt_2(input.input))))
}

const num_steps = 6

pub fn pt_1(input: String) -> Int {
  execute(input, 3)
}

pub fn pt_2(input: String) -> Int {
  execute(input, 4)
}

fn execute(input: String, dimensions: Int) -> Int {
  let space = pre_process(input)

  fn() { Nil }
  |> iterator.repeatedly()
  |> iterator.take(num_steps)
  |> list.fold(
    space,
    fn(_, space) { new_world(space, neighbour_generator(dimensions)) },
  )
  |> map.filter(fn(_pos, cube) { cube == Active })
  |> map.size()
}

type Cube {
  Active
  Inactive
}

type Pos {
  Pos(row: Int, col: Int, depth: Int, time: Int)
}

type Space =
  Map(Pos, Cube)

fn pre_process(input: String) -> Space {
  input
  |> string.split("\n")
  |> list.index_map(fn(i, row) {
    list.index_map(
      string.to_graphemes(row),
      fn(j, space) { tuple(Pos(row: i, col: j, depth: 0, time: 0), case space {
            "." -> Inactive
            "#" -> Active
          }) },
    )
  })
  |> list.flatten()
  |> map.from_list()
}

fn neighbour_generator(with_dim dimensions: Int) -> fn(Pos) -> Iterator(Pos) {
  case dimensions {
    3 -> neighbours_3d
    4 -> neighbours_4d
  }
}

fn neighbours_3d(p: Pos) -> Iterator(Pos) {
  let offsets = [-1, 0, 1]
  list.fold(
    offsets,
    set.new(),
    fn(i, acc) {
      list.fold(
        offsets,
        acc,
        fn(j, acc) {
          list.fold(
            offsets,
            acc,
            fn(k, acc) {
              set.insert(
                acc,
                Pos(row: p.row + i, col: p.col + j, depth: p.depth + k, time: 0),
              )
            },
          )
        },
      )
    },
  )
  |> set.delete(p)
  |> set.to_list()
  |> iterator.from_list()
}

fn neighbours_4d(p: Pos) -> Iterator(Pos) {
  let offsets = [-1, 0, 1]

  list.fold(
    offsets,
    set.new(),
    fn(i, acc) {
      list.fold(
        offsets,
        acc,
        fn(j, acc) {
          list.fold(
            offsets,
            acc,
            fn(k, acc) {
              list.fold(
                offsets,
                acc,
                fn(l, acc) {
                  set.insert(
                    acc,
                    Pos(
                      row: p.row + i,
                      col: p.col + j,
                      depth: p.depth + k,
                      time: p.time + l,
                    ),
                  )
                },
              )
            },
          )
        },
      )
    },
  )
  |> set.delete(p)
  |> set.to_list()
  |> iterator.from_list()
}

fn new_cube_value(
  with cube: Cube,
  at pos: Pos,
  in space: Space,
  neighbour_generator neighbours: fn(Pos) -> Iterator(Pos),
) -> Cube {
  case cube {
    Active -> handle_active(at: pos, in: space, neighbour_generator: neighbours)
    Inactive ->
      handle_inactive(at: pos, in: space, neighbour_generator: neighbours)
  }
}

fn handle_active(
  at pos: Pos,
  in space: Space,
  neighbour_generator neighbours: fn(Pos) -> Iterator(Pos),
) -> Cube {
  case active_neighbours_count(
    next_to: pos,
    in: space,
    neighbour_generator: neighbours,
  ) {
    2 | 3 -> Active
    _ -> Inactive
  }
}

fn handle_inactive(
  at pos: Pos,
  in space: Space,
  neighbour_generator neighbours: fn(Pos) -> Iterator(Pos),
) -> Cube {
  case active_neighbours_count(
    next_to: pos,
    in: space,
    neighbour_generator: neighbours,
  ) {
    3 -> Active
    _ -> Inactive
  }
}

fn active_neighbours_count(
  next_to pos: Pos,
  in space: Space,
  neighbour_generator neighbours: fn(Pos) -> Iterator(Pos),
) -> Int {
  pos
  |> neighbours()
  |> iterator.to_list()
  |> list.filter_map(map.get(space, _))
  |> list.filter(fn(cube) { cube == Active })
  |> list.length()
}

fn expand_world(space: Space, neighbours: fn(Pos) -> Iterator(Pos)) -> Space {
  space
  |> map.keys()
  |> iterator.from_list()
  |> iterator.flat_map(neighbours)
  |> iterator.to_list()
  |> set.from_list()
  |> set.fold(
    space,
    fn(pos, acc) { map.update(acc, pos, result.unwrap(_, Inactive)) },
  )
}

fn new_world(
  space: Space,
  neighbour_generator neighbours: fn(Pos) -> Iterator(Pos),
) -> Space {
  let expanded = expand_world(space, neighbours)
  map.fold(
    expanded,
    [],
    fn(pos, cube, acc) {
      [
        tuple(
          pos,
          new_cube_value(
            with: cube,
            at: pos,
            in: expanded,
            neighbour_generator: neighbours,
          ),
        ),
        ..acc
      ]
    },
  )
  |> map.from_list()
}
