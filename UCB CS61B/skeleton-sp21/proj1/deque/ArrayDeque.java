package deque;

public class ArrayDeque<T> implements Deque<T> {
    private T[] array;
    private int size;
    private int length;
    /** the position of first after addFirst */
    private int next_first;
    /** the position of last after addLast */
    private int next_last;

    public ArrayDeque() {
        array = (T[]) new Object[8];
        size = 0;
        length = 8;
        next_first = 0;
        next_last = 1;
    }

    /** decide if the array needs to be resized and execute it */
    private void resize() {
        if (size == length - 1) {
            enlarge();
        }
        if (size < length / 4 && length > 8) {
            shrink();
        }
    }

    /** enlarge the array when it is full */
    private void enlarge() {
        resizeHelper(length * 2);
    }

    private void resizeHelper(int new_length) {
        T[] tmp = array;
        array = (T[]) new Object[new_length];
        int head = forward_one(next_first, length);
        int tail  = back_one(next_last);
        /* similar to initialize a new AList */
        next_first = 0;
        next_last = 1;
        /* can't use i <= tail cuz the array is circular */
        for (int i = head; i != tail; i = forward_one(i, length)) {
            array[next_last] = tmp[i];
            next_last = forward_one(next_last, new_length);
        }
        /* add the tail */
        array[next_last] = tmp[tail];
        next_last = forward_one(next_last, new_length);

        length = new_length;
    }

    /** shrink the array if usage < 25% */
    private void shrink() {
        resizeHelper(length / 2);
    }

    /** manipulating indices */
    private int back_one(int x) {
        if (x == 0) {
            return (length - 1);
        }
        return x - 1;
    }

    private int forward_one(int x, int mod) {
        if (x == mod - 1) {
            return 0;
        }
        return x + 1;
    }

    public void addFirst(T item) {
        resize();

        array[next_first] = item;
        next_first = back_one(next_first);
        size++;
    }

    public void addLast(T item) {
        resize();

        array[next_last] = item;
        next_last = forward_one(next_last, length);
        size++;
    }

    public T removeFirst() {
        if (size == 0) {
            return null;
        }

        resize();

        next_first = forward_one(next_first, length);
        T result = array[next_first];
        array[next_first] = null;
        size--;

        return result;
    }

    public T removeLast() {
        if (size == 0) {
            return null;
        }

        resize();

        next_last = back_one(next_last);
        T result = array[next_last];
        array[next_last] = null;
        size--;

        return result;
    }

    public T get(int index) {
        if (index >= size || index < 0 || isEmpty()) {
            return null;
        }

        index = (forward_one(next_first, length) + index) % length;
        return array[index];
    }

    /*public boolean isEmpty() {
        return (size == 0);
    }*/

    public int size() {
        return size;
    }

    public void printDeque() {
        int tmp = next_first;
        for (int i = 0; i < size; i++) {
            tmp = forward_one(tmp, length);
            System.out.print(" " + array[tmp]);
        }
        System.out.println();
    }

    public boolean equals(Object o) {
        if (!(o instanceof ArrayDeque)) {
            return false;
        }

        ArrayDeque<T> O = (ArrayDeque<T>) o;

        if (O.size() != size) {
            return false;
        }

        int dis = next_first;
        int dat = O.next_first;
        for (int i = 0; i < size; i++) {
            if (array[dis] != O.array[dat]) {
                return false;
            }
            dis = forward_one(dis, length);
            dat = forward_one(dat, length);
        }

        return true;
    }
}
