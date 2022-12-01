fn main() {
    let input = include_str!("input.txt");
    let mut elves = Vec::<u64>::new();
    let mut current = 0;
    for line in input.lines() {
        if line.is_empty() {
            elves.push(current);
            current = 0;
            continue;
        }

        current += line.parse::<u64>().unwrap();
    }
    elves.sort();
    elves.reverse();
    println!("{}", elves[0] + elves[1] + elves[2]);
}
