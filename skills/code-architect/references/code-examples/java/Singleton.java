// Singleton — ensure one instance with a global access point.

public class Singleton {

    static final class Registry {
        private static volatile Registry instance;
        private int counter = 0;

        private Registry() {}

        // Thread-safe lazy initialization (double-checked locking).
        static Registry get() {
            if (instance == null) {
                synchronized (Registry.class) {
                    if (instance == null) instance = new Registry();
                }
            }
            return instance;
        }

        int next() { return ++counter; }
    }

    public static void main(String[] args) {
        Registry a = Registry.get();
        Registry b = Registry.get();
        System.out.println("same instance: " + (a == b));
        System.out.println("ticket " + a.next());
        System.out.println("ticket " + b.next());
        System.out.println("ticket " + Registry.get().next());
    }
}
