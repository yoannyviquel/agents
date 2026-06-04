// Adapter — make an incompatible interface usable via a wrapper.

// Target interface the client expects.
protocol DataSource {
    func fetchRows() -> [String]
}

// Incompatible existing service with a different shape.
final class LegacyFeed {
    func dumpPayload() -> String {
        "alpha;beta;gamma"
    }
}

// Adapter conforms to the target while delegating to the legacy service.
struct LegacyFeedAdapter: DataSource {
    private let legacy: LegacyFeed

    init(_ legacy: LegacyFeed) {
        self.legacy = legacy
    }

    func fetchRows() -> [String] {
        legacy.dumpPayload().split(separator: ";").map(String.init)
    }
}

func printRows(from source: DataSource) {
    for (index, row) in source.fetchRows().enumerated() {
        print("row \(index): \(row)")
    }
}

func runDemo() {
    let adapted = LegacyFeedAdapter(LegacyFeed())
    printRows(from: adapted)
}

runDemo()
