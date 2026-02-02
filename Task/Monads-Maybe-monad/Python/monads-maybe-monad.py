from __future__ import annotations

from abc import ABC
from abc import abstractmethod
from typing import Any
from typing import Callable


class Maybe[T](ABC):
    @abstractmethod
    def is_some(self) -> bool:
        """Return `True` if the option is a `Some`."""

    @abstractmethod
    def is_none(self) -> bool:
        """Return `True` if the option is a `Nothing`."""

    @abstractmethod
    def bind[U](self, func: Callable[[T], Maybe[U]]) -> Maybe[U]:
        """Apply `func` to this value if it's a `Some`."""

    def and_then[U](self, func: Callable[[T], Maybe[U]]) -> Maybe[U]:
        "Alias for `bind`."
        return self.bind(func)

    def __rshift__[U](self, func: Callable[[T], Maybe[U]]) -> Maybe[U]:
        "Alias for `bind`."
        return self.bind(func)

    @abstractmethod
    def or_else(self, func: Callable[[], Maybe[T]]) -> Maybe[T]:
        """Return self if it's a `Some`, otherwise the result of `func`."""


class Some[T](Maybe[T]):
    def __init__(self, value: T) -> None:
        self.value = value

    def __str__(self) -> str:
        return f"Some({self.value!r})"

    def is_some(self) -> bool:
        return True

    def is_none(self) -> bool:
        return False

    def bind[U](self, func: Callable[[T], Maybe[U]]) -> Maybe[U]:
        return func(self.value)

    def or_else(self, func: Callable[[], Maybe[T]]) -> Maybe[T]:
        return self


class Nothing[T](Maybe[T]):
    def __str__(self) -> str:
        return "Nothing()"

    def is_some(self) -> bool:
        return False

    def is_none(self) -> bool:
        return True

    def bind[U](self, func: Callable[[T], Maybe[U]]) -> Maybe[U]:
        return NOTHING

    def or_else(self, func: Callable[[], Maybe[T]]) -> Maybe[T]:
        return func()


NOTHING = Nothing[Any]()


if __name__ == "__main__":

    def plus_one(value: int) -> Maybe[int]:
        return Some(value + 1)

    def currency(value: int) -> Maybe[str]:
        return Some(f"${value}.00")

    values: list[Maybe[int]] = [Some(1), Some(99), NOTHING, Some(4)]

    # Using `>>` as a bind operator
    for value in values:
        result = value >> plus_one >> currency
        print(f"{value} -> {result}")

    print("---")

    # The same, but using lambda functions with the bind method.
    for value in values:
        result = value.bind(lambda v: Some(v + 1)).bind(lambda v: Some(f"${v}.00"))
        print(f"{value} -> {result}")
