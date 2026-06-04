"""Bridge — split abstraction and implementation into independent hierarchies."""

from abc import ABC, abstractmethod


class Renderer(ABC):
    """Implementation side: how things are drawn."""

    @abstractmethod
    def draw_line(self, label: str) -> str:
        ...


class AsciiRenderer(Renderer):
    def draw_line(self, label: str) -> str:
        return f"--- {label} ---"


class HtmlRenderer(Renderer):
    def draw_line(self, label: str) -> str:
        return f"<hr/><b>{label}</b>"


class View(ABC):
    """Abstraction side: holds a reference to a Renderer."""

    def __init__(self, renderer: Renderer) -> None:
        self._renderer = renderer

    @abstractmethod
    def show(self) -> str:
        ...


class TitleView(View):
    def __init__(self, renderer: Renderer, title: str) -> None:
        super().__init__(renderer)
        self._title = title

    def show(self) -> str:
        return self._renderer.draw_line(self._title)


if __name__ == "__main__":
    print(TitleView(AsciiRenderer(), "Welcome").show())
    print(TitleView(HtmlRenderer(), "Welcome").show())
