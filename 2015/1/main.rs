fn main() {
    let input = include_str!("input.txt");
    let mut res = 0;
    for (i, c) in input.chars().enumerate() {
        let x = match c {
            '(' => 1,
            ')' => -1,
            _ => 0,
        };
        res += x;
        if res < 0 {
            println!("Entered basement at {i}");
            break;
        }
    }
    println!("{}", res);
}
