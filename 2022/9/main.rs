#![allow(unused)]

use std::collections::HashSet;

use aoc::parse::Parse;

const TOUCHING: [(i32, i32); 5] = [(0, 0), (0, 1), (-1, 0), (1, 0), (0, -1)];

fn print_graph(head: (i32, i32), tail: (i32, i32), history: &HashSet<(i32, i32)>) {
    for y in -2..8 {
        for x in -2..8 {
            if head == (x, y) {
                print!("H");
            } else if tail == (x, y) {
                print!("T");
            } else if history.contains(&(x, y)) {
                print!("#");
            } else {
                print!(".");
            }
        }
        println!();
    }
    println!();
}

fn challenge(input: &str) {
    let mut head = (0, 0);
    let mut tail = (0, 0);

    let mut tail_history = HashSet::<(i32, i32)>::new();

    for line in input.lines() {
        let (direction, distance) = line.split_once(' ').unwrap();
        let distance = distance.parse::<i32>().unwrap();

        let direction = match direction {
            "U" => (0, 1),
            "L" => (-1, 0),
            "R" => (1, 0),
            "D" => (0, -1),
            _ => (0, 0),
        };

        // Moving the head
        'outer: for i in 0..distance {
            print_graph(head, tail, &tail_history);

            head = (head.0 + direction.0, head.1 + direction.1);

            // Moving the tail
            if head == tail {
                tail_history.insert(tail);
                continue 'outer;
            }

            for y in -1..=1 {
                for x in -1..=1 {
                    let overlap = (tail.0 + x, tail.1 + y);
                    if overlap == head {
                        tail_history.insert(tail);
                        continue 'outer;
                    }
                }
            }

            for dir in TOUCHING {
                let moved_tail = (tail.0 + dir.0, tail.1 + dir.1);
                for dir in TOUCHING {
                    let overlap = (moved_tail.0 + dir.0, moved_tail.1 + dir.1);
                    if overlap == head {
                        tail = moved_tail;
                        tail_history.insert(tail);
                        continue 'outer;
                    }
                }
            }

            for y in -1..=1 {
                for x in -1..=1 {
                    let moved_tail = (tail.0 + x, tail.1 + y);
                    for dir in TOUCHING {
                        let overlap = (moved_tail.0 + dir.0, moved_tail.1 + dir.1);
                        if overlap == head {
                            tail = moved_tail;
                            tail_history.insert(tail);
                            continue 'outer;
                        }
                    }
                }
            }
        }
    }

    let result = tail_history.len();
    println!("{:?}", tail_history);
    println!("{result}");
}

fn main() {
    challenge(include_str!("example.txt"));
    println!();
    // challenge(include_str!("input.txt"));
}
