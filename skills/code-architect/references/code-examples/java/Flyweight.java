// Flyweight — share intrinsic state across many objects to save memory.

import java.util.HashMap;
import java.util.Map;

// Intrinsic, shareable state.
class Glyph {
    private final char symbol;
    private final String font;
    Glyph(char symbol, String font) { this.symbol = symbol; this.font = font; }
    String render(int x, int y) { // extrinsic state passed in
        return symbol + "@" + x + "," + y + "(" + font + ")";
    }
}

class GlyphFactory {
    private final Map<String, Glyph> pool = new HashMap<>();
    Glyph get(char symbol, String font) {
        String key = symbol + ":" + font;
        return pool.computeIfAbsent(key, k -> new Glyph(symbol, font));
    }
    int distinctCount() { return pool.size(); }
}

public class Flyweight {
    public static void main(String[] args) {
        GlyphFactory factory = new GlyphFactory();
        String text = "aaab";
        int x = 0;
        StringBuilder out = new StringBuilder();
        for (char c : text.toCharArray()) {
            Glyph g = factory.get(c, "mono");
            out.append(g.render(x++, 0)).append(" ");
        }
        System.out.println(out.toString().trim());
        System.out.println("shared glyphs: " + factory.distinctCount());
    }
}
