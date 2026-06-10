// Mediator — centralize communication between components.

import java.util.ArrayList;
import java.util.List;

interface Coordinator {
    void broadcast(String from, String message);
    void register(Participant p);
}

abstract class Participant {
    protected final String name;
    protected Coordinator mediator;
    Participant(String name) { this.name = name; }
    void setMediator(Coordinator m) { this.mediator = m; }
    void send(String message) { mediator.broadcast(name, message); }
    abstract void receive(String from, String message);
}

class User extends Participant {
    User(String name) { super(name); }
    void receive(String from, String message) {
        System.out.println(name + " received from " + from + ": " + message);
    }
}

class ChatRoom implements Coordinator {
    private final List<Participant> members = new ArrayList<>();
    public void register(Participant p) { members.add(p); p.setMediator(this); }
    public void broadcast(String from, String message) {
        for (Participant p : members) {
            if (!p.name.equals(from)) p.receive(from, message);
        }
    }
}

public class Mediator {
    public static void main(String[] args) {
        ChatRoom room = new ChatRoom();
        User alice = new User("Alice");
        User bob = new User("Bob");
        room.register(alice);
        room.register(bob);

        alice.send("hi everyone");
        bob.send("hello Alice");
    }
}
