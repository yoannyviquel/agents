// Adapter — wrap an incompatible interface so it satisfies the interface the
// client expects, without touching the existing (adaptee) code.

// Target interface the client relies on.
trait DataSource {
    fn read(&self) -> Vec<i32>;
}

// Adaptee: a pre-existing type with an inconvenient interface.
struct LegacyFeed {
    raw: String, // comma-separated values
}

impl LegacyFeed {
    fn fetch_raw(&self) -> &str {
        &self.raw
    }
}

// Adapter translates LegacyFeed into the DataSource interface.
struct LegacyFeedAdapter {
    feed: LegacyFeed,
}

impl DataSource for LegacyFeedAdapter {
    fn read(&self) -> Vec<i32> {
        self.feed
            .fetch_raw()
            .split(',')
            .filter_map(|s| s.trim().parse().ok())
            .collect()
    }
}

fn sum(source: &dyn DataSource) -> i32 {
    source.read().iter().sum()
}

fn main() {
    let adapter = LegacyFeedAdapter {
        feed: LegacyFeed { raw: "10, 20, 30, 42".into() },
    };
    println!("values: {:?}", adapter.read());
    println!("sum: {}", sum(&adapter));
}
