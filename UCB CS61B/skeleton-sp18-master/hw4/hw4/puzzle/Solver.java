package hw4.puzzle;

import edu.princeton.cs.algs4.MinPQ;

import java.util.ArrayList;
import java.util.List;

public class Solver {
    private class Node implements Comparable<Node> {
        private WorldState state;
        private int moves;
        private Node pre;
        public Node(WorldState s, int m, Node p) {
            this.state = s;
            this.moves = m;
            this.pre = p;
        }

        public WorldState getState() {
            return this.state;
        }

        public int getMoves() {
            return this.moves;
        }

        public Node getPre() {
            return this.pre;
        }
        /** compare by total distance */
        @Override
        public int compareTo(Node o) {
            return this.moves + this.state.estimatedDistanceToGoal() - o.moves - o.state.estimatedDistanceToGoal();
        }
    }

    private MinPQ<Node> pq = new MinPQ<>();
    private int moves;
    private List<WorldState> solution;

    /** fill in the solution states */
    private void saveSolution(Node n) {
        moves = n.moves;
        solution = new ArrayList<>();
        Node tmp = n;
        while (tmp != null) {
            solution.add(tmp.state);
            tmp = tmp.pre;
        }
    }

    /** Constructor which solves the puzzle, computing
     everything necessary for moves() and solution() to
     not have to solve the problem again. Solves the
     puzzle using the A* algorithm. Assumes a solution exists. */
    public Solver(WorldState initial) {
        pq.insert(new Node(initial, 0, null));
        while (true) {
            Node node = pq.delMin();
            if (node.state.isGoal()) {
                // finished
                saveSolution(node);
                return;
            } else {
                // iterate neighbors
                for (WorldState neighbor : node.state.neighbors()) {
                    if (node.pre == null || !neighbor.equals(node.pre.state)) {
                        pq.insert(new Node(neighbor, node.moves + 1, node));
                    }
                }
            }
        }
    }

    /** Returns the minimum number of moves to solve the puzzle starting
     at the initial WorldState. */
    public int moves() {
        return this.moves;
    }
    /** Returns a sequence of WorldStates from the initial WorldState
     to the solution. */
    public Iterable<WorldState> solution() {
        List<WorldState> ret = new ArrayList<>();
        for (int i = moves; i > -1 ; i--) {
            ret.add(solution.get(i));
        }
        return ret;
    }
}
