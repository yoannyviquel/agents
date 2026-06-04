"""State — let an object alter behavior when its state changes (state objects)."""

from __future__ import annotations

from abc import ABC, abstractmethod


class State(ABC):
    @abstractmethod
    def push(self, machine: "Turnstile") -> None:
        ...

    @abstractmethod
    def pay(self, machine: "Turnstile") -> None:
        ...


class LockedState(State):
    def push(self, machine: "Turnstile") -> None:
        print("Locked: cannot pass")

    def pay(self, machine: "Turnstile") -> None:
        print("Payment accepted -> unlocking")
        machine.state = UnlockedState()


class UnlockedState(State):
    def push(self, machine: "Turnstile") -> None:
        print("Passing through -> locking")
        machine.state = LockedState()

    def pay(self, machine: "Turnstile") -> None:
        print("Already unlocked")


class Turnstile:
    """Context that delegates behavior to its current state."""

    def __init__(self) -> None:
        self.state: State = LockedState()

    def push(self) -> None:
        self.state.push(self)

    def pay(self) -> None:
        self.state.pay(self)


if __name__ == "__main__":
    gate = Turnstile()
    gate.push()
    gate.pay()
    gate.push()
