"""Abstract Factory — create families of related objects without specifying concrete classes."""

from abc import ABC, abstractmethod


class Button(ABC):
    @abstractmethod
    def render(self) -> str:
        ...


class Checkbox(ABC):
    @abstractmethod
    def render(self) -> str:
        ...


class LightButton(Button):
    def render(self) -> str:
        return "[ Light Button ]"


class LightCheckbox(Checkbox):
    def render(self) -> str:
        return "[x] Light Checkbox"


class DarkButton(Button):
    def render(self) -> str:
        return "[ Dark Button ]"


class DarkCheckbox(Checkbox):
    def render(self) -> str:
        return "[x] Dark Checkbox"


class WidgetFactory(ABC):
    """Each concrete factory produces a coherent family of widgets."""

    @abstractmethod
    def create_button(self) -> Button:
        ...

    @abstractmethod
    def create_checkbox(self) -> Checkbox:
        ...


class LightFactory(WidgetFactory):
    def create_button(self) -> Button:
        return LightButton()

    def create_checkbox(self) -> Checkbox:
        return LightCheckbox()


class DarkFactory(WidgetFactory):
    def create_button(self) -> Button:
        return DarkButton()

    def create_checkbox(self) -> Checkbox:
        return DarkCheckbox()


def build_ui(factory: WidgetFactory) -> str:
    return f"{factory.create_button().render()} {factory.create_checkbox().render()}"


if __name__ == "__main__":
    print(build_ui(LightFactory()))
    print(build_ui(DarkFactory()))
