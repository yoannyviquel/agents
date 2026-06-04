// Command — encapsulate a request as an object, decoupling sender from receiver
// and enabling features like undo via an inverse operation.

// Receiver: the object commands act upon.
struct Document {
    content: String,
}

trait Command {
    fn execute(&self, doc: &mut Document);
    fn undo(&self, doc: &mut Document);
}

struct Append {
    text: String,
}
struct Clear {
    saved: std::cell::RefCell<String>,
}

impl Command for Append {
    fn execute(&self, doc: &mut Document) {
        doc.content.push_str(&self.text);
    }
    fn undo(&self, doc: &mut Document) {
        let new_len = doc.content.len() - self.text.len();
        doc.content.truncate(new_len);
    }
}

impl Command for Clear {
    fn execute(&self, doc: &mut Document) {
        *self.saved.borrow_mut() = std::mem::take(&mut doc.content);
    }
    fn undo(&self, doc: &mut Document) {
        doc.content = self.saved.borrow().clone();
    }
}

fn main() {
    let mut doc = Document { content: String::new() };
    let mut history: Vec<Box<dyn Command>> = Vec::new();

    for cmd in [
        Box::new(Append { text: "Hello".into() }) as Box<dyn Command>,
        Box::new(Append { text: ", World".into() }),
        Box::new(Clear { saved: Default::default() }),
    ] {
        cmd.execute(&mut doc);
        println!("after exec: '{}'", doc.content);
        history.push(cmd);
    }

    while let Some(cmd) = history.pop() {
        cmd.undo(&mut doc);
        println!("after undo: '{}'", doc.content);
    }
}
