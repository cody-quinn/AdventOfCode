fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = include_str!("input.txt");
    let mut grid = Box::new([[0; 1000]; 1000]);
    for line in input.lines() {
        let action = line.split_once(' ').unwrap().0;
        let coords = line
            .split_once(' ')
            .unwrap()
            .1
            .split_once(" through ")
            .unwrap();

        let x1 = coords.0.split_once(',').unwrap().0.parse::<i32>()?;
        let y1 = coords.0.split_once(',').unwrap().1.parse::<i32>()?;
        let x2 = coords.1.split_once(',').unwrap().0.parse::<i32>()?;
        let y2 = coords.1.split_once(',').unwrap().1.parse::<i32>()?;

        for x in x1..=x2 {
            for y in y1..=y2 {
                let x = x as usize;
                let y = y as usize;

                match action {
                    "toggle" => grid[x][y] += 2,
                    "on" => grid[x][y] += 1,
                    "off" => {
                        if grid[x][y] > 0 {
                            grid[x][y] -= 1
                        }
                    }
                    _ => continue,
                }
            }
        }
    }

    let mut lit = 0;
    for x in 0..1000 {
        for y in 0..1000 {
            lit += grid[x][y];
        }
    }

    println!("{lit}");

    Ok(())
}
