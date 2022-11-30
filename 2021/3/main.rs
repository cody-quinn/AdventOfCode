fn main() {
    let input = include_str!("input.txt");
    let mut count = [0; 12];

    for line in input.lines() {
        for (x, c) in line.chars().enumerate() {
            match c {
                '1' => count[x] += 1,
                '0' => count[x] -= 1,
                _ => continue,
            }
        }
    }

    let gamma = {
        let mut raw = String::new();
        for c in count {
            if c > 0 {
                raw.push('1');
            } else {
                raw.push('0');
            }
        }
        u32::from_str_radix(&raw, 2).unwrap()
    };

    let epsilon = {
        let mut raw = String::new();
        for c in count {
            if c < 0 {
                raw.push('1');
            } else {
                raw.push('0');
            }
        }
        u32::from_str_radix(&raw, 2).unwrap()
    };

    let result = gamma * epsilon;
    println!("{result}");
}
