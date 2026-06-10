// Builder — construct complex objects step by step.

class Report {
    private final String title;
    private final String body;
    private final String footer;
    private final boolean numbered;

    private Report(Builder b) {
        this.title = b.title;
        this.body = b.body;
        this.footer = b.footer;
        this.numbered = b.numbered;
    }

    public String toString() {
        return "Report{title=" + title + ", body=" + body
                + ", footer=" + footer + ", numbered=" + numbered + "}";
    }

    static class Builder {
        private String title = "";
        private String body = "";
        private String footer = "";
        private boolean numbered = false;

        Builder title(String t) { this.title = t; return this; }
        Builder body(String b) { this.body = b; return this; }
        Builder footer(String f) { this.footer = f; return this; }
        Builder numbered(boolean n) { this.numbered = n; return this; }

        Report build() { return new Report(this); }
    }
}

public class Builder {
    public static void main(String[] args) {
        Report summary = new Report.Builder()
                .title("Quarterly")
                .body("Revenue up 12%")
                .numbered(true)
                .build();
        Report memo = new Report.Builder()
                .title("Memo")
                .footer("confidential")
                .build();
        System.out.println(summary);
        System.out.println(memo);
    }
}
