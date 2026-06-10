// Builder — construct complex objects step by step.

interface Report {
  title: string;
  sections: string[];
  footer?: string;
}

interface ReportBuilder {
  setTitle(title: string): this;
  addSection(text: string): this;
  setFooter(text: string): this;
  build(): Report;
}

class PlainReportBuilder implements ReportBuilder {
  private title = "Untitled";
  private sections: string[] = [];
  private footer?: string;

  setTitle(title: string): this {
    this.title = title;
    return this;
  }

  addSection(text: string): this {
    this.sections.push(text);
    return this;
  }

  setFooter(text: string): this {
    this.footer = text;
    return this;
  }

  build(): Report {
    return { title: this.title, sections: [...this.sections], footer: this.footer };
  }
}

// Director encapsulates a common construction recipe.
class ReportDirector {
  constructor(private readonly builder: ReportBuilder) {}

  makeSummary(): Report {
    return this.builder
      .setTitle("Quarterly Summary")
      .addSection("Revenue grew.")
      .addSection("Costs held steady.")
      .setFooter("Confidential")
      .build();
  }
}

function demo(): void {
  const director = new ReportDirector(new PlainReportBuilder());
  const report = director.makeSummary();
  console.log(`${report.title} (${report.sections.length} sections) — ${report.footer}`);
}

demo();
