"""Composite — compose objects into trees, treat leaf and container uniformly."""

from __future__ import annotations

from abc import ABC, abstractmethod


class Node(ABC):
    @abstractmethod
    def size(self) -> int:
        ...

    @abstractmethod
    def render(self, indent: int = 0) -> str:
        ...


class FileLeaf(Node):
    def __init__(self, name: str, size: int) -> None:
        self.name = name
        self._size = size

    def size(self) -> int:
        return self._size

    def render(self, indent: int = 0) -> str:
        return f"{'  ' * indent}- {self.name} ({self._size})"


class FolderComposite(Node):
    def __init__(self, name: str) -> None:
        self.name = name
        self._children: list[Node] = []

    def add(self, node: Node) -> "FolderComposite":
        self._children.append(node)
        return self

    def size(self) -> int:
        return sum(child.size() for child in self._children)

    def render(self, indent: int = 0) -> str:
        lines = [f"{'  ' * indent}+ {self.name}/ ({self.size()})"]
        lines += [child.render(indent + 1) for child in self._children]
        return "\n".join(lines)


if __name__ == "__main__":
    root = FolderComposite("root")
    root.add(FileLeaf("a.txt", 10))
    sub = FolderComposite("sub").add(FileLeaf("b.txt", 5)).add(FileLeaf("c.txt", 7))
    root.add(sub)
    print(root.render())
