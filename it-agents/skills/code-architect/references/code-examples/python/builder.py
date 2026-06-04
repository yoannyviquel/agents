"""Builder — construct complex objects step by step."""

from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass, field


@dataclass
class Document:
    sections: list[str] = field(default_factory=list)

    def render(self) -> str:
        return "\n".join(self.sections)


class DocumentBuilder(ABC):
    @abstractmethod
    def add_title(self, text: str) -> "DocumentBuilder":
        ...

    @abstractmethod
    def add_paragraph(self, text: str) -> "DocumentBuilder":
        ...

    @abstractmethod
    def build(self) -> Document:
        ...


class PlainTextBuilder(DocumentBuilder):
    def __init__(self) -> None:
        self._doc = Document()

    def add_title(self, text: str) -> "PlainTextBuilder":
        self._doc.sections.append(text.upper())
        return self

    def add_paragraph(self, text: str) -> "PlainTextBuilder":
        self._doc.sections.append(text)
        return self

    def build(self) -> Document:
        doc, self._doc = self._doc, Document()
        return doc


class Director:
    """Encapsulates a reusable construction recipe."""

    def __init__(self, builder: DocumentBuilder) -> None:
        self._builder = builder

    def make_report(self) -> Document:
        return (
            self._builder
            .add_title("Quarterly Report")
            .add_paragraph("Revenue grew steadily.")
            .build()
        )


if __name__ == "__main__":
    director = Director(PlainTextBuilder())
    print(director.make_report().render())
