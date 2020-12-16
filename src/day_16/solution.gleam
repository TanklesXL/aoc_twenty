import day_16/input
import gleam/io
import gleam/string
import gleam/int
import gleam/list
import gleam/bool
import gleam/pair
import gleam/set.{Set}
import gleam/map.{Map}

pub fn run() {
  io.println(string.append("Day 16 Part 1: ", int.to_string(pt_1(input.input))))
  //   io.println(string.append("Day 16 Part 2: ", int.to_string(pt_2(input.input))))
}

pub fn pt_1(input: String) -> Int {
  let tuple(rules, _your_ticket, other_tickets) = pre_process(input)

  other_tickets
  |> list.map(match_nums_with_rules(_, rules))
  |> list.filter(is_invalid)
  |> list.fold(
    0,
    fn(ticket_map, acc) {
      map.fold(
        ticket_map,
        acc,
        fn(name, satisfied, acc) {
          case set.size(satisfied) {
            0 -> acc + name
            _ -> acc
          }
        },
      )
    },
  )
}

pub fn pt_2(input: String) -> Int {
  todo
}

type Ticket =
  List(Int)

type Range {
  Range(min: Int, max: Int)
}

type Ranges {
  Ranges(lower: Range, upper: Range)
}

type Rules =
  Map(String, Ranges)

fn pre_process(input: String) -> tuple(Rules, Ticket, List(Ticket)) {
  let [prelude, your_ticket, nearby_tickets] = string.split(input, "\n\n")
  let rules = parse_rules(prelude)
  let [_, your_ticket] = string.split(your_ticket, "\n")
  let your_ticket = parse_ticket_line(your_ticket)

  let [_, ..nearby_tickets] = string.split(nearby_tickets, "\n")
  let nearby_tickets = list.map(nearby_tickets, parse_ticket_line)

  tuple(rules, your_ticket, nearby_tickets)
}

fn parse_rules(rules: String) -> Rules {
  rules
  |> string.split("\n")
  |> list.fold(
    map.new(),
    fn(line, acc) {
      let [name, ranges] = string.split(line, ": ")
      map.insert(acc, name, parse_rules_ranges(ranges))
    },
  )
}

fn parse_rules_ranges(ranges: String) -> Ranges {
  let [lower, upper] = string.split(ranges, " or ")
  Ranges(lower: parse_rules_range(lower), upper: parse_rules_range(upper))
}

fn parse_rules_range(range: String) -> Range {
  let [min, max] = string.split(range, "-")
  assert Ok(min) = int.parse(min)
  assert Ok(max) = int.parse(max)
  Range(min: min, max: max)
}

fn parse_ticket_line(ticket: String) -> Ticket {
  ticket
  |> string.split(",")
  |> list.map(fn(s) {
    assert Ok(i) = int.parse(s)
    i
  })
}

fn is_in_ranges(num i: Int, for range: Ranges) -> Bool {
  let in_lower = i >= range.lower.min && i <= range.lower.max
  let in_upper = i >= range.upper.min && i <= range.upper.max

  in_lower || in_upper
}

type RulesSatisfied =
  Map(Int, Set(String))

fn match_nums_with_rules(ticket: Ticket, rules: Rules) -> RulesSatisfied {
  list.fold(
    ticket,
    map.new(),
    fn(num, acc) {
      map.insert(
        acc,
        num,
        rules
        |> map.filter(fn(_name, ranges) { is_in_ranges(num, ranges) })
        |> map.keys()
        |> set.from_list(),
      )
    },
  )
}

fn is_invalid(satisfied: RulesSatisfied) -> Bool {
  satisfied
  |> map.filter(fn(_, rule_names) { set.size(rule_names) == 0 })
  |> map.size() != 0
}
