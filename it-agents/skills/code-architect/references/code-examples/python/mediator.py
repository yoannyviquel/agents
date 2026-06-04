"""Mediator — centralize communication between components."""

from __future__ import annotations

from abc import ABC, abstractmethod


class Mediator(ABC):
    @abstractmethod
    def notify(self, sender: "Component", event: str) -> None:
        ...


class Component:
    def __init__(self, name: str, mediator: Mediator) -> None:
        self.name = name
        self._mediator = mediator

    def trigger(self, event: str) -> None:
        print(f"{self.name} triggers '{event}'")
        self._mediator.notify(self, event)

    def react(self, event: str) -> None:
        print(f"  -> {self.name} reacts to '{event}'")


class FormMediator(Mediator):
    """Knows the wiring rules so components stay decoupled."""

    def __init__(self) -> None:
        self.button = Component("Button", self)
        self.field = Component("Field", self)
        self.label = Component("Label", self)

    def notify(self, sender: Component, event: str) -> None:
        if sender is self.button and event == "click":
            self.field.react("clear")
            self.label.react("reset")


if __name__ == "__main__":
    form = FormMediator()
    form.button.trigger("click")
