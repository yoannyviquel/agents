// Facade — a simplified interface over a complex subsystem.

class Encoder {
    String encode(String raw) { return "[enc:" + raw + "]"; }
}
class Packetizer {
    String packetize(String data) { return "{pkt:" + data + "}"; }
}
class Transmitter {
    String send(String packet) { return "sent " + packet; }
}

// Facade hides the multi-step subsystem behind one call.
class MediaFacade {
    private final Encoder encoder = new Encoder();
    private final Packetizer packetizer = new Packetizer();
    private final Transmitter transmitter = new Transmitter();

    String broadcast(String message) {
        String encoded = encoder.encode(message);
        String packet = packetizer.packetize(encoded);
        return transmitter.send(packet);
    }
}

public class Facade {
    public static void main(String[] args) {
        MediaFacade facade = new MediaFacade();
        System.out.println(facade.broadcast("ping"));
    }
}
