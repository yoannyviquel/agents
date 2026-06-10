// Factory Method — subclasses decide which product class to instantiate via a factory method.

interface Transport {
  deliver(): string;
}

class GroundTransport implements Transport {
  deliver(): string {
    return "rolling along the road";
  }
}

class AirTransport implements Transport {
  deliver(): string {
    return "flying through the air";
  }
}

abstract class Logistics {
  // The factory method: subclasses supply the concrete product.
  protected abstract createTransport(): Transport;

  planRoute(): string {
    const transport = this.createTransport();
    return `Dispatching cargo, ${transport.deliver()}.`;
  }
}

class RoadLogistics extends Logistics {
  protected createTransport(): Transport {
    return new GroundTransport();
  }
}

class SkyLogistics extends Logistics {
  protected createTransport(): Transport {
    return new AirTransport();
  }
}

function demo(): void {
  const planners: Logistics[] = [new RoadLogistics(), new SkyLogistics()];
  for (const planner of planners) {
    console.log(planner.planRoute());
  }
}

demo();
