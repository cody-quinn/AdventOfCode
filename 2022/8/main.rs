#![allow(unused)]
#![allow(clippy::needless_range_loop)]

use aoc::parse::Parse;

fn main() {
    let rows = include_str!("input.txt")
        .lines()
        .map(|it| it.chars().collect::<Vec<_>>())
        .collect::<Vec<_>>();
    let mut result = 0;
    let mut highest_scenic = 0;

    for y in 1..rows.len() - 1 {
        let col = &rows[y];
        'outer: for x in 1..col.len() - 1 {
            let house = col[x].to_digit(10).unwrap();

            // left
            let mut left_taller = false;
            let mut left_score = 0;
            for x1 in (0..x).rev() {
                let neighbor = col[x1].to_digit(10).unwrap();
                left_score += 1;
                if neighbor >= house {
                    left_taller = true;
                    break;
                }
            }

            // right
            let mut right_taller = false;
            let mut right_score = 0;
            for x1 in (x + 1)..col.len() {
                let neighbor = col[x1].to_digit(10).unwrap();
                right_score += 1;
                if neighbor >= house {
                    right_taller = true;
                    break;
                }
            }

            // up
            let mut up_taller = false;
            let mut up_score = 0;
            for y1 in (0..y).rev() {
                let neighbor = rows[y1][x].to_digit(10).unwrap();
                up_score += 1;
                if neighbor >= house {
                    up_taller = true;
                    break;
                }
            }

            // down
            let mut down_taller = false;
            let mut down_score = 0;
            for y1 in (y + 1)..rows.len() {
                let neighbor = rows[y1][x].to_digit(10).unwrap();
                down_score += 1;
                if neighbor >= house {
                    down_taller = true;
                    break;
                }
            }

            if !left_taller || !right_taller || !up_taller || !down_taller {
                result += 1;
            }

            let score = left_score * right_score * up_score * down_score;
            if highest_scenic < score {
                println!("New heighest scenic score: {x} {y} -- {score} -- {up_score} {left_score} {right_score} {down_score}");
                highest_scenic = score;
            }
        }
    }

    result += (rows.len() * 2) + (rows[0].len() * 2) - 4;

    println!("{result} {highest_scenic}");
}
