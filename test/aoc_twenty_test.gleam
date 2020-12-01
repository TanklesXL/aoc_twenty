import day_1
import gleam/should

pub fn day_1_test() {
  day_1.pt_1(day_1.input, day_1.sum)
  |> should.equal(972576)

  day_1.pt_2(day_1.input, day_1.sum)
  |> should.equal(199300880)
}
