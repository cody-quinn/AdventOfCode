use crypto::{digest::Digest, md5::Md5};

fn main() {
    let input = "yzbqklnj";

    let mut x = 0;
    loop {
        let hash_input = format!("{input}{x}");

        let mut hasher = Md5::new();
        hasher.input(hash_input.as_bytes());
        let result = hasher.result_str();

        let s = &result[0..6].chars().all(|it| it == '0');

        if *s {
            break;
        }

        x += 1;
    }

    println!("{}", x);
}
