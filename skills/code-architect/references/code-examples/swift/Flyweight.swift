// Flyweight — share intrinsic state across many objects to save memory.

// Intrinsic, shared state.
final class GlyphStyle {
    let font: String
    let size: Int

    init(font: String, size: Int) {
        self.font = font
        self.size = size
    }
}

// Factory caches and reuses flyweights.
final class GlyphStyleFactory {
    private var cache: [String: GlyphStyle] = [:]

    func style(font: String, size: Int) -> GlyphStyle {
        let key = "\(font)-\(size)"
        if let existing = cache[key] { return existing }
        let created = GlyphStyle(font: font, size: size)
        cache[key] = created
        return created
    }

    var distinctCount: Int { cache.count }
}

// Extrinsic state stays with each placed glyph.
struct PlacedGlyph {
    let character: Character
    let style: GlyphStyle
}

func runDemo() {
    let factory = GlyphStyleFactory()
    let text = "hello"
    let glyphs = text.map {
        PlacedGlyph(character: $0, style: factory.style(font: "Serif", size: 12))
    }

    print("placed glyphs:", glyphs.count)
    print("distinct shared styles:", factory.distinctCount)
}

runDemo()
