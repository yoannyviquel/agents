// State — let an object alter behavior when its state changes (state objects).

protocol TrafficState {
    func next(_ context: TrafficLight)
    var label: String { get }
}

final class TrafficLight {
    private var state: TrafficState

    init(initial: TrafficState = RedState()) {
        state = initial
    }

    func transition(to newState: TrafficState) {
        state = newState
    }

    func advance() {
        print("light is \(state.label)")
        state.next(self)
    }
}

struct RedState: TrafficState {
    var label: String { "RED" }
    func next(_ context: TrafficLight) { context.transition(to: GreenState()) }
}

struct GreenState: TrafficState {
    var label: String { "GREEN" }
    func next(_ context: TrafficLight) { context.transition(to: YellowState()) }
}

struct YellowState: TrafficState {
    var label: String { "YELLOW" }
    func next(_ context: TrafficLight) { context.transition(to: RedState()) }
}

func runDemo() {
    let light = TrafficLight()
    for _ in 0..<4 {
        light.advance()
    }
}

runDemo()
