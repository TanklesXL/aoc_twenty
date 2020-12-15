import gleam/string
import gleam/io
import gleam/int
import gleam/list
import gleam/result
import gleam/iterator
import day_1/day_1
import day_2/day_2
import day_3/day_3
import day_4/day_4
import day_5/day_5
import day_6/day_6
import day_7/day_7
import day_8/day_8
import day_9/day_9
import day_10/day_10
import day_11/day_11
// import day_12/day_12
import day_13/day_13
import day_14/day_14
import day_15/day_15

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

pub fn main(args: List(Charlist)) {
  let result = case args {
    [day] -> {
      let day = list_to_binary(day)
      day
      |> int.parse()
      |> result.map_error(fn(_) {
        string.join(["The day supplied:", day, "is not an integer"], " ")
      })
      |> result.then(run_day)
    }
    _ -> Error("Please choose exactly one day")
  }

  case result {
    Error(error) -> io.println(string.append("ERROR: ", error))
    Ok(_) -> Nil
  }
}
