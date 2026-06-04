"""Adapter — make an incompatible interface usable via a wrapper."""

from abc import ABC, abstractmethod


class Target(ABC):
    """The interface the client code expects."""

    @abstractmethod
    def request(self, payload: str) -> str:
        ...


class LegacyService:
    """An existing class with an incompatible signature."""

    def handle_legacy(self, data: bytes) -> bytes:
        return b"LEGACY:" + data


class ServiceAdapter(Target):
    """Translates the Target call into LegacyService's API."""

    def __init__(self, adaptee: LegacyService) -> None:
        self._adaptee = adaptee

    def request(self, payload: str) -> str:
        raw = self._adaptee.handle_legacy(payload.encode("utf-8"))
        return raw.decode("utf-8")


def client_code(target: Target) -> None:
    print(target.request("hello"))


if __name__ == "__main__":
    client_code(ServiceAdapter(LegacyService()))
