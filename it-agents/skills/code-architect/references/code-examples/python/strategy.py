"""Strategy — a family of interchangeable algorithms behind one interface."""

from __future__ import annotations

from abc import ABC, abstractmethod


class SortStrategy(ABC):
    @abstractmethod
    def sort(self, data: list[int]) -> list[int]:
        ...


class AscendingStrategy(SortStrategy):
    def sort(self, data: list[int]) -> list[int]:
        return sorted(data)


class DescendingStrategy(SortStrategy):
    def sort(self, data: list[int]) -> list[int]:
        return sorted(data, reverse=True)


class Processor:
    """Holds a strategy and defers the algorithm choice to it."""

    def __init__(self, strategy: SortStrategy) -> None:
        self._strategy = strategy

    def set_strategy(self, strategy: SortStrategy) -> None:
        self._strategy = strategy

    def run(self, data: list[int]) -> list[int]:
        return self._strategy.sort(data)


if __name__ == "__main__":
    processor = Processor(AscendingStrategy())
    print("asc: ", processor.run([3, 1, 2]))
    processor.set_strategy(DescendingStrategy())
    print("desc:", processor.run([3, 1, 2]))
