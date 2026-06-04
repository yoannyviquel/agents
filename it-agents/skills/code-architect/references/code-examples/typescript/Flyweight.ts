// Flyweight — share intrinsic state across many objects to save memory.

// Intrinsic, shareable state.
class GlyphStyle {
  constructor(
    public readonly font: string,
    public readonly size: number,
  ) {}

  describe(): string {
    return `${this.font}@${this.size}`;
  }
}

// Factory returns shared instances keyed by intrinsic state.
class GlyphStyleFactory {
  private pool = new Map<string, GlyphStyle>();

  get(font: string, size: number): GlyphStyle {
    const key = `${font}:${size}`;
    let style = this.pool.get(key);
    if (!style) {
      style = new GlyphStyle(font, size);
      this.pool.set(key, style);
    }
    return style;
  }

  get count(): number {
    return this.pool.size;
  }
}

// Extrinsic state (position) stays outside the flyweight.
interface PlacedGlyph {
  char: string;
  x: number;
  style: GlyphStyle;
}

function demo(): void {
  const factory = new GlyphStyleFactory();
  const text = "hello";
  const glyphs: PlacedGlyph[] = [...text].map((char, x) => ({
    char,
    x,
    style: factory.get("Inter", 12),
  }));
  console.log(`${glyphs.length} glyphs share ${factory.count} style object(s)`);
}

demo();
