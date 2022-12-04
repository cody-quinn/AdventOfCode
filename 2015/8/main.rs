fn main() {
    let input = include_str!("input.txt");
    let mut literal = 0;
    let mut strings = 0;
    for (i, line) in input.lines().enumerate() {
        literal += line.len() + 2;
        let mut result = String::new();
        let mut chars = line.chars();
        while let Some(c) = chars.next() {
            result.push(match c {
                '\\' => {
                    let next = chars.next().unwrap();
                    match next {
                        'x' => {
                            chars.next();
                            chars.next();
                            '~'
                        }
                        other => other,
                    }
                }
                other => other,
            });
        }
        strings += result.len();
        if i == 2 {
            println!("{result}");
        }
    }
    let result = literal - strings;
    println!("{result}");
}
