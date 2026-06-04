"""Command — encapsulate a request as an object, support undo."""

from __future__ import annotations

from abc import ABC, abstractmethod


class Counter:
    """The receiver that actually performs the work."""

    def __init__(self) -> None:
        self.value = 0


class Command(ABC):
    @abstractmethod
    def execute(self) -> None:
        ...

    @abstractmethod
    def undo(self) -> None:
        ...


class AddCommand(Command):
    def __init__(self, counter: Counter, delta: int) -> None:
        self._counter = counter
        self._delta = delta

    def execute(self) -> None:
        self._counter.value += self._delta

    def undo(self) -> None:
        self._counter.value -= self._delta


class Invoker:
    """Runs commands and keeps a history for undo."""

    def __init__(self) -> None:
        self._history: list[Command] = []

    def run(self, command: Command) -> None:
        command.execute()
        self._history.append(command)

    def undo_last(self) -> None:
        if self._history:
            self._history.pop().undo()


if __name__ == "__main__":
    counter = Counter()
    invoker = Invoker()
    invoker.run(AddCommand(counter, 5))
    invoker.run(AddCommand(counter, 3))
    print("after two adds:", counter.value)
    invoker.undo_last()
    print("after undo:    ", counter.value)
