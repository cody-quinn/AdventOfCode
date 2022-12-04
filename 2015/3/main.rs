use std::collections::HashSet;

use aoc::pos::Pos;

fn main() {
    let input = include_str!("input.txt");

    let mut toggle = false;

    let mut santa = Pos(0, 0);
    let mut robo = Pos(0, 0);

    let mut visited = HashSet::<Pos>::new();

    visited.insert(santa);
    for c in input.chars() {
        let x = match c {
            '>' => Pos(1, 0),
            '<' => Pos(-1, 0),
            '^' => Pos(0, 1),
            'v' => Pos(0, -1),
            _ => Pos(0, 0),
        };

        if toggle {
            robo += x;
            visited.insert(robo);
        } else {
            santa += x;
            visited.insert(santa);
        }

        toggle = !toggle;
    }

    println!("{}", visited.len());
}
