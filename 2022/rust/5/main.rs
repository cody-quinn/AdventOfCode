#![allow(unused)]

use aoc::parse::Parse;
use itertools::Itertools;

fn main() {
    let input = include_str!("input.txt");

    let mut crates = [
        "FTNZMGHJ".chars().rev().collect::<Vec<_>>(),
        "JWV".chars().rev().collect::<Vec<_>>(),
        "HTBJLVG".chars().rev().collect::<Vec<_>>(),
        "LVDCNJPB".chars().rev().collect::<Vec<_>>(),
        "GRPMSWF".chars().rev().collect::<Vec<_>>(),
        "MVNBFCHG".chars().rev().collect::<Vec<_>>(),
        "RMGHD".chars().rev().collect::<Vec<_>>(),
        "DZVMNH".chars().rev().collect::<Vec<_>>(),
        "HFNG".chars().rev().collect::<Vec<_>>(),
    ];

    // let mut crates = [
    //     "NZ".chars().rev().collect::<Vec<_>>(),
    //     "DCM".chars().rev().collect::<Vec<_>>(),
    //     "P".chars().rev().collect::<Vec<_>>(),
    // ];

    'outer: for (lc, line) in input.lines().enumerate() {
        let (amount, from, to) = line
            .split(' ')
            .collect_tuple::<(&str, &str, &str)>()
            .unwrap()
            .parse::<usize>()
            .unwrap();

        let mut working = Vec::<char>::new();
        for i in 0..amount {
            let x = crates[from - 1].pop().unwrap();
            // crates[to - 1].push(x);
            working.push(x);
        }
        for c in working.iter().rev() {
            crates[to - 1].push(*c);
        }
    }

    for (i, c) in crates.iter().enumerate() {
        println!("{i}: {}", c.iter().join(""));
    }
}
