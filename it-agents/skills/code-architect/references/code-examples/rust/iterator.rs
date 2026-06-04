// Iterator — traverse a collection sequentially without exposing its internal
// representation, by implementing a custom Iterator.

// A simple ring buffer with a hidden layout.
struct RingBuffer {
    slots: Vec<i32>,
    start: usize,
}

impl RingBuffer {
    fn new(slots: Vec<i32>, start: usize) -> Self {
        RingBuffer { slots, start }
    }

    // Hand out an iterator instead of revealing the storage.
    fn iter(&self) -> RingIter<'_> {
        RingIter { buffer: self, pos: 0 }
    }
}

struct RingIter<'a> {
    buffer: &'a RingBuffer,
    pos: usize,
}

impl<'a> Iterator for RingIter<'a> {
    type Item = i32;

    fn next(&mut self) -> Option<i32> {
        if self.pos >= self.buffer.slots.len() {
            return None;
        }
        let idx = (self.buffer.start + self.pos) % self.buffer.slots.len();
        self.pos += 1;
        Some(self.buffer.slots[idx])
    }
}

fn main() {
    let ring = RingBuffer::new(vec![10, 20, 30, 40], 2);

    print!("traversal:");
    for value in ring.iter() {
        print!(" {}", value);
    }
    println!();

    // Works with standard adaptors because it's a real Iterator.
    let total: i32 = ring.iter().sum();
    println!("sum = {}", total);
}
