"""Observer — subscription mechanism to notify subscribers of events."""

from __future__ import annotations

from abc import ABC, abstractmethod


class Observer(ABC):
    @abstractmethod
    def update(self, value: int) -> None:
        ...


class Subject:
    """Maintains subscribers and broadcasts state changes."""

    def __init__(self) -> None:
        self._observers: list[Observer] = []
        self._value = 0

    def subscribe(self, observer: Observer) -> None:
        self._observers.append(observer)

    def unsubscribe(self, observer: Observer) -> None:
        self._observers.remove(observer)

    def set_value(self, value: int) -> None:
        self._value = value
        for observer in self._observers:
            observer.update(value)


class LoggingObserver(Observer):
    def __init__(self, name: str) -> None:
        self._name = name

    def update(self, value: int) -> None:
        print(f"{self._name} saw value {value}")


if __name__ == "__main__":
    subject = Subject()
    subject.subscribe(LoggingObserver("A"))
    subject.subscribe(LoggingObserver("B"))
    subject.set_value(42)
