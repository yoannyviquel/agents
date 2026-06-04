// Composite — compose objects into trees, treat leaf and container uniformly.

interface FileSystemNode {
  name: string;
  size(): number;
}

class FileLeaf implements FileSystemNode {
  constructor(public name: string, private readonly bytes: number) {}

  size(): number {
    return this.bytes;
  }
}

class FolderNode implements FileSystemNode {
  private children: FileSystemNode[] = [];

  constructor(public name: string) {}

  add(node: FileSystemNode): this {
    this.children.push(node);
    return this;
  }

  // Aggregates children — same interface as a leaf.
  size(): number {
    return this.children.reduce((total, child) => total + child.size(), 0);
  }
}

function demo(): void {
  const root = new FolderNode("root")
    .add(new FileLeaf("readme.txt", 120))
    .add(
      new FolderNode("src")
        .add(new FileLeaf("index.ts", 400))
        .add(new FileLeaf("util.ts", 250)),
    );
  console.log(`total size of '${root.name}' = ${root.size()} bytes`);
}

demo();
