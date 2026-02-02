from __future__ import print_function, division

WIDTH = 81
HEIGHT = 5

lines = []

def cantor(start, len, index):
    seg = len // 3 # from division
    if seg == 0:
        return None
    for it in range(HEIGHT - index):
        i = index + it
        for jt in range(seg):
            j = start + seg + jt
            pos = i * WIDTH + j
            lines[pos] = ' '
    cantor(start,           seg, index + 1)
    cantor(start + seg * 2, seg, index + 1)
    return None

lines = ['*'] * (WIDTH * HEIGHT)
cantor(0, WIDTH, 1)

for i in range(HEIGHT):
    beg = WIDTH * i
    print(''.join(lines[beg : beg + WIDTH]))  # from print_function
