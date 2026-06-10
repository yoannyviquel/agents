// Composite — compose objects into trees, treat leaf and container uniformly.

protocol Node {
    var name: String { get }
    func size() -> Int
}

// Leaf
struct FileNode: Node {
    let name: String
    let bytes: Int
    func size() -> Int { bytes }
}

// Composite
final class FolderNode: Node {
    let name: String
    private var children: [Node] = []

    init(name: String) { self.name = name }

    func add(_ node: Node) {
        children.append(node)
    }

    func size() -> Int {
        children.reduce(0) { $0 + $1.size() }
    }
}

func runDemo() {
    let root = FolderNode(name: "root")
    root.add(FileNode(name: "readme.txt", bytes: 120))

    let sub = FolderNode(name: "src")
    sub.add(FileNode(name: "main.swift", bytes: 800))
    sub.add(FileNode(name: "util.swift", bytes: 450))
    root.add(sub)

    print("total size of \(root.name): \(root.size()) bytes")
    print("size of \(sub.name): \(sub.size()) bytes")
}

runDemo()
