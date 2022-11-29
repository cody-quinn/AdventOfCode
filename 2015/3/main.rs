#![allow(unused)]

use std::{collections::HashSet, ops::Add};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
struct Pos(i32, i32);

impl Add for Pos {
    type Output = Self;

    fn add(self, rhs: Self) -> Self::Output {
        Self(self.0 + rhs.0, self.1 + rhs.1)
    }
}

fn main() {
    let input = include_str!("input.txt");

    let mut toggle = false;

    let mut santa = Pos(0, 0);
    let mut robo = Pos(0, 0);

    let mut visited = HashSet::<Pos>::new();

    visited.insert(santa);
    for (i, c) in input.chars().enumerate() {
        let x = match c {
            '>' => Pos(1, 0),
            '<' => Pos(-1, 0),
            '^' => Pos(0, 1),
            'v' => Pos(0, -1),
            _ => Pos(0, 0),
        };

        if toggle {
            robo = robo + x;
            visited.insert(robo);
        } else {
            santa = santa + x;
            visited.insert(santa);
        }

        toggle = !toggle;
    }

    println!("{}", visited.len());
}
