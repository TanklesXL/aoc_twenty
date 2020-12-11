import day_1
import day_2
import day_3
import day_4
import day_5
import day_6
import day_7
import day_8
import day_9
import day_10
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

pub fn day_6_test() {
  day_6.pt_1(inputs.day_6)
  |> should.equal(6457)

  day_6.pt_2(inputs.day_6)
  |> should.equal(3260)
}

pub fn day_7_test() {
  day_7.pt_1(inputs.day_7)
  |> should.equal(139)

  day_7.pt_2(inputs.day_7)
  |> should.equal(58175)
}

pub fn day_8_test() {
  day_8.pt_1(inputs.day_8)
  |> should.equal(1859)

  day_8.pt_2(inputs.day_8)
  |> should.equal(1235)
}

pub fn day_9_test() {
  day_9.pt_1(inputs.day_9)
  |> should.equal(393911906)

  day_9.pt_2(inputs.day_9)
  |> should.equal(59341885)
}

pub fn day_10_test() {
  day_10.pt_1(inputs.day_10)
  |> should.equal(1656)

  day_10.pt_2(inputs.day_10)
  |> should.equal(56693912375296)
}
