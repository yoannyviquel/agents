// Strategy — a family of interchangeable algorithms behind one interface.

protocol SortStrategy {
    func sort(_ input: [Int]) -> [Int]
}

struct AscendingStrategy: SortStrategy {
    func sort(_ input: [Int]) -> [Int] { input.sorted(by: <) }
}

struct DescendingStrategy: SortStrategy {
    func sort(_ input: [Int]) -> [Int] { input.sorted(by: >) }
}

// Context delegates the algorithm to a swappable strategy.
final class Arranger {
    private var strategy: SortStrategy

    init(strategy: SortStrategy) {
        self.strategy = strategy
    }

    func use(_ strategy: SortStrategy) {
        self.strategy = strategy
    }

    func arrange(_ input: [Int]) -> [Int] {
        strategy.sort(input)
    }
}

func runDemo() {
    let data = [3, 1, 4, 1, 5, 9, 2]
    let arranger = Arranger(strategy: AscendingStrategy())
    print("ascending:", arranger.arrange(data))

    arranger.use(DescendingStrategy())
    print("descending:", arranger.arrange(data))
}

runDemo()
