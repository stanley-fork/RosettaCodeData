"""Matrix multiplication using Strassen's algorithm. Requires Python >= 3.10."""

from __future__ import annotations

from collections.abc import MutableSequence
from itertools import chain
from typing import Iterable
from typing import Iterator
from typing import NamedTuple
from typing import TypeAlias
from typing import cast
from typing import overload

N: TypeAlias = int | float
Row: TypeAlias = list[N]


class Matrix(MutableSequence[Row]):
    def __init__(self, data: Iterable[Iterable[N]] | None = None) -> None:
        if data is None:
            self._data: list[Row] = []
        else:
            self._data = [list(row) for row in data]

    @overload
    def __getitem__(self, index: int) -> Row: ...
    @overload
    def __getitem__(self, index: slice) -> Matrix: ...

    def __getitem__(self, index: int | slice) -> Row | Matrix:
        if isinstance(index, slice):
            return Matrix(self._data[index])
        return self._data[index]

    @overload
    def __setitem__(self, index: int, value: Row) -> None: ...
    @overload
    def __setitem__(self, index: slice, value: Iterable[Row]) -> None: ...

    def __setitem__(self, index: int | slice, value: Row | Iterable[Row]) -> None:
        if isinstance(index, slice):
            rows = [list(row) for row in cast(Iterable[Row], value)]
            self._data[index] = rows
        else:
            if not isinstance(value, list):
                raise TypeError("single row assignment requires a list of int or float")
            self._data[index] = value

    def __delitem__(self, index: int | slice) -> None:
        del self._data[index]

    def __len__(self) -> int:
        return len(self._data)

    def insert(self, index: int, value: Row) -> None:
        self._data.insert(index, value)

    def __iter__(self) -> Iterator[Row]:
        return iter(self._data)

    def __repr__(self) -> str:
        return f"Matrix({self._data!r})"

    @classmethod
    def block(cls, blocks) -> Matrix:
        """Return a new Matrix assembled from nested blocks."""
        m = Matrix()
        for hblock in blocks:
            for row in zip(*hblock):
                m.append(list(chain.from_iterable(row)))

        return m

    def dot(self, b: Matrix) -> Matrix:
        """Return a new Matrix that is the product of this matrix and matrix `b`.

        Uses 'simple' or 'naive' matrix multiplication.
        """
        assert self.shape.cols == b.shape.rows
        m = Matrix()
        for row in self:
            new_row = []
            for c in range(len(b[0])):
                col = [b[r][c] for r in range(len(b))]
                new_row.append(sum(x * y for x, y in zip(row, col)))
            m.append(new_row)
        return m

    def __matmul__(self, b: Matrix) -> Matrix:
        return self.dot(b)

    def __add__(self, b: Matrix) -> Matrix:
        """Matrix addition."""
        assert self.shape == b.shape
        rows, cols = self.shape
        return Matrix(
            [[self[i][j] + b[i][j] for j in range(cols)] for i in range(rows)]
        )

    def __sub__(self, b: Matrix) -> Matrix:
        """Matrix subtraction."""
        assert self.shape == b.shape
        rows, cols = self.shape
        return Matrix(
            [[self[i][j] - b[i][j] for j in range(cols)] for i in range(rows)]
        )

    def strassen(self, b: Matrix) -> Matrix:
        """Return a new Matrix that is the product of this matrix and matrix `b`.

        Uses strassen's algorithm.
        """
        rows, cols = self.shape

        assert rows == cols, "matrices must be square"
        assert self.shape == b.shape, "matrices must be the same shape"
        assert rows and (rows & rows - 1) == 0, "shape must be a power of 2"

        if rows == 1:
            return self.dot(b)

        p = rows // 2  # partition

        a11 = Matrix([n[:p] for n in self[:p]])
        a12 = Matrix([n[p:] for n in self[:p]])
        a21 = Matrix([n[:p] for n in self[p:]])
        a22 = Matrix([n[p:] for n in self[p:]])

        b11 = Matrix([n[:p] for n in b[:p]])
        b12 = Matrix([n[p:] for n in b[:p]])
        b21 = Matrix([n[:p] for n in b[p:]])
        b22 = Matrix([n[p:] for n in b[p:]])

        m1 = (a11 + a22).strassen(b11 + b22)
        m2 = (a21 + a22).strassen(b11)
        m3 = a11.strassen(b12 - b22)
        m4 = a22.strassen(b21 - b11)
        m5 = (a11 + a12).strassen(b22)
        m6 = (a21 - a11).strassen(b11 + b12)
        m7 = (a12 - a22).strassen(b21 + b22)

        c11 = m1 + m4 - m5 + m7
        c12 = m3 + m5
        c21 = m2 + m4
        c22 = m1 - m2 + m3 + m6

        return Matrix.block([[c11, c12], [c21, c22]])

    def round(self, ndigits: int | None = None) -> Matrix:
        return Matrix([[round(i, ndigits) for i in row] for row in self])

    @property
    def shape(self) -> Shape:
        cols = len(self[0]) if self else 0
        return Shape(len(self), cols)


class Shape(NamedTuple):
    rows: int
    cols: int


def examples():
    a = Matrix(
        [
            [1, 2],
            [3, 4],
        ]
    )
    b = Matrix(
        [
            [5, 6],
            [7, 8],
        ]
    )
    c = Matrix(
        [
            [1, 1, 1, 1],
            [2, 4, 8, 16],
            [3, 9, 27, 81],
            [4, 16, 64, 256],
        ]
    )
    d = Matrix(
        [
            [4, -3, 4 / 3, -1 / 4],
            [-13 / 3, 19 / 4, -7 / 3, 11 / 24],
            [3 / 2, -2, 7 / 6, -1 / 4],
            [-1 / 6, 1 / 4, -1 / 6, 1 / 24],
        ]
    )
    e = Matrix(
        [
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12],
            [13, 14, 15, 16],
        ]
    )
    f = Matrix(
        [
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1],
        ]
    )

    print("Naive matrix multiplication:")
    print(f"  a * b = {a @ b}")
    print(f"  c * d = {(c @ d).round()}")
    print(f"  e * f = {e @ f}")

    print("Strassen's matrix multiplication:")
    print(f"  a * b = {a.strassen(b)}")
    print(f"  c * d = {c.strassen(d).round()}")
    print(f"  e * f = {e.strassen(f)}")


if __name__ == "__main__":
    examples()
