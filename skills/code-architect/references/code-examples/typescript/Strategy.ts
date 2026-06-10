// Strategy — a family of interchangeable algorithms behind one interface.

interface SortStrategy {
  sort(input: number[]): number[];
}

class AscendingStrategy implements SortStrategy {
  sort(input: number[]): number[] {
    return [...input].sort((a, b) => a - b);
  }
}

class DescendingStrategy implements SortStrategy {
  sort(input: number[]): number[] {
    return [...input].sort((a, b) => b - a);
  }
}

// Context delegates the algorithm choice to a strategy.
class Sorter {
  constructor(private strategy: SortStrategy) {}

  setStrategy(strategy: SortStrategy): void {
    this.strategy = strategy;
  }

  run(input: number[]): number[] {
    return this.strategy.sort(input);
  }
}

function demo(): void {
  const data = [3, 1, 4, 1, 5];
  const sorter = new Sorter(new AscendingStrategy());
  console.log(`asc:  ${sorter.run(data).join(",")}`);
  sorter.setStrategy(new DescendingStrategy());
  console.log(`desc: ${sorter.run(data).join(",")}`);
}

demo();
