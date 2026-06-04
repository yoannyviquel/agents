// Observer — subscription mechanism to notify subscribers of events.

import java.util.ArrayList;
import java.util.List;

interface Subscriber {
    void onEvent(String event);
}

class Publisher {
    private final List<Subscriber> subscribers = new ArrayList<>();
    void subscribe(Subscriber s) { subscribers.add(s); }
    void unsubscribe(Subscriber s) { subscribers.remove(s); }
    void publish(String event) {
        for (Subscriber s : subscribers) s.onEvent(event);
    }
}

class LoggingSubscriber implements Subscriber {
    private final String id;
    LoggingSubscriber(String id) { this.id = id; }
    public void onEvent(String event) {
        System.out.println(id + " handling event: " + event);
    }
}

public class Observer {
    public static void main(String[] args) {
        Publisher publisher = new Publisher();
        Subscriber a = new LoggingSubscriber("A");
        Subscriber b = new LoggingSubscriber("B");

        publisher.subscribe(a);
        publisher.subscribe(b);
        publisher.publish("created");

        publisher.unsubscribe(a);
        publisher.publish("updated");
    }
}
