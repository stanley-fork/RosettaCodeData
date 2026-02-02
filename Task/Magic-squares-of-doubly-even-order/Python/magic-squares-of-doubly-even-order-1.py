def magic_square_doubly_even(order):
    sq = [list(range(1 + n * order, order + (n * order) + 1)) for n in range(order)]
    n1 = order // 4
    for r in range(n1):
        r1 = reversed(sq[r][n1:-n1])
        r2 = reversed(sq[order - r - 1][n1:-n1])
        sq[r][n1:-n1] = r2
        sq[order - r - 1][n1:-n1] = r1
    for r in range(n1, order - n1):
        r1 = reversed(sq[r][:n1])
        r2 = reversed(sq[order - r - 1][order - n1 :])
        sq[r][:n1] = r2
        sq[order - r - 1][order - n1 :] = r1
    return sq


def display_square(s):
    n = len(s)
    bl = len(str(n**2)) + 1
    for i in range(n):
        print("".join(f"{x:>{bl}}" for x in s[i]))
    print(f"\nMagic constant = {sum(s[0])}")


display_square(magic_square_doubly_even(8))
