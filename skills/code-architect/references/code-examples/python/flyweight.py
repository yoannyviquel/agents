"""Flyweight — share intrinsic state across many objects to save memory."""

from __future__ import annotations


class Glyph:
    """Stores only intrinsic (shared) state: the character's shape."""

    def __init__(self, symbol: str) -> None:
        self.symbol = symbol

    def render(self, x: int, y: int) -> str:
        # Extrinsic state (position) is passed in by the caller.
        return f"'{self.symbol}' @ ({x},{y})"


class GlyphFactory:
    """Returns shared Glyph instances, creating each symbol only once."""

    def __init__(self) -> None:
        self._cache: dict[str, Glyph] = {}

    def get(self, symbol: str) -> Glyph:
        if symbol not in self._cache:
            self._cache[symbol] = Glyph(symbol)
        return self._cache[symbol]

    def count(self) -> int:
        return len(self._cache)


if __name__ == "__main__":
    factory = GlyphFactory()
    text = "abba"
    for i, ch in enumerate(text):
        print(factory.get(ch).render(i, 0))
    print(f"distinct glyph objects for {len(text)} chars: {factory.count()}")
