"""Singleton — ensure one instance with a global access point."""

from __future__ import annotations

import threading


class Registry:
    """Thread-safe single instance reached through get_instance()."""

    _instance: "Registry | None" = None
    _lock = threading.Lock()

    def __init__(self) -> None:
        self._entries: dict[str, str] = {}

    @classmethod
    def get_instance(cls) -> "Registry":
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = cls()
        return cls._instance

    def set(self, key: str, value: str) -> None:
        self._entries[key] = value

    def get(self, key: str) -> str | None:
        return self._entries.get(key)


if __name__ == "__main__":
    a = Registry.get_instance()
    a.set("region", "eu-west")
    b = Registry.get_instance()
    print("same object:", a is b)
    print("shared value:", b.get("region"))
