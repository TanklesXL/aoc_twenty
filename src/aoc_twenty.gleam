import gleam/string
import gleam/io
import gleam/int
import gleam/list
import gleam/result
import gleam/iterator
import day_1/solution as day_1
import day_2/solution as day_2
import day_3/solution as day_3
import day_4/solution as day_4
import day_5/solution as day_5
import day_6/solution as day_6
import day_7/solution as day_7
import day_8/solution as day_8
import day_9/solution as day_9
import day_10/solution as day_10
import day_11/solution as day_11
// import day_12/solution as day_12
import day_13/solution as day_13
import day_14/solution as day_14
import day_15/solution as day_15

pub external type Charlist

external fn list_to_binary(Charlist) -> String =
  "erlang" "list_to_binary"

pub fn run_day(day: Int) -> Result(Nil, String) {
  case day {
    1 -> Ok(day_1.run())
    2 -> Ok(day_2.run())
    3 -> Ok(day_3.run())
    4 -> Ok(day_4.run())
    5 -> Ok(day_5.run())
    6 -> Ok(day_6.run())
    7 -> Ok(day_7.run())
    8 -> Ok(day_8.run())
    9 -> Ok(day_9.run())
    10 -> Ok(day_10.run())
    11 -> Ok(day_11.run())
    13 -> Ok(day_13.run())
    14 -> Ok(day_14.run())
    15 -> Ok(day_15.run())
    _ ->
      Error(string.join(["Day:", int.to_string(day), "is not supported"], " "))
  }
}

fn parse_day(day: Charlist) -> Result(Int, String) {
  let day = list_to_binary(day)
  day
  |> int.parse()
  |> result.map_error(fn(_) {
    string.join(["The day supplied:", day, "is not an integer"], " ")
  })
}

pub fn main(args: List(Charlist)) {
  let result =
    case args {
      [] -> Ok(list.range(1, 26))
      _ ->
        args
        |> list.map(parse_day)
        |> result.all()
    }
    |> result.then(fn(days) { result.all(list.map(days, run_day)) })

  case result {
    Error(error) -> io.println(string.append("ERROR: ", error))
    Ok(_) -> Nil
  }
}
