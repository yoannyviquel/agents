// Builder — construct a complex object step by step, keeping construction logic
// separate from the final representation.

#[derive(Debug, Default)]
struct Report {
    title: String,
    sections: Vec<String>,
    footer: Option<String>,
}

#[derive(Default)]
struct ReportBuilder {
    report: Report,
}

impl ReportBuilder {
    fn new() -> Self {
        Self::default()
    }

    fn title(mut self, title: &str) -> Self {
        self.report.title = title.to_string();
        self
    }

    fn section(mut self, body: &str) -> Self {
        self.report.sections.push(body.to_string());
        self
    }

    fn footer(mut self, note: &str) -> Self {
        self.report.footer = Some(note.to_string());
        self
    }

    fn build(self) -> Report {
        self.report
    }
}

fn main() {
    let report = ReportBuilder::new()
        .title("Quarterly Summary")
        .section("Revenue is up.")
        .section("Costs are stable.")
        .footer("Confidential")
        .build();

    println!("# {}", report.title);
    for (i, s) in report.sections.iter().enumerate() {
        println!("  {}. {}", i + 1, s);
    }
    if let Some(f) = report.footer {
        println!("-- {} --", f);
    }
}
