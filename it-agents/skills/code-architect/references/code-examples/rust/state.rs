// State — let an object change its behavior when its internal state changes, by
// delegating to interchangeable state objects that return the next state.

trait State {
    // Consumes self and returns the next state.
    fn next(self: Box<Self>) -> Box<dyn State>;
    fn label(&self) -> &'static str;
}

struct Idle;
struct Running;
struct Done;

impl State for Idle {
    fn next(self: Box<Self>) -> Box<dyn State> {
        Box::new(Running)
    }
    fn label(&self) -> &'static str {
        "Idle"
    }
}
impl State for Running {
    fn next(self: Box<Self>) -> Box<dyn State> {
        Box::new(Done)
    }
    fn label(&self) -> &'static str {
        "Running"
    }
}
impl State for Done {
    fn next(self: Box<Self>) -> Box<dyn State> {
        self // terminal state stays put
    }
    fn label(&self) -> &'static str {
        "Done"
    }
}

struct Machine {
    state: Box<dyn State>,
}

impl Machine {
    fn step(&mut self) {
        let current = std::mem::replace(&mut self.state, Box::new(Idle));
        self.state = current.next();
    }
}

fn main() {
    let mut machine = Machine { state: Box::new(Idle) };
    for _ in 0..4 {
        println!("state: {}", machine.state.label());
        machine.step();
    }
}
