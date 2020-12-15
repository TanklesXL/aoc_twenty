import gleam/map.{Map}
import gleam/pair
import gleam/list
import gleam/result
import gleam/int
import gleam/set.{Set}
import gleam/io
import gleam/bool
import gleam/iterator
import gleam/function
import gleam/string
import day_7/input

pub fn run() {
  // pt 1 solution: 139
  io.println(string.append("Day 7 Part 1: ", int.to_string(pt_1(input.input))))
  // pt 2 solution: 58175
  io.println(string.append("Day 7 Part 2: ", int.to_string(pt_2(input.input))))
}

const goal_bag = "shiny gold"

pub fn pt_1(input: String) -> Int {
  input
  |> pre_process()
  |> how_many_can_hold_goal(goal_bag)
}

pub fn pt_2(input: String) -> Int {
  let bags = pre_process(input)
  let Ok(contents_of_goal_bag) = map.get(bags, goal_bag)
  sum_with_inside(bags, contents_of_goal_bag)
}

type Capacity {
  Capacity(name: String, amount: Int)
}

type Bags =
  Map(String, List(Capacity))

fn pre_process(input: String) -> Bags {
  input
  |> string.split("\n")
  |> iterator.from_list()
  |> iterator.map(string.replace(_, ".", ""))
  |> iterator.map(string.replace(_, " bags", ""))
  |> iterator.map(string.replace(_, " bag", ""))
  |> iterator.map(string.split(_, " contain "))
  |> iterator.map(fn(line) {
    let [outer, inner] = line
    tuple(outer, parse_capacity(inner))
  })
  |> iterator.to_list()
  |> map.from_list()
}

fn parse_capacity(capacities: String) -> List(Capacity) {
  case capacities {
    "no other" -> []
    _ ->
      capacities
      |> string.split(", ")
      |> list.map(fn(capacity) {
        let Ok(tuple(count, name)) = string.split_once(capacity, " ")
        let Ok(count) = int.parse(count)
        Capacity(name: name, amount: count)
      })
  }
}

fn how_many_can_hold_goal(in bags: Bags, with_goal bag: String) -> Int {
  let starting_set = set.insert(set.new(), bag)

  bags
  |> can_hold(starting_set)
  |> set.delete(goal_bag)
  |> set.size()
}

fn can_hold(in bags: Bags, already_seen seen: Set(String)) -> Set(String) {
  let new =
    bags
    |> map.filter(fn(name, capacities) {
      bool.negate(set.contains(seen, name)) && list.any(
        capacities,
        fn(capacity: Capacity) { set.contains(seen, capacity.name) },
      )
    })
    |> map.keys()

  case list.length(new) {
    0 -> seen
    _ -> can_hold(in: bags, already_seen: set.union(seen, set.from_list(new)))
  }
}

// this function is ineffecient as it potentially computes the same bag values multiple times
fn sum_with_inside(bags: Bags, contents: List(Capacity)) -> Int {
  list.fold(
    contents,
    0,
    fn(capacity: Capacity, acc: Int) {
      let Ok(contents) = map.get(bags, capacity.name)
      acc + capacity.amount + capacity.amount * sum_with_inside(bags, contents)
    },
  )
}
