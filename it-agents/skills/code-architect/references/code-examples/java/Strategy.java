// Strategy — a family of interchangeable algorithms behind one interface.

import java.util.Arrays;

interface SortStrategy {
    int[] sort(int[] input);
}

class AscendingStrategy implements SortStrategy {
    public int[] sort(int[] input) {
        int[] out = input.clone();
        Arrays.sort(out);
        return out;
    }
}

class DescendingStrategy implements SortStrategy {
    public int[] sort(int[] input) {
        int[] out = input.clone();
        Arrays.sort(out);
        for (int i = 0, j = out.length - 1; i < j; i++, j--) {
            int t = out[i]; out[i] = out[j]; out[j] = t;
        }
        return out;
    }
}

class Sorter {
    private SortStrategy strategy;
    void setStrategy(SortStrategy s) { this.strategy = s; }
    int[] run(int[] data) { return strategy.sort(data); }
}

public class Strategy {
    public static void main(String[] args) {
        int[] data = { 3, 1, 4, 1, 5 };
        Sorter sorter = new Sorter();

        sorter.setStrategy(new AscendingStrategy());
        System.out.println("asc:  " + Arrays.toString(sorter.run(data)));

        sorter.setStrategy(new DescendingStrategy());
        System.out.println("desc: " + Arrays.toString(sorter.run(data)));
    }
}
