// Bridge — split abstraction and implementation into independent hierarchies.

// Implementation hierarchy.
interface Renderer {
    String drawCircle(int radius);
}

class VectorRenderer implements Renderer {
    public String drawCircle(int radius) { return "vector circle r=" + radius; }
}

class RasterRenderer implements Renderer {
    public String drawCircle(int radius) { return "raster circle r=" + radius; }
}

// Abstraction hierarchy, bridged to a Renderer.
abstract class Drawing {
    protected final Renderer renderer;
    Drawing(Renderer renderer) { this.renderer = renderer; }
    abstract String paint();
}

class Circle extends Drawing {
    private final int radius;
    Circle(Renderer renderer, int radius) { super(renderer); this.radius = radius; }
    String paint() { return renderer.drawCircle(radius); }
}

public class Bridge {
    public static void main(String[] args) {
        System.out.println(new Circle(new VectorRenderer(), 5).paint());
        System.out.println(new Circle(new RasterRenderer(), 5).paint());
    }
}
