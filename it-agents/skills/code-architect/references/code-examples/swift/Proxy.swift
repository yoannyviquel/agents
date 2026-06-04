// Proxy — a placeholder controlling access to a real object (here: lazy + caching).

protocol Resource {
    func load() -> String
}

// Expensive real subject.
final class HeavyResource: Resource {
    private let id: String
    init(id: String) {
        self.id = id
        print("HeavyResource(\(id)) constructed")
    }
    func load() -> String { "payload for \(id)" }
}

// Proxy defers construction and caches the result.
final class ResourceProxy: Resource {
    private let id: String
    private var real: HeavyResource?
    private var cached: String?

    init(id: String) { self.id = id }

    func load() -> String {
        if let cached { return cached + " (cached)" }
        if real == nil { real = HeavyResource(id: id) }
        let result = real!.load()
        cached = result
        return result
    }
}

func runDemo() {
    let proxy = ResourceProxy(id: "doc-1")
    print("proxy created; nothing loaded yet")
    print(proxy.load())
    print(proxy.load())
}

runDemo()
