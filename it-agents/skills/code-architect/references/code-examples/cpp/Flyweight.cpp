// Flyweight — share intrinsic state across many objects to save memory.
#include <iostream>
#include <map>
#include <memory>
#include <string>

// Intrinsic (shared) state.
class Glyph {
    char symbol;
    std::string font;
public:
    Glyph(char s, std::string f) : symbol(s), font(std::move(f)) {}
    // Extrinsic state (position) is passed in at use time.
    void draw(int x, int y) const {
        std::cout << "'" << symbol << "'/" << font << " at (" << x << "," << y << ")\n";
    }
};

// Flyweight factory caches and reuses shared instances.
class GlyphFactory {
    std::map<std::string, std::shared_ptr<Glyph>> pool;
public:
    std::shared_ptr<Glyph> get(char symbol, const std::string& font) {
        std::string key = std::string(1, symbol) + ":" + font;
        auto it = pool.find(key);
        if (it == pool.end())
            it = pool.emplace(key, std::make_shared<Glyph>(symbol, font)).first;
        return it->second;
    }
    size_t distinct() const { return pool.size(); }
};

int main() {
    GlyphFactory factory;
    std::string text = "aba";
    int x = 0;
    for (char c : text) {
        factory.get(c, "serif")->draw(x, 0);
        x += 10;
    }
    std::cout << "distinct flyweights = " << factory.distinct() << "\n";
    return 0;
}
