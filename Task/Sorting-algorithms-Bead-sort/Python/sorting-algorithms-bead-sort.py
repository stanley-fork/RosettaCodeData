import random
from itertools import zip_longest

def beadsort(l: list[int]) -> list[int]:
    transposed = list(map(sum, zip_longest(*[[1] * e for e in l], fillvalue=0)))
    return [sum(n > i for n in transposed) for i in range(len(l))]

def test_beadsort() -> None:
    for _ in range(100):
        ints = [random.randint(0, 50) for _ in range(random.randint(0, 10))]
        assert beadsort(ints) == sorted(ints, reverse=True)

if __name__ == "__main__":
    test_beadsort()
    print(beadsort([5, 3, 1, 7, 4, 1, 1]))
