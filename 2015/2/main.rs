fn main() {
    let input = include_str!("input.txt");
    let mut paper = 0;
    let mut ribbon = 0;
    for line in input.lines() {
        let parts = line.split('x').collect::<Vec<_>>();
        let l = parts[0].parse::<i32>().unwrap();
        let w = parts[1].parse::<i32>().unwrap();
        let h = parts[2].parse::<i32>().unwrap();

        {
            // Paper
            let a = l * w;
            let b = w * h;
            let c = h * l;

            let x = 2 * a + 2 * b + 2 * c;
            let y = [a, b, c].into_iter().min().unwrap();
            paper += x + y;
        }

        {
            // Ribbon
            let mut a = [l, w, h];
            a.sort();

            let x = a[0] * 2 + a[1] * 2;
            let y = l * w * h;
            ribbon += x + y;
        }
    }
    println!("Paper: {paper}\nRibbon: {ribbon}");
}
