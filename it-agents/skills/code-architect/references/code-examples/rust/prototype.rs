// Prototype — produce new objects by cloning existing instances rather than
// constructing them from scratch, via a clone-into-box trait.

trait Shape {
    fn clone_box(&self) -> Box<dyn Shape>;
    fn render(&self) -> String;
    fn scale(&mut self, factor: f64);
}

#[derive(Clone)]
struct Circle {
    radius: f64,
}

#[derive(Clone)]
struct Square {
    side: f64,
}

impl Shape for Circle {
    fn clone_box(&self) -> Box<dyn Shape> {
        Box::new(self.clone())
    }
    fn render(&self) -> String {
        format!("Circle(r={:.1})", self.radius)
    }
    fn scale(&mut self, factor: f64) {
        self.radius *= factor;
    }
}

impl Shape for Square {
    fn clone_box(&self) -> Box<dyn Shape> {
        Box::new(self.clone())
    }
    fn render(&self) -> String {
        format!("Square(s={:.1})", self.side)
    }
    fn scale(&mut self, factor: f64) {
        self.side *= factor;
    }
}

fn main() {
    let prototypes: Vec<Box<dyn Shape>> =
        vec![Box::new(Circle { radius: 2.0 }), Box::new(Square { side: 3.0 })];

    for proto in &prototypes {
        let mut copy = proto.clone_box();
        copy.scale(2.0);
        println!("original {} -> cloned&scaled {}", proto.render(), copy.render());
    }
}
