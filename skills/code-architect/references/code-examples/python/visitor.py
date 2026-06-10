"""Visitor — separate algorithms from objects via accept/visit (double dispatch)."""

from __future__ import annotations

from abc import ABC, abstractmethod


class Visitor(ABC):
    @abstractmethod
    def visit_text(self, element: "TextElement") -> str:
        ...

    @abstractmethod
    def visit_image(self, element: "ImageElement") -> str:
        ...


class Element(ABC):
    @abstractmethod
    def accept(self, visitor: Visitor) -> str:
        ...


class TextElement(Element):
    def __init__(self, content: str) -> None:
        self.content = content

    def accept(self, visitor: Visitor) -> str:
        return visitor.visit_text(self)


class ImageElement(Element):
    def __init__(self, src: str) -> None:
        self.src = src

    def accept(self, visitor: Visitor) -> str:
        return visitor.visit_image(self)


class HtmlExportVisitor(Visitor):
    def visit_text(self, element: TextElement) -> str:
        return f"<p>{element.content}</p>"

    def visit_image(self, element: ImageElement) -> str:
        return f'<img src="{element.src}"/>'


if __name__ == "__main__":
    elements: list[Element] = [TextElement("hi"), ImageElement("logo.png")]
    visitor = HtmlExportVisitor()
    for element in elements:
        print(element.accept(visitor))
