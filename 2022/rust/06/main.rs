#![allow(unused)]

use aoc::parse::Parse;
use itertools::Itertools;

fn main() {
    let input = include_str!("input.txt");

    let mut chars = input.chars().collect::<Vec<_>>();
    for index in 14..chars.len() {
        let mut prev4 = Vec::from(&chars[(index - 14)..index]);
        prev4.sort();
        prev4.dedup();
        if prev4.len() == 14 {
            println!("{index}");
            break;
        }
    }
}
