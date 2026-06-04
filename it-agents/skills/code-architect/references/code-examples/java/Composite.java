// Composite — compose objects into trees, treat leaf and container uniformly.

import java.util.ArrayList;
import java.util.List;

interface Node {
    int size();
    String name();
}

class FileLeaf implements Node {
    private final String name;
    private final int bytes;
    FileLeaf(String name, int bytes) { this.name = name; this.bytes = bytes; }
    public int size() { return bytes; }
    public String name() { return name; }
}

class FolderComposite implements Node {
    private final String name;
    private final List<Node> children = new ArrayList<>();
    FolderComposite(String name) { this.name = name; }
    FolderComposite add(Node n) { children.add(n); return this; }
    public int size() {
        int total = 0;
        for (Node c : children) total += c.size();
        return total;
    }
    public String name() { return name; }
}

public class Composite {
    public static void main(String[] args) {
        FolderComposite root = new FolderComposite("root")
                .add(new FileLeaf("a.txt", 100))
                .add(new FolderComposite("sub")
                        .add(new FileLeaf("b.txt", 200))
                        .add(new FileLeaf("c.txt", 50)));
        System.out.println(root.name() + " total bytes: " + root.size());
    }
}
