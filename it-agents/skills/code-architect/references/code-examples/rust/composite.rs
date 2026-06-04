// Composite — compose objects into tree structures and treat individual leaves
// and whole containers uniformly through one common interface.

trait Node {
    fn size(&self) -> u64;
    fn print(&self, indent: usize);
}

struct File {
    name: String,
    bytes: u64,
}

struct Folder {
    name: String,
    children: Vec<Box<dyn Node>>,
}

impl Node for File {
    fn size(&self) -> u64 {
        self.bytes
    }
    fn print(&self, indent: usize) {
        println!("{}- {} ({} B)", " ".repeat(indent), self.name, self.bytes);
    }
}

impl Node for Folder {
    fn size(&self) -> u64 {
        self.children.iter().map(|c| c.size()).sum()
    }
    fn print(&self, indent: usize) {
        println!("{}+ {}/ ({} B total)", " ".repeat(indent), self.name, self.size());
        for child in &self.children {
            child.print(indent + 2);
        }
    }
}

fn main() {
    let root = Folder {
        name: "root".into(),
        children: vec![
            Box::new(File { name: "readme.txt".into(), bytes: 120 }),
            Box::new(Folder {
                name: "src".into(),
                children: vec![
                    Box::new(File { name: "main.rs".into(), bytes: 800 }),
                    Box::new(File { name: "lib.rs".into(), bytes: 400 }),
                ],
            }),
        ],
    };

    root.print(0);
    println!("Grand total: {} bytes", root.size());
}
