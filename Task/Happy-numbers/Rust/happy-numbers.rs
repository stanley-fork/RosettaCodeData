fn sumsqd(mut n: i32) -> i32 {
    let mut sq = 0;
    while n > 0 {
        let d = n % 10;
        sq += d * d;
        n /= 10;
    }
    sq
}

fn cycle<T, F>(a: T, f: F) -> T
where
    T: Copy + PartialEq,
    F: Fn(T) -> T,
{
    let mut t = a;
    let mut h = f(a);

    while t != h {
        t = f(t);
        h = f(f(h));
    }
    t
}

fn ishappy(n: i32) -> bool {
    cycle(n, sumsqd) == 1
}

fn main() {
    let happy: Vec<i32> = (1..)
        .filter(|&n| ishappy(n))
        .take(8)
        .collect();

    println!("{:?}", happy);
}
