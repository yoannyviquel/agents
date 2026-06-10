// Bridge — split abstraction and implementation into independent hierarchies.

// Implementation hierarchy.
interface Renderer {
  drawShape(name: string): string;
}

class VectorRenderer implements Renderer {
  drawShape(name: string): string {
    return `drawing ${name} as vectors`;
  }
}

class RasterRenderer implements Renderer {
  drawShape(name: string): string {
    return `drawing ${name} as pixels`;
  }
}

// Abstraction hierarchy holds a reference to an implementation.
abstract class Shape {
  constructor(protected readonly renderer: Renderer) {}
  abstract draw(): string;
}

class Circle extends Shape {
  draw(): string {
    return this.renderer.drawShape("circle");
  }
}

class Square extends Shape {
  draw(): string {
    return this.renderer.drawShape("square");
  }
}

function demo(): void {
  const shapes: Shape[] = [
    new Circle(new VectorRenderer()),
    new Square(new RasterRenderer()),
  ];
  for (const shape of shapes) {
    console.log(shape.draw());
  }
}

demo();
