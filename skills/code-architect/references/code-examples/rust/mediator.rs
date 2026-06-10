// Mediator — centralize communication between components so they refer only to
// the mediator instead of to each other, reducing coupling.

use std::cell::RefCell;
use std::rc::Rc;

// The mediator coordinates colleagues by name.
struct Hub {
    log: RefCell<Vec<String>>,
}

impl Hub {
    fn new() -> Self {
        Hub { log: RefCell::new(Vec::new()) }
    }

    // A colleague notifies the hub, which decides what others should do.
    fn broadcast(&self, sender: &str, event: &str) {
        self.log.borrow_mut().push(format!("{} -> {}", sender, event));
        match (sender, event) {
            ("Switch", "on") => println!("Hub: turning Lamp ON, starting Fan"),
            ("Switch", "off") => println!("Hub: turning Lamp OFF, stopping Fan"),
            _ => println!("Hub: no rule for {}:{}", sender, event),
        }
    }
}

struct Switch {
    hub: Rc<Hub>,
}

impl Switch {
    fn toggle(&self, on: bool) {
        self.hub.broadcast("Switch", if on { "on" } else { "off" });
    }
}

fn main() {
    let hub = Rc::new(Hub::new());
    let switch = Switch { hub: Rc::clone(&hub) };

    switch.toggle(true);
    switch.toggle(false);

    println!("event log: {:?}", hub.log.borrow());
}
