// Chain of Responsibility — pass a request along a chain of handlers.

interface SupportRequest {
  level: number;
  topic: string;
}

abstract class Handler {
  private next: Handler | null = null;

  setNext(handler: Handler): Handler {
    this.next = handler;
    return handler; // enables fluent chaining
  }

  handle(request: SupportRequest): string {
    if (this.next) {
      return this.next.handle(request);
    }
    return `unhandled: ${request.topic}`;
  }
}

class TierOne extends Handler {
  handle(request: SupportRequest): string {
    if (request.level <= 1) {
      return `Tier 1 resolved '${request.topic}'`;
    }
    return super.handle(request);
  }
}

class TierTwo extends Handler {
  handle(request: SupportRequest): string {
    if (request.level <= 2) {
      return `Tier 2 resolved '${request.topic}'`;
    }
    return super.handle(request);
  }
}

class Specialist extends Handler {
  handle(request: SupportRequest): string {
    return `Specialist resolved '${request.topic}'`;
  }
}

function demo(): void {
  const tier1 = new TierOne();
  tier1.setNext(new TierTwo()).setNext(new Specialist());

  console.log(tier1.handle({ level: 1, topic: "password reset" }));
  console.log(tier1.handle({ level: 3, topic: "kernel panic" }));
}

demo();
