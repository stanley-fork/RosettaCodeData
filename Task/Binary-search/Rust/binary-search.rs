fn binary_search<T:PartialOrd>(searchvalue: T, v: &[T] ) -> Option<usize> {
    let mut lower = 0 as usize;
    let mut upper = v.len();
    while upper > lower {
        let mid = lower + (upper - lower) / 2;
        if v[mid] == searchvalue {
            return Some(mid);
        } else if searchvalue < v[mid] {
            upper = mid;
        } else {
            lower = mid + 1;
        }
    }
    None
}
