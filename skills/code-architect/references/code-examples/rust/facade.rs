// Facade — provide a single simplified interface over a set of cooperating
// subsystem components, hiding their complexity from the client.

// Subsystem components.
struct Loader;
struct Decoder;
struct Cache;

impl Loader {
    fn load(&self, id: &str) -> Vec<u8> {
        println!("Loader: fetching raw bytes for {}", id);
        vec![1, 2, 3]
    }
}
impl Decoder {
    fn decode(&self, bytes: &[u8]) -> String {
        println!("Decoder: decoding {} bytes", bytes.len());
        format!("frame<{}>", bytes.len())
    }
}
impl Cache {
    fn store(&self, key: &str, value: &str) {
        println!("Cache: storing {} = {}", key, value);
    }
}

// Facade orchestrates the subsystem behind one easy method.
struct MediaFacade {
    loader: Loader,
    decoder: Decoder,
    cache: Cache,
}

impl MediaFacade {
    fn new() -> Self {
        MediaFacade { loader: Loader, decoder: Decoder, cache: Cache }
    }

    fn open(&self, id: &str) -> String {
        let bytes = self.loader.load(id);
        let frame = self.decoder.decode(&bytes);
        self.cache.store(id, &frame);
        frame
    }
}

fn main() {
    let media = MediaFacade::new();
    let result = media.open("clip-01");
    println!("Client received: {}", result);
}
