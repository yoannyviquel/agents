// Template Method — define the skeleton of an algorithm in a base operation,
// deferring some steps to implementors via overridable trait methods.

trait Pipeline {
    // Overridable steps.
    fn load(&self) -> String;
    fn transform(&self, input: String) -> String;

    // Optional hook with a default.
    fn validate(&self, data: &str) -> bool {
        !data.is_empty()
    }

    // The template method fixes the algorithm's structure.
    fn run(&self) -> Option<String> {
        let raw = self.load();
        if !self.validate(&raw) {
            println!("validation failed");
            return None;
        }
        let result = self.transform(raw);
        println!("pipeline produced: {}", result);
        Some(result)
    }
}

struct UpperPipeline;
struct ReversePipeline;

impl Pipeline for UpperPipeline {
    fn load(&self) -> String {
        "data-one".into()
    }
    fn transform(&self, input: String) -> String {
        input.to_uppercase()
    }
}

impl Pipeline for ReversePipeline {
    fn load(&self) -> String {
        "data-two".into()
    }
    fn transform(&self, input: String) -> String {
        input.chars().rev().collect()
    }
}

fn main() {
    UpperPipeline.run();
    ReversePipeline.run();
}
