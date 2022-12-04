use std::str::FromStr;

pub trait Parse {
    type Output<F: FromStr>;

    fn parse<F: FromStr>(&self) -> Result<Self::Output<F>, F::Err>;
}

macro_rules! parse_tuples {
    ($($i1:ident)*, $($i2:ident)*, $($i3:tt)*) => {
        impl Parse for ($(& $i2),*) {
            type Output<F: FromStr> = ($($i1),*);

            fn parse<F: FromStr>(&self) -> Result<Self::Output<F>, F::Err> {
                Ok((
                    $(
                        self.$i3.parse::<$i1>()?
                    ),*
                ))
            }
        }
    };
}

parse_tuples!(F F, str str, 0 1);
parse_tuples!(F F F, str str str, 0 1 2);
parse_tuples!(F F F F, str str str str, 0 1 2 3);
parse_tuples!(F F F F F, str str str str str, 0 1 2 3 4);
parse_tuples!(F F F F F F, str str str str str str, 0 1 2 3 4 5);
parse_tuples!(F F F F F F F, str str str str str str str, 0 1 2 3 4 5 6);
parse_tuples!(F F F F F F F F, str str str str str str str str, 0 1 2 3 4 5 6 7);
parse_tuples!(F F F F F F F F F, str str str str str str str str str, 0 1 2 3 4 5 6 7 8);
parse_tuples!(F F F F F F F F F F, str str str str str str str str str str, 0 1 2 3 4 5 6 7 8 9);
