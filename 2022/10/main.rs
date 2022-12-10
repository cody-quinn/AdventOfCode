use std::fmt::Write;

fn problem(input: &str) -> Result<String, Box<dyn std::error::Error>> {
    let mut schedule = Vec::<i32>::new();
    for line in input.lines() {
        match line.split(' ').collect::<Vec<_>>()[..] {
            ["noop"] => schedule.push(0),
            ["addx", value] => {
                let value = value.parse::<i32>()?;
                schedule.push(0);
                schedule.push(value);
            }
            _ => continue,
        }
    }

    let mut image = String::new();
    let mut register = 1i32;
    for (cycle, value) in schedule.iter().enumerate() {
        let cycle = cycle as i32 % 40;

        if cycle == 0 {
            writeln!(&mut image)?;
        }

        if (register - 1..(register + 2)).contains(&cycle) {
            write!(&mut image, "#")?;
        } else {
            write!(&mut image, ".")?;
        }

        register += value;
    }

    Ok(image)
}

fn main() {
    let result1 = problem(include_str!("example.txt")).unwrap();
    let result2 = problem(include_str!("input.txt")).unwrap();
    println!("Example Set: {}\n\nProblem Set: {}", result1, result2);
}
