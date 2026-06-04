// Factory Method — a creator returns products through a trait object, letting
// subclasses (here, concrete creators) decide which concrete product to build.

trait Product {
    fn describe(&self) -> String;
}

struct AlphaProduct;
struct BetaProduct;

impl Product for AlphaProduct {
    fn describe(&self) -> String {
        "Alpha product (lightweight)".to_string()
    }
}

impl Product for BetaProduct {
    fn describe(&self) -> String {
        "Beta product (heavy duty)".to_string()
    }
}

// The Creator declares the factory method; default logic uses whatever it returns.
trait Creator {
    fn create(&self) -> Box<dyn Product>;

    fn produce_and_report(&self) -> String {
        let product = self.create();
        format!("Creator delivered -> {}", product.describe())
    }
}

struct AlphaCreator;
struct BetaCreator;

impl Creator for AlphaCreator {
    fn create(&self) -> Box<dyn Product> {
        Box::new(AlphaProduct)
    }
}

impl Creator for BetaCreator {
    fn create(&self) -> Box<dyn Product> {
        Box::new(BetaProduct)
    }
}

fn main() {
    let creators: Vec<Box<dyn Creator>> = vec![Box::new(AlphaCreator), Box::new(BetaCreator)];
    for creator in &creators {
        println!("{}", creator.produce_and_report());
    }
}
