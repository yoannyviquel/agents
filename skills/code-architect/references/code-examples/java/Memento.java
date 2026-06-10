// Memento — capture and restore an object's state without breaking encapsulation.

import java.util.ArrayDeque;
import java.util.Deque;

class Editor {
    private String content = "";

    void type(String text) { content += text; }
    String content() { return content; }

    // Memento carries opaque state; only the originator can read it back.
    Snapshot save() { return new Snapshot(content); }
    void restore(Snapshot s) { this.content = s.state; }

    static final class Snapshot {
        private final String state;
        private Snapshot(String state) { this.state = state; }
    }
}

class Caretaker {
    private final Deque<Editor.Snapshot> stack = new ArrayDeque<>();
    void backup(Editor e) { stack.push(e.save()); }
    void undo(Editor e) { if (!stack.isEmpty()) e.restore(stack.pop()); }
}

public class Memento {
    public static void main(String[] args) {
        Editor editor = new Editor();
        Caretaker history = new Caretaker();

        editor.type("Hello");
        history.backup(editor);
        editor.type(", World");
        System.out.println("before undo: " + editor.content());

        history.undo(editor);
        System.out.println("after undo:  " + editor.content());
    }
}
