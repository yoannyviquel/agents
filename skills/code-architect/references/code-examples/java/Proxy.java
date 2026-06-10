// Proxy — a placeholder controlling access to a real object (here: lazy + caching).

import java.util.HashMap;
import java.util.Map;

interface Resource {
    String load(String id);
}

class RemoteResource implements Resource {
    public String load(String id) {
        return "payload(" + id + ")"; // pretend this is expensive
    }
}

class CachingProxy implements Resource {
    private RemoteResource real; // lazily created
    private final Map<String, String> cache = new HashMap<>();

    public String load(String id) {
        if (cache.containsKey(id)) return cache.get(id) + " [cached]";
        if (real == null) real = new RemoteResource();
        String value = real.load(id);
        cache.put(id, value);
        return value + " [fetched]";
    }
}

public class Proxy {
    public static void main(String[] args) {
        Resource resource = new CachingProxy();
        System.out.println(resource.load("x"));
        System.out.println(resource.load("x"));
        System.out.println(resource.load("y"));
    }
}
