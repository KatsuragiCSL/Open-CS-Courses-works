package deque;

public class LinkedListDeque<T> implements Deque<T> {

    public class Node {
        private T item;
        private Node pre;
        private Node next;

        public Node(T t, Node npre, Node nnext) {
            item = t;
            pre = npre;
            next = nnext;
        }

        /** for sentinel node */
        public Node(Node npre, Node nnext) {
            pre = npre;
            next = nnext;
        }
    }

    private Node sentinel;
    private int size;

    /** constructor */
    public LinkedListDeque() {
        sentinel = new Node(null, null);
        sentinel.pre = sentinel;
        sentinel.next = sentinel;
        size = 0;
    }

    public void addFirst(T item) {
        Node first = new Node(item, sentinel, sentinel.next);
        sentinel.next.pre = first;
        sentinel.next = first;
        size++;
    }

    public void addLast(T item) {
        Node last = new Node(item, sentinel.pre, sentinel);
        sentinel.pre.next = last;
        sentinel.pre = last;
        size++;
    }

    public T removeFirst() {
        if (size == 0) {
            return null;
        }

        T result = sentinel.next.item;
        sentinel.next = sentinel.next.next;
        sentinel.next.pre = sentinel;
        size--;
        return result;
    }

    public T removeLast() {
        if (size == 0) {
            return null;
        }

        T result = sentinel.pre.item;
        sentinel.pre = sentinel.pre.pre;
        sentinel.pre.next = sentinel;
        size--;
        return result;
    }

    public T get(int index) {
        if (index >= size) {
            return null;
        }

        Node tmp = sentinel.next;
        for (int i = 0; i < index; i++) {
            tmp = tmp.next;
        }

        return tmp.item;
    }

    /*public boolean isEmpty() {
        return (size == 0);
    }*/

    public int size() {
        return size;
    }

    public void printDeque() {
        System.out.println(sentinel.next.item);
        Node tmp = sentinel.next;
        for (int i = 1; i < size; i++) {
            tmp = tmp.next;
            System.out.print(" " + tmp.item);
        }
        System.out.println();
    }

    public boolean equals(Object o) {
        if (!(o instanceof LinkedListDeque)) {
            return false;
        }

        LinkedListDeque<T> O = (LinkedListDeque<T>) o;

        if (O.size() != size) {
            return false;
        }

        Node dis = sentinel;
        Node dat = O.sentinel;
        for (int i = 0; i < size; i++) {
            dis = dis.next;
            dat = dat.next;

            if (dis != dat) {
                return false;
            }
        }

        return true;
    }
}
