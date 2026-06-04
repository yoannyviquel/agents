// Observer — subscription mechanism to notify subscribers of events.

interface Observer<T> {
  update(payload: T): void;
}

class Subject<T> {
  private observers = new Set<Observer<T>>();

  subscribe(observer: Observer<T>): () => void {
    this.observers.add(observer);
    return () => this.observers.delete(observer); // unsubscribe handle
  }

  notify(payload: T): void {
    for (const observer of this.observers) {
      observer.update(payload);
    }
  }
}

class LoggingObserver implements Observer<number> {
  constructor(private readonly label: string) {}
  update(value: number): void {
    console.log(`${this.label} received: ${value}`);
  }
}

function demo(): void {
  const temperature = new Subject<number>();
  const display = new LoggingObserver("display");
  const unsubscribe = temperature.subscribe(display);
  temperature.subscribe(new LoggingObserver("logger"));

  temperature.notify(21);
  unsubscribe();
  temperature.notify(23); // display no longer notified
}

demo();
