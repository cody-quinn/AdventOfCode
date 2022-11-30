fn main() {
    let input = include_str!("input.txt");

    let depths = input
        .lines()
        .filter_map(|it| it.parse::<i32>().ok())
        .collect::<Vec<_>>();

    let mut increase_count = 0;
    let mut prev_depth = -1;

    for i in 2..depths.len() {
        let depth = depths[i - 2..=i].iter().sum::<i32>();

        if prev_depth == -1 {
            prev_depth = depth;
        }

        if depth > prev_depth {
            increase_count += 1;
        }

        prev_depth = depth;
    }

    println!("{increase_count}");
}
