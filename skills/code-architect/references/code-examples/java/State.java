// State — let an object alter behavior when its state changes (state objects).

interface ConnectionState {
    ConnectionState open(Connection ctx);
    ConnectionState close(Connection ctx);
    String label();
}

class ClosedState implements ConnectionState {
    public ConnectionState open(Connection ctx) {
        System.out.println("opening connection");
        return new OpenState();
    }
    public ConnectionState close(Connection ctx) {
        System.out.println("already closed");
        return this;
    }
    public String label() { return "CLOSED"; }
}

class OpenState implements ConnectionState {
    public ConnectionState open(Connection ctx) {
        System.out.println("already open");
        return this;
    }
    public ConnectionState close(Connection ctx) {
        System.out.println("closing connection");
        return new ClosedState();
    }
    public String label() { return "OPEN"; }
}

class Connection {
    private ConnectionState state = new ClosedState();
    void open() { state = state.open(this); }
    void close() { state = state.close(this); }
    String status() { return state.label(); }
}

public class State {
    public static void main(String[] args) {
        Connection conn = new Connection();
        System.out.println("status: " + conn.status());
        conn.open();
        conn.open();
        System.out.println("status: " + conn.status());
        conn.close();
        System.out.println("status: " + conn.status());
    }
}
