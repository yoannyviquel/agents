// Prototype — copy existing objects via a clone interface without coupling to classes.

import java.util.ArrayList;
import java.util.List;

interface Copyable<T> {
    T copy();
}

class Shape implements Copyable<Shape> {
    int x, y;
    String color;
    Shape(int x, int y, String color) { this.x = x; this.y = y; this.color = color; }
    public Shape copy() { return new Shape(x, y, color); }
    public String toString() { return color + "@(" + x + "," + y + ")"; }
}

class Group implements Copyable<Group> {
    final List<Shape> shapes = new ArrayList<>();
    void add(Shape s) { shapes.add(s); }
    public Group copy() {
        Group g = new Group();
        for (Shape s : shapes) g.add(s.copy()); // deep copy of members
        return g;
    }
    public String toString() { return shapes.toString(); }
}

public class Prototype {
    public static void main(String[] args) {
        Group original = new Group();
        original.add(new Shape(1, 2, "red"));
        original.add(new Shape(3, 4, "blue"));

        Group clone = original.copy();
        clone.shapes.get(0).color = "green"; // mutate clone only

        System.out.println("original: " + original);
        System.out.println("clone:    " + clone);
    }
}
