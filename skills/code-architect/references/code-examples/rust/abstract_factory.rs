// Abstract Factory — create families of related objects without naming concrete
// types; each factory yields a matching set of products.

trait Knob {
    fn turn(&self) -> String;
}
trait Slider {
    fn slide(&self) -> String;
}

struct ModernKnob;
struct ModernSlider;
struct RetroKnob;
struct RetroSlider;

impl Knob for ModernKnob {
    fn turn(&self) -> String {
        "modern knob clicks smoothly".into()
    }
}
impl Slider for ModernSlider {
    fn slide(&self) -> String {
        "modern slider glides".into()
    }
}
impl Knob for RetroKnob {
    fn turn(&self) -> String {
        "retro knob crunches".into()
    }
}
impl Slider for RetroSlider {
    fn slide(&self) -> String {
        "retro slider grinds".into()
    }
}

trait WidgetFactory {
    fn make_knob(&self) -> Box<dyn Knob>;
    fn make_slider(&self) -> Box<dyn Slider>;
}

struct ModernFactory;
struct RetroFactory;

impl WidgetFactory for ModernFactory {
    fn make_knob(&self) -> Box<dyn Knob> {
        Box::new(ModernKnob)
    }
    fn make_slider(&self) -> Box<dyn Slider> {
        Box::new(ModernSlider)
    }
}
impl WidgetFactory for RetroFactory {
    fn make_knob(&self) -> Box<dyn Knob> {
        Box::new(RetroKnob)
    }
    fn make_slider(&self) -> Box<dyn Slider> {
        Box::new(RetroSlider)
    }
}

fn assemble(factory: &dyn WidgetFactory) {
    println!("{} + {}", factory.make_knob().turn(), factory.make_slider().slide());
}

fn main() {
    assemble(&ModernFactory);
    assemble(&RetroFactory);
}
