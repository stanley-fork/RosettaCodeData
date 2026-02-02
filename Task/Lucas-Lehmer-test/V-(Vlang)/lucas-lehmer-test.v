import math.big
import os

const primes = [u32(3), 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47,
    53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127]

const mersennes = [u32(521), 607, 1279, 2203, 2281, 3217, 4253, 4423] // can add more per hardware and time

fn main() {
    ll_test(primes)
    println("")
    ll_test(mersennes)
}

fn ll_test(ps []u32) {
    mut s, mut m := big.zero_int, big.zero_int
    one := big.one_int
    two := big.two_int
    for p in ps {
        s = big.integer_from_int(4)
        m = one.left_shift(p) - one
        for i := u32(2); i < p; i++ {
            s = (s * s - two) % m
        }
        if s.bit_len() == 0 {
            print("M$p ")
            os.flush()
        }
    }
}
