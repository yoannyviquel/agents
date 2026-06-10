"""Prototype — copy existing objects via a clone interface without coupling to classes."""

from __future__ import annotations

import copy
from abc import ABC, abstractmethod


class Shape(ABC):
    def __init__(self, color: str, tags: list[str] | None = None) -> None:
        self.color = color
        self.tags = tags or []

    @abstractmethod
    def clone(self) -> "Shape":
        ...

    def __str__(self) -> str:
        return f"{type(self).__name__}(color={self.color!r}, tags={self.tags})"


class Circle(Shape):
    def __init__(self, color: str, radius: float, tags: list[str] | None = None) -> None:
        super().__init__(color, tags)
        self.radius = radius

    def clone(self) -> "Circle":
        return copy.deepcopy(self)


class Rectangle(Shape):
    def __init__(self, color: str, w: float, h: float, tags: list[str] | None = None) -> None:
        super().__init__(color, tags)
        self.w, self.h = w, h

    def clone(self) -> "Rectangle":
        return copy.deepcopy(self)


if __name__ == "__main__":
    original = Circle("red", 4.0, tags=["base"])
    copy_ = original.clone()
    copy_.color = "blue"
    copy_.tags.append("derived")
    print("original:", original)
    print("clone:   ", copy_)
