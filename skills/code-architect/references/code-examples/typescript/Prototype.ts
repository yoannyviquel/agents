// Prototype — copy existing objects via a clone interface without coupling to classes.

interface Cloneable<T> {
  clone(): T;
}

class Document implements Cloneable<Document> {
  constructor(
    public title: string,
    public tags: string[],
    public metadata: Record<string, string>,
  ) {}

  clone(): Document {
    // Deep-copy mutable members so clones stay independent.
    return new Document(this.title, [...this.tags], { ...this.metadata });
  }
}

function demo(): void {
  const original = new Document("Spec", ["draft"], { author: "team" });
  const copy = original.clone();
  copy.title = "Spec (revised)";
  copy.tags.push("reviewed");

  console.log(`original: ${original.title} / tags=${original.tags.join(",")}`);
  console.log(`copy:     ${copy.title} / tags=${copy.tags.join(",")}`);
}

demo();
