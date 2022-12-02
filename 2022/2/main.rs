fn main() {
    let input = include_str!("input.txt");
    let mut points = 0;
    for line in input.lines() {
        let (lhs, rhs) = line.split_once(' ').unwrap();
        let lhs = match lhs {
            "A" => 1, // r
            "B" => 2, // p
            "C" => 3, // s
            _ => panic!(),
        };
        let rhs = match rhs {
            "X" => {
                // loose
                if lhs == 1 {
                    3
                } else if lhs == 2 {
                    1
                } else if lhs == 3 {
                    2
                } else {
                    panic!("ouch")
                }
            }
            "Y" => lhs,
            "Z" => {
                // win
                if lhs == 1 {
                    2
                } else if lhs == 2 {
                    3
                } else if lhs == 3 {
                    1
                } else {
                    panic!("ouch")
                }
            }
            _ => panic!(),
        };

        if rhs == 1 && lhs == 3 || rhs == 2 && lhs == 1 || rhs == 3 && lhs == 2 {
            points += 6;
        } else if rhs == lhs {
            points += 3;
        }

        points += rhs;
    }
    println!("{points}");
}
