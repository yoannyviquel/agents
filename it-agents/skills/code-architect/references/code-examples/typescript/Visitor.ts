// Visitor — separate algorithms from objects via accept/visit (double dispatch).

interface ShapeVisitor<R> {
  visitCircle(circle: Circle): R;
  visitRectangle(rect: Rectangle): R;
}

interface Shape {
  accept<R>(visitor: ShapeVisitor<R>): R;
}

class Circle implements Shape {
  constructor(public readonly radius: number) {}
  accept<R>(visitor: ShapeVisitor<R>): R {
    return visitor.visitCircle(this);
  }
}

class Rectangle implements Shape {
  constructor(public readonly width: number, public readonly height: number) {}
  accept<R>(visitor: ShapeVisitor<R>): R {
    return visitor.visitRectangle(this);
  }
}

// A new operation added without touching the shape classes.
class AreaVisitor implements ShapeVisitor<number> {
  visitCircle(circle: Circle): number {
    return Math.PI * circle.radius ** 2;
  }
  visitRectangle(rect: Rectangle): number {
    return rect.width * rect.height;
  }
}

function demo(): void {
  const shapes: Shape[] = [new Circle(2), new Rectangle(3, 4)];
  const area = new AreaVisitor();
  for (const shape of shapes) {
    console.log(`area = ${shape.accept(area).toFixed(2)}`);
  }
}

demo();
