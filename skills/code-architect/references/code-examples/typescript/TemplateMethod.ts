// Template Method — algorithm skeleton in a base class with overridable steps.

abstract class DataPipeline {
  // The template method defines the fixed sequence.
  run(raw: string): string {
    const parsed = this.parse(raw);
    const transformed = this.transform(parsed);
    return this.format(transformed);
  }

  protected abstract parse(raw: string): string[];
  protected abstract transform(rows: string[]): string[];

  // A hook with a sensible default that subclasses may override.
  protected format(rows: string[]): string {
    return rows.join(" | ");
  }
}

class CsvPipeline extends DataPipeline {
  protected parse(raw: string): string[] {
    return raw.split(",");
  }
  protected transform(rows: string[]): string[] {
    return rows.map((r) => r.trim().toUpperCase());
  }
}

class WhitespacePipeline extends DataPipeline {
  protected parse(raw: string): string[] {
    return raw.split(/\s+/);
  }
  protected transform(rows: string[]): string[] {
    return rows.filter((r) => r.length > 2);
  }
  protected format(rows: string[]): string {
    return rows.join("-");
  }
}

function demo(): void {
  console.log(new CsvPipeline().run("a, b ,c"));
  console.log(new WhitespacePipeline().run("to be or not"));
}

demo();
