use std::collections::HashMap;

fn main() {
    let input = include_str!("input.txt");

    let program = input
        .lines()
        .filter_map(|it| it.split_once(' '))
        .collect::<Vec<_>>();
    let mut index = 0i64;
    let mut memory = HashMap::<char, i64>::new();

    memory.insert('a', 1);
    memory.insert('b', 0);

    loop {
        if index >= program.len() as i64 {
            break;
        }

        let (instruction, input) = program[index as usize];
        match instruction {
            "hlf" => {
                let addr = input.chars().next().unwrap();
                memory.insert(addr, memory[&addr] / 2);
            }
            "tpl" => {
                let addr = input.chars().next().unwrap();
                memory.insert(addr, memory[&addr] * 3);
            }
            "inc" => {
                let addr = input.chars().next().unwrap();
                memory.insert(addr, memory[&addr] + 1);
            }
            "jmp" => {
                let offset = input.parse::<i64>().unwrap();
                index += offset;
                continue;
            }
            "jie" => {
                let (addr, offset) = input.split_once(", ").unwrap();
                let addr = addr.chars().next().unwrap();
                let offset = offset.parse::<i64>().unwrap();
                if memory[&addr] % 2 == 0 {
                    index += offset;
                    continue;
                }
            }
            "jio" => {
                let (addr, offset) = input.split_once(", ").unwrap();
                let addr = addr.chars().next().unwrap();
                let offset = offset.parse::<i64>().unwrap();
                if memory[&addr] == 1 {
                    index += offset;
                    continue;
                }
            }
            _ => {}
        }

        index += 1;
    }

    println!(
        "{} :: {}",
        memory.get(&'a').unwrap(),
        memory.get(&'b').unwrap()
    );
}
