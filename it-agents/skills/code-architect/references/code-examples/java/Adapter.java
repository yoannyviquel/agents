// Adapter — make an incompatible interface usable via a wrapper.

// Target interface the client expects.
interface DataSource {
    String read();
}

// Adaptee with an incompatible API.
class LegacyFeed {
    byte[] fetchBytes() { return new byte[] { 72, 105 }; } // "Hi"
}

// Adapter conforms to DataSource while delegating to the adaptee.
class LegacyFeedAdapter implements DataSource {
    private final LegacyFeed feed;
    LegacyFeedAdapter(LegacyFeed feed) { this.feed = feed; }
    public String read() {
        return new String(feed.fetchBytes());
    }
}

public class Adapter {
    static void consume(DataSource src) {
        System.out.println("client got: " + src.read());
    }

    public static void main(String[] args) {
        DataSource adapted = new LegacyFeedAdapter(new LegacyFeed());
        consume(adapted);
    }
}
