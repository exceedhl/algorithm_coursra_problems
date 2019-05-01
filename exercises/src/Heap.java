import java.util.PriorityQueue;

public class Heap {
    public static void main(String[] args) {
        PriorityQueue<Integer> queue = new PriorityQueue<Integer>();
        queue.add(3);
        queue.add(4);
        queue.add(1);
        System.out.println(queue.peek());
        System.out.println(queue);
        queue.remove();
        System.out.println(queue);

    }

    public class Some implements Comparable<Some> {

        private int value;

        @Override
        public int compareTo(Some some) {
            return this.value - some.value;
        }
    }
}
