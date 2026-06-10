"""Facade — a simplified interface over a complex subsystem."""


class Encoder:
    def encode(self, source: str) -> str:
        return f"encoded({source})"


class Muxer:
    def mux(self, stream: str) -> str:
        return f"muxed({stream})"


class Writer:
    def write(self, container: str) -> str:
        return f"written({container})"


class MediaFacade:
    """Hides the subsystem wiring behind one convenient method."""

    def __init__(self) -> None:
        self._encoder = Encoder()
        self._muxer = Muxer()
        self._writer = Writer()

    def convert(self, source: str) -> str:
        encoded = self._encoder.encode(source)
        muxed = self._muxer.mux(encoded)
        return self._writer.write(muxed)


if __name__ == "__main__":
    print(MediaFacade().convert("clip.raw"))
