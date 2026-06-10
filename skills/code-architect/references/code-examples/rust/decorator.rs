// Decorator — attach extra responsibilities to an object at runtime by wrapping
// it in objects that share the same interface.

trait Notifier {
    fn send(&self, message: &str) -> String;
}

struct BaseNotifier;

impl Notifier for BaseNotifier {
    fn send(&self, message: &str) -> String {
        format!("core[{}]", message)
    }
}

// Decorators wrap another Notifier and add behavior around its call.
struct TimestampDecorator {
    inner: Box<dyn Notifier>,
}
struct UppercaseDecorator {
    inner: Box<dyn Notifier>,
}

impl Notifier for TimestampDecorator {
    fn send(&self, message: &str) -> String {
        format!("12:00 {}", self.inner.send(message))
    }
}
impl Notifier for UppercaseDecorator {
    fn send(&self, message: &str) -> String {
        self.inner.send(&message.to_uppercase())
    }
}

fn main() {
    let plain = BaseNotifier;
    println!("{}", plain.send("hello"));

    // Stack decorators dynamically.
    let decorated: Box<dyn Notifier> = Box::new(TimestampDecorator {
        inner: Box::new(UppercaseDecorator { inner: Box::new(BaseNotifier) }),
    });
    println!("{}", decorated.send("hello"));
}
