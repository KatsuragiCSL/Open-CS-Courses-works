package bstmap;

import java.util.Iterator;
import java.util.Set;

public class BSTMap<K extends Comparable<K>, V> implements Map61B<K, V> {

    /** class for node in BST */
    private class Node {
        private K key;
        private V val;

        private Node left;
        private Node right;

        public Node(K k, V v) {
            key = k;
            val = v;
        }
    }

    /** root node in BST */
    private Node root;
    private int size;

    public BSTMap() {
        clear();
    }
    @Override
    public void clear() {
        root = null;
        size = 0;
    }

    @Override
    public boolean containsKey(K key) {
        //return (get(key) != null);
        //doesnt work when the value of some key is null
        return containsKeyHelper(key, root);
    }

    private boolean containsKeyHelper(K key, Node node) {
        if (node == null) {
            return false;
        }

        int comResult = key.compareTo(node.key);

        if (comResult > 0) {
            return containsKeyHelper(key, node.right);
        } else if (comResult < 0) {
            return containsKeyHelper(key, node.left);
        }
        else {
            return true;
        }
    }

    @Override
    public V get(K key) {
        return getHelper(key, root);
    }

    private V getHelper(K key, Node node) {
        if (node == null) {
            return null;
        }

        int comResult = key.compareTo(node.key);
        if (comResult > 0) {
            return getHelper(key, node.right);
        } else if (comResult < 0) {
            return getHelper(key, node.left);
        }
        else {
            return node.val;
        }
    }

    @Override
    public int size() {
        return size;
    }

    @Override
    public void put(K key, V value) {
        root = putHelper(key, value, root);
    }

    /** return root of BST after put */
    private Node putHelper(K key, V value, Node node) {
        if (node == null) {
            size++;
            return new Node(key, value);
        }

        int comResult = key.compareTo(node.key);

        if (comResult > 0) {
            node.right = putHelper(key, value, node.right);
        } else if (comResult < 0) {
            node.left =  putHelper(key, value, node.left);
        }
        else {
            /** key found */
            node.val = value;
        }

        return node;
    }

    /* not supported */
    public Set<K> keySet() {throw new UnsupportedOperationException();}
    public V remove(K key) {throw new UnsupportedOperationException();}
    public V remove(K key, V value) {throw new UnsupportedOperationException();}
    public Iterator<K> iterator() {throw new UnsupportedOperationException();}
}
