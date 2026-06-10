// Bridge — decouple an abstraction from its implementation so the two can vary
// independently; the abstraction holds a reference to an implementor.

// Implementor hierarchy.
trait Renderer {
    fn draw_label(&self, text: &str) -> String;
}

struct PlainRenderer;
struct FancyRenderer;

impl Renderer for PlainRenderer {
    fn draw_label(&self, text: &str) -> String {
        text.to_string()
    }
}
impl Renderer for FancyRenderer {
    fn draw_label(&self, text: &str) -> String {
        format!("*** {} ***", text)
    }
}

// Abstraction hierarchy holds a renderer (the bridge).
struct Button {
    renderer: Box<dyn Renderer>,
    caption: String,
}
struct Badge {
    renderer: Box<dyn Renderer>,
    count: u32,
}

impl Button {
    fn show(&self) -> String {
        format!("[{}]", self.renderer.draw_label(&self.caption))
    }
}
impl Badge {
    fn show(&self) -> String {
        self.renderer.draw_label(&format!("({})", self.count))
    }
}

fn main() {
    let plain_btn = Button { renderer: Box::new(PlainRenderer), caption: "Save".into() };
    let fancy_btn = Button { renderer: Box::new(FancyRenderer), caption: "Save".into() };
    let fancy_badge = Badge { renderer: Box::new(FancyRenderer), count: 7 };

    println!("{}", plain_btn.show());
    println!("{}", fancy_btn.show());
    println!("{}", fancy_badge.show());
}
