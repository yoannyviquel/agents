// Decorator — attach responsibilities by wrapping objects at runtime.

interface TextStream {
    String write(String data);
}

class PlainStream implements TextStream {
    public String write(String data) { return data; }
}

abstract class StreamDecorator implements TextStream {
    protected final TextStream wrappee;
    StreamDecorator(TextStream wrappee) { this.wrappee = wrappee; }
}

class UpperCaseDecorator extends StreamDecorator {
    UpperCaseDecorator(TextStream w) { super(w); }
    public String write(String data) { return wrappee.write(data).toUpperCase(); }
}

class BracketDecorator extends StreamDecorator {
    BracketDecorator(TextStream w) { super(w); }
    public String write(String data) { return "<" + wrappee.write(data) + ">"; }
}

public class Decorator {
    public static void main(String[] args) {
        TextStream stream = new BracketDecorator(new UpperCaseDecorator(new PlainStream()));
        System.out.println(stream.write("hello"));
    }
}
