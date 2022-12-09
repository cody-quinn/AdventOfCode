#![allow(unused)]

use std::collections::HashSet;

use aoc::parse::Parse;

// Change this to 2 for part 1, and 10 for part 2
const KNOTS: usize = 10;

const ADJACENT: [(i32, i32); 5] = [(0, 0), (0, 1), (-1, 0), (1, 0), (0, -1)];
const DIAGONAL: [(i32, i32); 5] = [(0, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)];

const NEIGHBORS: [(i32, i32); 9] = [
    (0, 0),
    (0, 1),
    (-1, 0),
    (1, 0),
    (0, -1),
    (-1, -1),
    (-1, 1),
    (1, -1),
    (1, 1),
];

fn print_graph(rope: &[(i32, i32)], history: &HashSet<(i32, i32)>) {
    for y in (-16..16).rev() {
        'outer: for x in -16..16 {
            for (index, knot) in rope.iter().enumerate() {
                if *knot == (x, y) {
                    print!("{index}");
                    continue 'outer;
                }
            }

            if history.contains(&(x, y)) {
                print!("#");
            } else {
                print!(".");
            }
        }
        println!();
    }
    println!();
}

fn challenge(input: &str, debug: bool) {
    let mut rope = [(0, 0); KNOTS];
    let mut history = HashSet::<(i32, i32)>::new();

    // Print the starting graph
    if debug {
        print_graph(&rope, &history);
    }

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
        for _ in 0..distance {
            // Moving the head knot
            rope[0] = (rope[0].0 + direction.0, rope[0].1 + direction.1);

            for index in 1..rope.len() {
                let parent = rope[index - 1];
                let knot = rope[index];

                // Creating an inner scope so we can easily break from it
                let moved_knot = 'inner: {
                    // Checking if the knot is touching its parent
                    for y in -1..=1 {
                        for x in -1..=1 {
                            let test = (knot.0 + x, knot.1 + y);
                            if test == parent {
                                break 'inner knot;
                            }
                        }
                    }

                    // Checking if the knot can be moved adjacently
                    for direction in ADJACENT {
                        let moved_knot = (knot.0 + direction.0, knot.1 + direction.1);
                        for direction in ADJACENT {
                            let test = (moved_knot.0 + direction.0, moved_knot.1 + direction.1);
                            if test == parent {
                                break 'inner moved_knot;
                            }
                        }
                    }

                    // Checking if the knot can be moved diagonally
                    for direction in DIAGONAL {
                        let moved_knot = (knot.0 + direction.0, knot.1 + direction.1);
                        for direction in NEIGHBORS {
                            let test = (moved_knot.0 + direction.0, moved_knot.1 + direction.1);
                            if test == parent {
                                break 'inner moved_knot;
                            }
                        }
                    }

                    knot
                };

                rope[index] = moved_knot;
            }

            // Finally printing the graph and updating the
            history.insert(rope[rope.len() - 1]);

            if debug {
                print_graph(&rope, &history);
            }
        }
    }

    let result = history.len();
    println!("{result}");
}

fn main() {
    println!("Sample Set: ");
    challenge(include_str!("example.txt"), true);
    println!("\nReal Set: ");
    challenge(include_str!("input.txt"), false);
}
