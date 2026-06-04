// Chain of Responsibility — pass a request along a chain of handlers; each
// either handles it or forwards it to the next handler.

struct Request {
    level: u8, // severity 1..=3
    text: String,
}

trait Handler {
    fn set_next(&mut self, next: Box<dyn Handler>);
    fn handle(&self, req: &Request);
}

struct LevelHandler {
    accepts: u8,
    name: &'static str,
    next: Option<Box<dyn Handler>>,
}

impl LevelHandler {
    fn new(accepts: u8, name: &'static str) -> Self {
        LevelHandler { accepts, name, next: None }
    }
}

impl Handler for LevelHandler {
    fn set_next(&mut self, next: Box<dyn Handler>) {
        self.next = Some(next);
    }

    fn handle(&self, req: &Request) {
        if req.level == self.accepts {
            println!("[{}] handled: {}", self.name, req.text);
        } else if let Some(next) = &self.next {
            next.handle(req);
        } else {
            println!("[end] unhandled request: {}", req.text);
        }
    }
}

fn main() {
    let mut info = LevelHandler::new(1, "info");
    let mut warn = LevelHandler::new(2, "warn");
    let error = LevelHandler::new(3, "error");

    warn.set_next(Box::new(error));
    info.set_next(Box::new(warn));

    info.handle(&Request { level: 2, text: "disk almost full".into() });
    info.handle(&Request { level: 3, text: "service crashed".into() });
    info.handle(&Request { level: 9, text: "mystery event".into() });
}
