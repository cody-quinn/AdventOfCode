fn main() {
    let input = include_str!("input.txt");
    let mut result = 0;

    'outer: for line in input.lines() {
        let mut vowels = 0;
        let mut doubles = 0;

        let mut chars = line.chars().peekable();

        loop {
            let Some(c) = chars.next() else {
                break;
            };

            if matches!(c, 'a' | 'e' | 'i' | 'o' | 'u') {
                vowels += 1;
            }

            if let Some(next) = chars.peek() {
                if c == *next {
                    doubles += 1;
                }

                match format!("{c}{next}").as_str() {
                    "ab" | "cd" | "pq" | "xy" => continue 'outer,
                    _ => (),
                }
            }
        }

        if vowels >= 3 && doubles >= 1 {
            result += 1;
        }
    }
    println!("{result}");
}
