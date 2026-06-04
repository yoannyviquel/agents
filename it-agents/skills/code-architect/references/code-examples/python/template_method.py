"""Template Method — algorithm skeleton in a base class with overridable steps."""

from abc import ABC, abstractmethod


class ReportGenerator(ABC):
    """Defines the fixed algorithm; subclasses fill in the steps."""

    def generate(self, rows: list[str]) -> str:
        parts = [self.header()]
        parts += [self.format_row(row) for row in rows]
        parts.append(self.footer())
        return "\n".join(parts)

    @abstractmethod
    def header(self) -> str:
        ...

    @abstractmethod
    def format_row(self, row: str) -> str:
        ...

    def footer(self) -> str:  # optional hook with a default
        return "(end)"


class MarkdownReport(ReportGenerator):
    def header(self) -> str:
        return "# Report"

    def format_row(self, row: str) -> str:
        return f"- {row}"


class CsvReport(ReportGenerator):
    def header(self) -> str:
        return "value"

    def format_row(self, row: str) -> str:
        return row

    def footer(self) -> str:
        return ""


if __name__ == "__main__":
    print(MarkdownReport().generate(["alpha", "beta"]))
    print("---")
    print(CsvReport().generate(["alpha", "beta"]))
