import day_1
import day_2
import day_3
import inputs
import gleam/should

pub fn day_1_test() {
  day_1.pt_1(inputs.day_1, day_1.sum)
  |> should.equal(972576)

  day_1.pt_2(inputs.day_1, day_1.sum)
  |> should.equal(199300880)
}

pub fn day_2_test() {
  day_2.pt_1(inputs.day_2)
  |> should.equal(546)

  day_2.pt_2(inputs.day_2)
  |> should.equal(275)
}

pub fn day_3_test() {
  day_3.pt_1(inputs.day_3, day_3.pt_1_slope)
  |> should.equal(265)

  day_3.pt_2(inputs.day_3, day_3.pt_2_slopes)
  |> should.equal(3154761400)
}
