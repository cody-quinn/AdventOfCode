pub mod pos;

#[macro_export]
macro_rules! map {
    ($($key:expr => $value:expr),* $(,)?) => {
        {
            use std::collections::HashMap;
            let mut map = HashMap::new();
            $(
                map.insert($key, $value);
            )*
            map
        }
    };
}
