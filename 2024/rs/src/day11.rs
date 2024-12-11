use std::borrow::Cow;
use std::collections::HashMap;

fn remove_leading_zero<'a>(v: Cow<'a, str>) -> Cow<'a, str> {
    let mut x = v;

    while x.starts_with('0') {
        x = Cow::Owned(x[1..].to_owned());
    }

    if x.is_empty() {
        x = Cow::Borrowed("0")
    }

    x
}

fn blinkn<'a>(
    stone: Cow<'a, str>,
    n: usize,
    cache: &mut HashMap<usize, HashMap<String, u64>>,
) -> u64 {
    if let Some(v) = cache.get(&n).and_then(|v| v.get(stone.as_ref())) {
        return *v;
    }

    let res = if n == 0 {
        1
    } else if stone == "0" {
        blinkn(Cow::Borrowed("1"), n - 1, cache)
    } else if stone.len() % 2 == 0 {
        let a = Cow::Borrowed(&stone[..stone.len() / 2]);
        let b = remove_leading_zero(Cow::Borrowed(&stone[stone.len() / 2..]));

        blinkn(a, n - 1, cache) + blinkn(b, n - 1, cache)
    } else {
        blinkn(
            Cow::Owned((stone.parse::<u64>().unwrap() * 2024).to_string()),
            n - 1,
            cache,
        )
    };

    cache
        .entry(n)
        .or_insert(HashMap::new())
        .insert(stone.to_string(), res);

    res
}

pub fn run() {
    let input = std::fs::read_to_string("../.input.txt").unwrap();

    let mut cache = HashMap::new();

    let res = input
        .split(' ')
        .map(|v| blinkn(Cow::Borrowed(v), 75, &mut cache))
        .sum::<u64>();

    println!("{}", res);
}
