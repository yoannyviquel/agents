// Iterator — traverse a collection without exposing its representation.

interface SimpleIterator<T> {
  hasNext(): boolean;
  next(): T;
}

// Aggregate backed by a ring buffer; iteration order is hidden.
class RingBuffer<T> {
  private items: T[] = [];

  push(item: T): void {
    this.items.push(item);
  }

  // Iterates in reverse insertion order without revealing internals.
  createIterator(): SimpleIterator<T> {
    let cursor = this.items.length - 1;
    const snapshot = [...this.items];
    return {
      hasNext: () => cursor >= 0,
      next: () => snapshot[cursor--],
    };
  }
}

function demo(): void {
  const buffer = new RingBuffer<string>();
  buffer.push("a");
  buffer.push("b");
  buffer.push("c");

  const it = buffer.createIterator();
  const visited: string[] = [];
  while (it.hasNext()) {
    visited.push(it.next());
  }
  console.log(`visited: ${visited.join(" -> ")}`); // c -> b -> a
}

demo();
