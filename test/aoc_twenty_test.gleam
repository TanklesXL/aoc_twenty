import aoc_twenty
import gleam/should

pub fn hello_world_test() {
  aoc_twenty.hello_world()
  |> should.equal("Hello, from aoc_twenty!")
}
