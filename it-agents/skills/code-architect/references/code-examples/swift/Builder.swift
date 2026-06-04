// Builder — construct complex objects step by step.

struct Report {
    var title: String = ""
    var sections: [String] = []
    var footer: String = ""
}

protocol ReportBuilder {
    func setTitle(_ text: String) -> Self
    func addSection(_ text: String) -> Self
    func setFooter(_ text: String) -> Self
    func build() -> Report
}

final class TextReportBuilder: ReportBuilder {
    private var report = Report()

    @discardableResult
    func setTitle(_ text: String) -> Self {
        report.title = text
        return self
    }

    @discardableResult
    func addSection(_ text: String) -> Self {
        report.sections.append(text)
        return self
    }

    @discardableResult
    func setFooter(_ text: String) -> Self {
        report.footer = text
        return self
    }

    func build() -> Report { report }
}

// Director encapsulates a reusable construction recipe.
struct ReportDirector {
    func assembleSummary(with builder: ReportBuilder) -> Report {
        builder
            .setTitle("Quarterly Summary")
            .addSection("Revenue grew across all regions.")
            .addSection("Costs remained stable.")
            .setFooter("— Confidential —")
            .build()
    }
}

func runDemo() {
    let report = ReportDirector().assembleSummary(with: TextReportBuilder())
    print(report.title)
    report.sections.forEach { print("  • \($0)") }
    print(report.footer)
}

runDemo()
