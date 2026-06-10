// Prototype — copy existing objects via a clone interface without coupling to classes.

protocol Cloneable {
    func clone() -> Self
}

final class Document: Cloneable {
    var heading: String
    var tags: [String]

    init(heading: String, tags: [String]) {
        self.heading = heading
        self.tags = tags
    }

    func clone() -> Document {
        Document(heading: heading, tags: tags)
    }

    var description: String {
        "Document(heading: \"\(heading)\", tags: \(tags))"
    }
}

func runDemo() {
    let original = Document(heading: "Draft", tags: ["a", "b"])
    let copy = original.clone()
    copy.heading = "Revised Copy"
    copy.tags.append("c")

    print("original:", original.description)
    print("copy:    ", copy.description)
    print("independent:", original.heading != copy.heading)
}

runDemo()
