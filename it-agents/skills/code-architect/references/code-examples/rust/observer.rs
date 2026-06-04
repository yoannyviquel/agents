// Observer — define a subscription mechanism so a subject can notify any number
// of dependent observers automatically when its state changes.

use std::cell::RefCell;
use std::rc::Rc;

trait Observer {
    fn on_event(&self, value: i32);
}

struct Logger {
    name: String,
}

impl Observer for Logger {
    fn on_event(&self, value: i32) {
        println!("{} observed value = {}", self.name, value);
    }
}

// Subject maintains a list of subscribers and notifies them on change.
struct Subject {
    observers: Vec<Rc<dyn Observer>>,
    value: i32,
}

impl Subject {
    fn new() -> Self {
        Subject { observers: Vec::new(), value: 0 }
    }

    fn subscribe(&mut self, obs: Rc<dyn Observer>) {
        self.observers.push(obs);
    }

    fn set_value(&mut self, value: i32) {
        self.value = value;
        for obs in &self.observers {
            obs.on_event(value);
        }
    }
}

fn main() {
    let subject = Rc::new(RefCell::new(Subject::new()));
    subject.borrow_mut().subscribe(Rc::new(Logger { name: "A".into() }));
    subject.borrow_mut().subscribe(Rc::new(Logger { name: "B".into() }));

    subject.borrow_mut().set_value(7);
    subject.borrow_mut().set_value(42);
}
