// Memento — capture and externalize an object's internal state so it can be
// restored later, without violating encapsulation.

// Originator owns the state and produces/consumes mementos.
struct Editor {
    text: String,
    cursor: usize,
}

// Memento is an opaque snapshot to outsiders.
struct Snapshot {
    text: String,
    cursor: usize,
}

impl Editor {
    fn new() -> Self {
        Editor { text: String::new(), cursor: 0 }
    }

    fn type_text(&mut self, s: &str) {
        self.text.push_str(s);
        self.cursor = self.text.len();
    }

    fn save(&self) -> Snapshot {
        Snapshot { text: self.text.clone(), cursor: self.cursor }
    }

    fn restore(&mut self, snap: Snapshot) {
        self.text = snap.text;
        self.cursor = snap.cursor;
    }

    fn state(&self) -> String {
        format!("'{}' (cursor={})", self.text, self.cursor)
    }
}

fn main() {
    // Caretaker keeps mementos without inspecting their contents.
    let mut editor = Editor::new();
    let mut history: Vec<Snapshot> = Vec::new();

    editor.type_text("hello");
    history.push(editor.save());
    editor.type_text(" world");
    println!("current: {}", editor.state());

    editor.restore(history.pop().unwrap());
    println!("restored: {}", editor.state());
}
