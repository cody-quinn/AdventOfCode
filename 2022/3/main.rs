use std::collections::{HashMap, HashSet};

fn main() {
    let input = include_str!("input.txt");
    let mut sum = 0;

    let mut map = HashMap::<char, i32>::new();
    for (index, line) in input.lines().enumerate() {
        if index % 3 == 0 {
            map = HashMap::new();
        }

        let mut already = HashSet::<char>::new();
        for c in line.chars() {
            if !already.contains(&c) {
                let next = map.get(&c).unwrap_or(&0) + 1;
                map.insert(c, next);
                already.insert(c);
            }
        }

        if index % 3 == 2 {
            for (c, count) in map.iter() {
                if *count == 3 {
                    sum += if c.is_uppercase() {
                        (*c as i32) - 38
                    } else {
                        (*c as i32) - 96
                    };
                }
            }
            println!("{map:?}");
        }
    }
    println!("{sum}");
}
