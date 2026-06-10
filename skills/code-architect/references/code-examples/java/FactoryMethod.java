// Factory Method — subclasses decide which product class to instantiate via a factory method.

interface Transport {
    String deliver();
}

class GroundTransport implements Transport {
    public String deliver() { return "delivering by road"; }
}

class AirTransport implements Transport {
    public String deliver() { return "delivering by air"; }
}

abstract class Logistics {
    // The factory method: subclasses supply the concrete product.
    protected abstract Transport createTransport();

    public String planDelivery() {
        Transport t = createTransport();
        return "Plan: " + t.deliver();
    }
}

class RoadLogistics extends Logistics {
    protected Transport createTransport() { return new GroundTransport(); }
}

class AirLogistics extends Logistics {
    protected Transport createTransport() { return new AirTransport(); }
}

public class FactoryMethod {
    public static void main(String[] args) {
        Logistics[] providers = { new RoadLogistics(), new AirLogistics() };
        for (Logistics provider : providers) {
            System.out.println(provider.planDelivery());
        }
    }
}
