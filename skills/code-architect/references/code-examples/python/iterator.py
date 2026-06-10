"""Iterator — traverse a collection without exposing its representation."""

from __future__ import annotations

from collections.abc import Iterator
from typing import Generic, TypeVar

T = TypeVar("T")


class RingBuffer(Generic[T]):
    """A fixed-size buffer whose internal storage stays hidden."""

    def __init__(self, capacity: int) -> None:
        self._slots: list[T | None] = [None] * capacity
        self._head = 0
        self._count = 0

    def push(self, item: T) -> None:
        idx = (self._head + self._count) % len(self._slots)
        self._slots[idx] = item
        if self._count < len(self._slots):
            self._count += 1
        else:
            self._head = (self._head + 1) % len(self._slots)

    def __iter__(self) -> Iterator[T]:
        for i in range(self._count):
            item = self._slots[(self._head + i) % len(self._slots)]
            assert item is not None
            yield item


if __name__ == "__main__":
    buffer: RingBuffer[int] = RingBuffer(3)
    for n in (1, 2, 3, 4):
        buffer.push(n)
    print("oldest-to-newest:", list(buffer))
