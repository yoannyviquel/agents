// Strategy — define a family of interchangeable algorithms behind one interface
// so the algorithm can be selected and swapped at runtime.

trait CompressionStrategy {
    fn compress(&self, data: &str) -> String;
}

struct RunLength;
struct Doubling;

impl CompressionStrategy for RunLength {
    fn compress(&self, data: &str) -> String {
        let mut out = String::new();
        let mut chars = data.chars().peekable();
        while let Some(c) = chars.next() {
            let mut count = 1;
            while chars.peek() == Some(&c) {
                chars.next();
                count += 1;
            }
            out.push_str(&format!("{}{}", count, c));
        }
        out
    }
}

impl CompressionStrategy for Doubling {
    fn compress(&self, data: &str) -> String {
        data.chars().flat_map(|c| [c, c]).collect()
    }
}

// Context delegates the work to whichever strategy it currently holds.
struct Archiver {
    strategy: Box<dyn CompressionStrategy>,
}

impl Archiver {
    fn run(&self, data: &str) -> String {
        self.strategy.compress(data)
    }
}

fn main() {
    let mut archiver = Archiver { strategy: Box::new(RunLength) };
    println!("rle: {}", archiver.run("aaabbc"));

    archiver.strategy = Box::new(Doubling);
    println!("doubling: {}", archiver.run("abc"));
}
