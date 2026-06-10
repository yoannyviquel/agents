// Iterator — traverse a collection without exposing its representation.

// A ring buffer whose internal storage layout is hidden from clients.
struct RingBuffer<Element> {
    private var storage: [Element] = []

    mutating func push(_ element: Element) {
        storage.append(element)
    }
}

// Custom iterator that walks the buffer in reverse order.
extension RingBuffer: Sequence {
    func makeIterator() -> AnyIterator<Element> {
        var index = storage.count - 1
        return AnyIterator {
            guard index >= 0 else { return nil }
            defer { index -= 1 }
            return storage[index]
        }
    }
}

func runDemo() {
    var buffer = RingBuffer<String>()
    buffer.push("first")
    buffer.push("second")
    buffer.push("third")

    for item in buffer {
        print("visiting:", item)
    }
}

runDemo()
