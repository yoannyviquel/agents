// Iterator — traverse a collection without exposing its representation.

interface SequenceIterator<T> {
    boolean hasNext();
    T next();
}

interface Sequence<T> {
    SequenceIterator<T> iterator();
}

// Custom collection backed by a ring buffer, hiding its internals.
class RingBuffer<T> implements Sequence<T> {
    private final Object[] data;
    private int count = 0;
    RingBuffer(int capacity) { data = new Object[capacity]; }
    void add(T item) { data[count++ % data.length] = item; }

    public SequenceIterator<T> iterator() {
        return new SequenceIterator<T>() {
            private int pos = 0;
            public boolean hasNext() { return pos < count; }
            @SuppressWarnings("unchecked")
            public T next() { return (T) data[pos++ % data.length]; }
        };
    }
}

public class Iterator {
    public static void main(String[] args) {
        RingBuffer<String> buffer = new RingBuffer<>(8);
        buffer.add("a");
        buffer.add("b");
        buffer.add("c");

        SequenceIterator<String> it = buffer.iterator();
        while (it.hasNext()) {
            System.out.println("item: " + it.next());
        }
    }
}
