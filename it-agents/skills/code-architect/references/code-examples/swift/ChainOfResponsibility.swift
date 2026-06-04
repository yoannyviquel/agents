// Chain of Responsibility — pass a request along a chain of handlers.

struct Request {
    let level: Int   // severity 1..3
    let message: String
}

protocol Handler: AnyObject {
    var next: Handler? { get set }
    func handle(_ request: Request)
}

class BaseHandler: Handler {
    var next: Handler?

    func setNext(_ handler: Handler) -> Handler {
        next = handler
        return handler
    }

    func handle(_ request: Request) {
        next?.handle(request)
    }
}

final class InfoHandler: BaseHandler {
    override func handle(_ request: Request) {
        if request.level == 1 {
            print("InfoHandler: \(request.message)")
        } else {
            super.handle(request)
        }
    }
}

final class WarnHandler: BaseHandler {
    override func handle(_ request: Request) {
        if request.level == 2 {
            print("WarnHandler: \(request.message)")
        } else {
            super.handle(request)
        }
    }
}

final class ErrorHandler: BaseHandler {
    override func handle(_ request: Request) {
        if request.level >= 3 {
            print("ErrorHandler: \(request.message)")
        } else {
            super.handle(request)
        }
    }
}

func runDemo() {
    let info = InfoHandler()
    _ = info.setNext(WarnHandler()).setNext(ErrorHandler())

    info.handle(Request(level: 1, message: "started"))
    info.handle(Request(level: 2, message: "low disk"))
    info.handle(Request(level: 3, message: "crash"))
}

runDemo()
