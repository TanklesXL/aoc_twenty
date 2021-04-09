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
  io.println(string.append("Day 16 Part 2: ", int.to_string(pt_2(input.input))))
}

pub fn pt_1(input: String) -> Int {
  let #(rules, _your_ticket, other_tickets) = pre_process(input)

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
  let #(rules, your_ticket, other_tickets) = pre_process(input)

  let lists_and_matches = only_valid_tickets(other_tickets, rules)

  list.range(0, map.size(rules))
  |> list.map(fn(c) { #(c, potential_column_names(lists_and_matches, c)) })
  |> list.sort(fn(a, b) {
    int.compare(set.size(pair.second(a)), set.size(pair.second(b)))
  })
  |> most_constrained_variable(map.new())
  |> map.filter(fn(_name, val) { string.contains(val, "departure") })
  |> map.fold(
    1,
    fn(column, _rule_name, acc) {
      assert Ok(x) = list.at(your_ticket, column)
      acc * x
    },
  )
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

fn pre_process(input: String) -> #(Rules, Ticket, List(Ticket)) {
  let [prelude, your_ticket, nearby_tickets] = string.split(input, "\n\n")
  let rules = parse_rules(prelude)
  let [_, your_ticket] = string.split(your_ticket, "\n")
  let your_ticket = parse_ticket_line(your_ticket)

  let [_, ..nearby_tickets] = string.split(nearby_tickets, "\n")
  let nearby_tickets = list.map(nearby_tickets, parse_ticket_line)

  #(rules, your_ticket, nearby_tickets)
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

fn only_valid_tickets(
  tickets: List(Ticket),
  rules: Rules,
) -> List(#(Ticket, RulesSatisfied)) {
  tickets
  |> list.map(fn(ticket) { #(ticket, match_nums_with_rules(ticket, rules)) })
  |> list.filter(fn(matches) {
    matches
    |> pair.second()
    |> is_invalid()
    |> bool.negate()
  })
}

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

const rule_names = [
  "departure location", "departure station", "departure platform", "departure track",
  "departure date", "departure time", "arrival location", "arrival station", "arrival platform",
  "arrival track", "class", "duration", "price", "route", "row", "seat", "train",
  "type", "wagon", "zone",
]

fn potential_column_names(
  matches: List(#(List(Int), RulesSatisfied)),
  column: Int,
) -> Set(String) {
  list.fold(
    matches,
    set.from_list(rule_names),
    fn(match, acc) {
      let #(l, satisfied) = match
      assert Ok(key) = list.at(l, column)
      assert Ok(rules_satisfied) = map.get(satisfied, key)
      set.intersection(acc, rules_satisfied)
    },
  )
}

// note: requires list to be sorted in increasing order by number of potential names for that column
// only works because once sorted the # of potential names on the columns are 1,2,3,4,...,20
// and because for every constrained variable n_0...n_i,
// the number of potential names on n_i+1 are always the names on n + some name that is
// in none of the previous potential names for vars in n_0 to n_i
fn most_constrained_variable(
  options_by_column: List(#(Int, Set(String))),
  acc: Map(Int, String),
) -> Map(Int, String) {
  case options_by_column {
    [] -> acc
    [h, ..t] -> {
      assert [rule_name] = set.to_list(h.1)
      list.map(
        t,
        fn(p: #(Int, Set(String))) { #(p.0, set.delete(p.1, rule_name)) },
      )
      |> most_constrained_variable(map.insert(acc, h.0, rule_name))
    }
  }
}
