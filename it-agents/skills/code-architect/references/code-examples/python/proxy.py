"""Proxy — a placeholder controlling access to a real object (lazy + caching)."""

from __future__ import annotations

from abc import ABC, abstractmethod


class Resource(ABC):
    @abstractmethod
    def fetch(self, key: str) -> str:
        ...


class RealResource(Resource):
    """Expensive to create and to query."""

    def __init__(self) -> None:
        print("[RealResource] expensive initialization")

    def fetch(self, key: str) -> str:
        return f"value-for-{key}"


class ResourceProxy(Resource):
    """Defers creation until first use and caches results."""

    def __init__(self) -> None:
        self._real: RealResource | None = None
        self._cache: dict[str, str] = {}

    def fetch(self, key: str) -> str:
        if key in self._cache:
            return f"{self._cache[key]} (cached)"
        if self._real is None:
            self._real = RealResource()
        value = self._real.fetch(key)
        self._cache[key] = value
        return value


if __name__ == "__main__":
    proxy = ResourceProxy()
    print(proxy.fetch("alpha"))
    print(proxy.fetch("alpha"))
