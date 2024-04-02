#![allow(unused)]

use std::collections::HashMap;

use aoc::{map, parse::Parse};
use itertools::Itertools;

#[derive(Debug, Default)]
struct Node {
    children: HashMap<String, Node>,
    files: HashMap<String, i32>,
}

impl Node {
    pub fn get_child<'a>(&'a mut self, path: &[&str]) -> &'a mut Node {
        if path.is_empty() {
            return self;
        }
        match self.children.get_mut(path[0]) {
            Some(it) => {
                if path.len() > 1 {
                    return it.get_child(&path[1..]);
                } else {
                    return it;
                }
            }
            None => todo!(),
        }
        todo!("pog");
    }

    pub fn get_size(&self) -> i32 {
        let mut size = self.children.values().map(|it| it.get_size()).sum();
        size += self.files.values().sum::<i32>();
        size
    }

    pub fn get_answer(&self, mut answer: Vec<i32>) -> Vec<i32> {
        let size = self.get_size();
        answer.push(size);

        for subdir in self.children.values() {
            answer = subdir.get_answer(answer);
        }

        answer
    }
}

fn main() {
    let input = include_str!("input.txt");

    let mut path = Vec::<&str>::new();
    let mut root = Node::default();

    // Processing into thing
    let mut current_dir = Vec::<&str>::new();
    for line in input.lines() {
        if let Some(dir) = line.strip_prefix("$ cd ") {
            match dir {
                "/" => current_dir = Vec::new(),
                ".." => {
                    current_dir.pop();
                }
                dir => current_dir.push(dir),
            }
        }

        if line.starts_with('$') {
            continue;
        }

        let (size, name) = line.split_once(' ').unwrap();
        println!("{current_dir:?}");
        if size == "dir" {
            let mut current = root.get_child(&current_dir);
            current.children.insert(name.to_string(), Node::default());
        } else {
            let size = size.parse::<i32>().unwrap();
            let mut current = root.get_child(&current_dir);
            current.files.insert(name.to_string(), size);
        }
    }

    let min = 30_000_000 - (70_000_000 - root.get_size());
    println!("{min}");
    let thing = root.get_answer(Vec::new());
    let thing2 = {
        let mut thing = thing.clone();
        thing.sort();
        thing.into_iter().find(|it| *it > min)
    };
    println!(
        "{} {:?}",
        thing.iter().filter(|it| **it < 100_000).sum::<i32>(),
        thing2
    );
}
