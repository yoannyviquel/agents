// Adapter — make an incompatible interface usable via a wrapper.

// Target interface the client expects.
interface JsonSource {
  fetchJson(): Record<string, unknown>;
}

// Existing incompatible service (the adaptee).
class LegacyCsvService {
  readCsv(): string {
    return "name,score\nada,98";
  }
}

// Adapter translates CSV into the JSON-shaped interface.
class CsvToJsonAdapter implements JsonSource {
  constructor(private readonly legacy: LegacyCsvService) {}

  fetchJson(): Record<string, unknown> {
    const [header, row] = this.legacy.readCsv().split("\n");
    const keys = header.split(",");
    const cells = row.split(",");
    const result: Record<string, unknown> = {};
    keys.forEach((key, i) => (result[key] = cells[i]));
    return result;
  }
}

function demo(): void {
  const source: JsonSource = new CsvToJsonAdapter(new LegacyCsvService());
  console.log(source.fetchJson());
}

demo();
