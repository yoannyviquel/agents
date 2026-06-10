"""Memento — capture and restore an object's state without breaking encapsulation."""

from __future__ import annotations


class _Memento:
    """Opaque snapshot; only the originator interprets its contents."""

    def __init__(self, state: str) -> None:
        self._state = state


class Editor:
    """Originator that produces and consumes mementos."""

    def __init__(self) -> None:
        self._content = ""

    def type(self, text: str) -> None:
        self._content += text

    def save(self) -> _Memento:
        return _Memento(self._content)

    def restore(self, memento: _Memento) -> None:
        self._content = memento._state

    def __str__(self) -> str:
        return self._content


class History:
    """Caretaker: stores mementos without inspecting them."""

    def __init__(self) -> None:
        self._stack: list[_Memento] = []

    def push(self, memento: _Memento) -> None:
        self._stack.append(memento)

    def pop(self) -> _Memento | None:
        return self._stack.pop() if self._stack else None


if __name__ == "__main__":
    editor, history = Editor(), History()
    editor.type("hello ")
    history.push(editor.save())
    editor.type("world")
    print("before undo:", editor)
    snapshot = history.pop()
    if snapshot:
        editor.restore(snapshot)
    print("after undo: ", editor)
