// Facade — a simplified interface over a complex subsystem.

// Subsystem components.
struct Decoder {
    func decode(_ raw: String) -> String { "decoded(\(raw))" }
}

struct Normalizer {
    func normalize(_ input: String) -> String { input.lowercased() }
}

struct Encoder {
    func encode(_ input: String) -> String { "<\(input)>" }
}

// Facade hides subsystem wiring behind one method.
struct MediaPipeline {
    private let decoder = Decoder()
    private let normalizer = Normalizer()
    private let encoder = Encoder()

    func process(_ raw: String) -> String {
        let decoded = decoder.decode(raw)
        let normalized = normalizer.normalize(decoded)
        return encoder.encode(normalized)
    }
}

func runDemo() {
    let pipeline = MediaPipeline()
    print(pipeline.process("RAW_INPUT"))
}

runDemo()
