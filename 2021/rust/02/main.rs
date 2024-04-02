fn main() {
    let input = include_str!("input.txt");

    let mut pos = 0;
    let mut depth = 0;
    let mut aim = 0;

    for line in input.lines() {
        let (action, distance) = line.split_once(' ').unwrap();
        let distance = distance.parse::<u32>().unwrap();

        match action {
            "forward" => {
                pos += distance;
                depth += aim * distance;
            }
            "down" => aim += distance,
            "up" => aim -= distance,
            _ => (),
        }
    }

    println!("{pos} {depth} {aim} {}", pos * depth);
}
