// Singleton — guarantee a single shared instance with global access, using
// std::sync::OnceLock for safe, lazy, thread-safe initialization.

use std::sync::{Mutex, OnceLock};

struct Counter {
    ticks: Mutex<u64>,
}

impl Counter {
    fn new() -> Self {
        Counter { ticks: Mutex::new(0) }
    }

    fn tick(&self) -> u64 {
        let mut guard = self.ticks.lock().unwrap();
        *guard += 1;
        *guard
    }
}

fn instance() -> &'static Counter {
    static INSTANCE: OnceLock<Counter> = OnceLock::new();
    INSTANCE.get_or_init(Counter::new)
}

fn main() {
    println!("tick = {}", instance().tick());
    println!("tick = {}", instance().tick());

    // A separate access point still reaches the very same instance.
    let also = instance();
    println!("tick = {}", also.tick());
}
