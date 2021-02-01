import gleam/int
import gleam/list
import gleam/string
import gleam/map.{Map}
import gleam/bitwise
import gleam/io
import day_14/input

pub fn run() {
  io.println(string.append("Day 14 Part 1: ", int.to_string(pt_1(input.input))))
  io.println(string.append("Day 14 Part 2: ", int.to_string(pt_2(input.input))))
}

pub fn pt_1(input: String) -> Int {
  input
  |> pre_process()
  |> list.fold(map.new(), apply_value_mask)
  |> map.values()
  |> int.sum()
}

pub fn pt_2(input: String) -> Int {
  input
  |> pre_process()
  |> list.fold(map.new(), apply_address_mask)
  |> map.values()
  |> int.sum()
}

type Address {
  Address(location: Int, value: Int)
}

type Masking {
  Masking(mask: String, addresses: List(Address))
}

fn pre_process(input: String) -> List(Masking) {
  let [_, ..data] = string.split(input, "mask = ")
  list.map(data, new_masking)
}

fn new_masking(input: String) -> Masking {
  let [mask, ..t] = string.split(input, "\n")

  Masking(
    mask: mask,
    addresses: t
    |> list.filter(fn(s) { s != "" })
    |> list.map(new_address),
  )
}

fn new_address(input: String) -> Address {
  let Ok(tuple(l, r)) = string.split_once(input, " = ")
  let Ok(value) = int.parse(r)
  let Ok(location) =
    l
    |> string.replace("mem[", "")
    |> string.replace("]", "")
    |> int.parse()

  Address(location: location, value: value)
}

fn apply_value_mask(masking: Masking, acc: Map(Int, Int)) -> Map(Int, Int) {
  list.fold(
    masking.addresses,
    acc,
    fn(address: Address, acc: Map(Int, Int)) {
      map.insert(
        acc,
        address.location,
        address.value
        |> bitwise.or(x_as_0(masking.mask))
        |> bitwise.and(x_as_1(masking.mask)),
      )
    },
  )
}

fn x_as_0(masking: String) -> Int {
  masking
  |> string.replace("X", "0")
  |> parse_bin()
}

fn x_as_1(masking: String) -> Int {
  masking
  |> string.replace("X", "1")
  |> parse_bin()
}

fn parse_bin(s: String) -> Int {
  s
  |> string.to_graphemes()
  |> list.index_fold(
    0,
    fn(i, v, acc) {
      let Ok(v) = int.parse(v)
      acc + bitwise.shift_left(v, 35 - i)
    },
  )
}

fn apply_address_mask(masking: Masking, acc: Map(Int, Int)) -> Map(Int, Int) {
  masking
  |> address_variants()
  |> list.fold(
    acc,
    fn(address: Address, acc: Map(Int, Int)) {
      map.insert(acc, address.location, address.value)
    },
  )
}

fn address_variants(masking: Masking) -> List(Address) {
  list.map(masking.addresses, single_address_variant(masking.mask, _))
  |> list.flatten()
}

fn single_address_variant(mask: String, address: Address) -> List(Address) {
  mask
  |> string.to_graphemes()
  |> list.zip(
    address.location
    |> to_bin()
    |> string.to_graphemes(),
  )
  |> list.map(fn(p) {
    let tuple(from_mask, from_addr) = p
    case from_mask {
      "0" -> from_addr
      _ -> from_mask
    }
  })
  |> variants_from_graphemes([""])
  |> list.map(fn(addr: String) {
    Address(location: parse_bin(addr), value: address.value)
  })
}

fn to_bin(num: Int) -> String {
  binarize(num, [])
}

fn binarize(num: Int, acc: List(Int)) -> String {
  case num / 2 == 0 {
    True ->
      [num % 2, ..acc]
      |> list.map(int.to_string)
      |> string.join("")
      |> string.pad_left(to: 36, with: "0")
    False -> binarize(num / 2, [num % 2, ..acc])
  }
}

fn variants_from_graphemes(l: List(String), acc: List(String)) -> List(String) {
  case l {
    [] -> acc
    [h, ..t] ->
      case h {
        "X" ->
          variants_from_graphemes(
            t,
            list.map(
              acc,
              fn(s) { [string.append(s, "1"), string.append(s, "0")] },
            )
            |> list.flatten(),
          )
        b -> variants_from_graphemes(t, list.map(acc, string.append(_, b)))
      }
  }
}
