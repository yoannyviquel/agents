// Bridge — split abstraction and implementation into independent hierarchies.

// Implementation hierarchy.
protocol Renderer {
    func drawShape(_ name: String) -> String
}

struct VectorRenderer: Renderer {
    func drawShape(_ name: String) -> String { "drawing \(name) as crisp vectors" }
}

struct RasterRenderer: Renderer {
    func drawShape(_ name: String) -> String { "drawing \(name) as pixels" }
}

// Abstraction hierarchy holds a reference to an implementation.
class Shape {
    let renderer: Renderer
    init(renderer: Renderer) { self.renderer = renderer }
    func draw() -> String { fatalError("subclass must override draw()") }
}

final class Circle: Shape {
    override func draw() -> String { renderer.drawShape("circle") }
}

final class Square: Shape {
    override func draw() -> String { renderer.drawShape("square") }
}

func runDemo() {
    let shapes: [Shape] = [
        Circle(renderer: VectorRenderer()),
        Circle(renderer: RasterRenderer()),
        Square(renderer: VectorRenderer())
    ]
    shapes.forEach { print($0.draw()) }
}

runDemo()
