use aoc::parse::Parse;

fn main() {
    let input = include_str!("input.txt");
    let mut contains = 0;
    'outer: for line in input.lines() {
        let (lhs, rhs) = line.split_once(',').unwrap();
        let (lhs_min, lhs_max) = lhs.split_once('-').unwrap().parse::<i32>().unwrap();
        let (rhs_min, rhs_max) = rhs.split_once('-').unwrap().parse::<i32>().unwrap();

        for i in lhs_min..=lhs_max {
            for j in rhs_min..=rhs_max {
                if i == j {
                    contains += 1;
                    continue 'outer;
                }
            }
        }
    }
    println!("{contains}");
}
