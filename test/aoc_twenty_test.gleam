import day_1
import day_2
import day_3
import day_4
import day_5
import inputs
import gleam/should

pub fn day_1_test() {
  day_1.pt_1(inputs.day_1)
  |> should.equal(972576)

  day_1.pt_2(inputs.day_1)
  |> should.equal(199300880)
}

pub fn day_2_test() {
  day_2.pt_1(inputs.day_2)
  |> should.equal(546)

  day_2.pt_2(inputs.day_2)
  |> should.equal(275)
}

pub fn day_3_test() {
  day_3.pt_1(inputs.day_3)
  |> should.equal(265)

  day_3.pt_2(inputs.day_3)
  |> should.equal(3154761400)
}

pub fn day_4_test() {
  day_4.pt_1(inputs.day_4)
  |> should.equal(233)

  day_4.pt_2(inputs.day_4)
  |> should.equal(111)
}

pub fn day_5_test() {
  day_5.pt_1(inputs.day_5)
  |> should.equal(801)

  day_5.pt_2(inputs.day_5)
  |> should.equal(597)
}
