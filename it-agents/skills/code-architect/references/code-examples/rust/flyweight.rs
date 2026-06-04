// Flyweight — share immutable intrinsic state across many objects to save
// memory; extrinsic state is passed in at use time.

use std::collections::HashMap;
use std::rc::Rc;

// Intrinsic, shareable state (the flyweight).
#[derive(Debug)]
struct Glyph {
    symbol: char,
    width: u32,
}

// Factory hands out shared flyweights, creating each only once.
struct GlyphFactory {
    pool: HashMap<char, Rc<Glyph>>,
}

impl GlyphFactory {
    fn new() -> Self {
        GlyphFactory { pool: HashMap::new() }
    }

    fn get(&mut self, symbol: char) -> Rc<Glyph> {
        self.pool
            .entry(symbol)
            .or_insert_with(|| {
                println!("creating new glyph for '{}'", symbol);
                Rc::new(Glyph { symbol, width: 8 })
            })
            .clone()
    }
}

fn main() {
    let mut factory = GlyphFactory::new();
    let text = "banana";

    // Extrinsic state (position) lives with each placement, glyphs are shared.
    let placed: Vec<(usize, Rc<Glyph>)> =
        text.chars().enumerate().map(|(pos, c)| (pos, factory.get(c))).collect();

    for (pos, glyph) in &placed {
        println!("pos {} -> '{}' (w={})", pos, glyph.symbol, glyph.width);
    }
    println!("unique glyphs allocated: {}", factory.pool.len());
}
