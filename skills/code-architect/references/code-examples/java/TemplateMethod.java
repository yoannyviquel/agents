// Template Method — algorithm skeleton in a base class with overridable steps.

abstract class ImportProcess {
    // The template method defines the fixed sequence.
    public final String run(String raw) {
        String parsed = parse(raw);
        String transformed = transform(parsed);
        return store(transformed);
    }

    protected abstract String parse(String raw);
    protected abstract String transform(String parsed);

    // A default step subclasses may keep as-is.
    protected String store(String data) { return "stored[" + data + "]"; }
}

class CsvImport extends ImportProcess {
    protected String parse(String raw) { return raw.replace(',', '|'); }
    protected String transform(String parsed) { return parsed.toUpperCase(); }
}

class JsonImport extends ImportProcess {
    protected String parse(String raw) { return raw.replace("\"", ""); }
    protected String transform(String parsed) { return "<" + parsed + ">"; }
}

public class TemplateMethod {
    public static void main(String[] args) {
        System.out.println(new CsvImport().run("a,b,c"));
        System.out.println(new JsonImport().run("\"x\":\"y\""));
    }
}
