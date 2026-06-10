// Visitor — separate algorithms from objects via accept/visit (double dispatch).

interface ShapeVisitor {
    String visitSquare(Square s);
    String visitCircle(Circle c);
}

interface Element {
    String accept(ShapeVisitor v);
}

class Square implements Element {
    final int side;
    Square(int side) { this.side = side; }
    public String accept(ShapeVisitor v) { return v.visitSquare(this); }
}

class Circle implements Element {
    final int radius;
    Circle(int radius) { this.radius = radius; }
    public String accept(ShapeVisitor v) { return v.visitCircle(this); }
}

// One algorithm over the hierarchy, kept outside the element classes.
class AreaVisitor implements ShapeVisitor {
    public String visitSquare(Square s) { return "square area=" + (s.side * s.side); }
    public String visitCircle(Circle c) {
        return "circle area=" + String.format("%.2f", Math.PI * c.radius * c.radius);
    }
}

public class Visitor {
    public static void main(String[] args) {
        Element[] shapes = { new Square(4), new Circle(3) };
        ShapeVisitor area = new AreaVisitor();
        for (Element shape : shapes) {
            System.out.println(shape.accept(area));
        }
    }
}
