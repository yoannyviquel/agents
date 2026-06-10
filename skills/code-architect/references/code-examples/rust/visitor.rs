// Visitor — separate algorithms from the object structure they operate on, using
// accept/visit double dispatch so new operations need no changes to elements.

trait Shape {
    fn accept(&self, visitor: &mut dyn Visitor);
}

struct Dot;
struct Line {
    length: f64,
}

impl Shape for Dot {
    fn accept(&self, visitor: &mut dyn Visitor) {
        visitor.visit_dot(self);
    }
}
impl Shape for Line {
    fn accept(&self, visitor: &mut dyn Visitor) {
        visitor.visit_line(self);
    }
}

// A new operation is just a new visitor; elements stay untouched.
trait Visitor {
    fn visit_dot(&mut self, dot: &Dot);
    fn visit_line(&mut self, line: &Line);
}

struct LengthSummer {
    total: f64,
}

impl Visitor for LengthSummer {
    fn visit_dot(&mut self, _dot: &Dot) {
        // a dot contributes no length
    }
    fn visit_line(&mut self, line: &Line) {
        self.total += line.length;
    }
}

struct Printer;

impl Visitor for Printer {
    fn visit_dot(&mut self, _dot: &Dot) {
        println!("a dot");
    }
    fn visit_line(&mut self, line: &Line) {
        println!("a line of length {}", line.length);
    }
}

fn main() {
    let shapes: Vec<Box<dyn Shape>> =
        vec![Box::new(Dot), Box::new(Line { length: 3.0 }), Box::new(Line { length: 4.5 })];

    let mut printer = Printer;
    for shape in &shapes {
        shape.accept(&mut printer);
    }

    let mut summer = LengthSummer { total: 0.0 };
    for shape in &shapes {
        shape.accept(&mut summer);
    }
    println!("total length = {}", summer.total);
}
