"""Decorator — attach responsibilities by wrapping objects at runtime."""

from abc import ABC, abstractmethod


class Stream(ABC):
    @abstractmethod
    def write(self, data: str) -> str:
        ...


class RawStream(Stream):
    def write(self, data: str) -> str:
        return data


class StreamDecorator(Stream):
    """Base wrapper holding a reference to the wrapped component."""

    def __init__(self, wrapped: Stream) -> None:
        self._wrapped = wrapped

    def write(self, data: str) -> str:
        return self._wrapped.write(data)


class UpperCaseDecorator(StreamDecorator):
    def write(self, data: str) -> str:
        return super().write(data.upper())


class BracketDecorator(StreamDecorator):
    def write(self, data: str) -> str:
        return super().write(f"[{data}]")


if __name__ == "__main__":
    stream = BracketDecorator(UpperCaseDecorator(RawStream()))
    print(stream.write("payload"))
