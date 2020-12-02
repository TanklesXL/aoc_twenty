import day_1
import day_2
import gleam/should

pub fn day_1_test() {
  day_1.pt_1(day_1.input, day_1.sum)
  |> should.equal(972576)

  day_1.pt_2(day_1.input, day_1.sum)
  |> should.equal(199300880)
}

pub fn day_2_test() {
  day_2.pt_1(day_2.input)
  |> should.equal(546)

  day_2.pt_2(day_2.input)
  |> should.equal(275)
}
