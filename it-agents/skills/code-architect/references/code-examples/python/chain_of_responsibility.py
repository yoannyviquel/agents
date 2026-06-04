"""Chain of Responsibility — pass a request along a chain of handlers."""

from __future__ import annotations

from abc import ABC, abstractmethod


class Handler(ABC):
    def __init__(self) -> None:
        self._next: Handler | None = None

    def set_next(self, handler: "Handler") -> "Handler":
        self._next = handler
        return handler

    def handle(self, amount: int) -> str | None:
        if self._next is not None:
            return self._next.handle(amount)
        return None

    @abstractmethod
    def can_handle(self, amount: int) -> bool:
        ...


class TierHandler(Handler):
    def __init__(self, name: str, limit: int) -> None:
        super().__init__()
        self._name = name
        self._limit = limit

    def can_handle(self, amount: int) -> bool:
        return amount <= self._limit

    def handle(self, amount: int) -> str | None:
        if self.can_handle(amount):
            return f"{self._name} approved {amount}"
        return super().handle(amount)


if __name__ == "__main__":
    clerk = TierHandler("Clerk", 100)
    manager = TierHandler("Manager", 1000)
    director = TierHandler("Director", 10000)
    clerk.set_next(manager).set_next(director)

    for amount in (50, 750, 5000, 99999):
        print(clerk.handle(amount) or f"No tier can approve {amount}")
