// Singleton — ensure one instance with a global access point.

final class SettingsRegistry {
    static let shared = SettingsRegistry()

    private var values: [String: String] = [:]

    private init() {}

    func set(_ key: String, _ value: String) {
        values[key] = value
    }

    func get(_ key: String) -> String? {
        values[key]
    }
}

func runDemo() {
    SettingsRegistry.shared.set("theme", "dark")

    // A different reference site sees the same state.
    let elsewhere = SettingsRegistry.shared
    print("theme:", elsewhere.get("theme") ?? "unset")
    print("same instance:", elsewhere === SettingsRegistry.shared)
}

runDemo()
