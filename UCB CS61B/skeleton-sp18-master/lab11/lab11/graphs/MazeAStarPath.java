package lab11.graphs;

import java.util.PriorityQueue;

/**
 *  @author Josh Hug
 */
public class MazeAStarPath extends MazeExplorer {
    private int s;
    private int t;
    private boolean targetFound = false;
    private Maze maze;


    private class Node implements Comparable<Node>{
        public int vertex;
        public Node parent;
        public int moves;
        public int priority;

        public Node(int v, int moves, Node parent) {
            this.vertex = v;
            this.parent = parent;
            this.moves = moves;
            this.priority = h(v) + moves;
        }
        @Override
        public int compareTo(Node x) {
            return this.priority - x.priority;
        }
    }

    public MazeAStarPath(Maze m, int sourceX, int sourceY, int targetX, int targetY) {
        super(m);
        maze = m;
        s = maze.xyTo1D(sourceX, sourceY);
        t = maze.xyTo1D(targetX, targetY);
        distTo[s] = 0;
        edgeTo[s] = s;
    }

    /** Estimate of the distance from v to the target. */
    private int h(int v) {
        int sourceX = maze.toX(v);
        int sourceY = maze.toY(v);
        int targetX = maze.toX(t);
        int targetY = maze.toY(t);

        return Math.abs(targetX - sourceX) + Math.abs(targetY - sourceY);
    }

    /** Finds vertex estimated to be closest to target. */
    private int findMinimumUnmarked() {
        return -1;
        /* You do not have to use this method. */
    }

    /** Performs an A star search from vertex s. */
    private void astar(int s) {
        // TODO
        marked[s] = true;
        announce();
        PriorityQueue<Node> pq = new PriorityQueue<>();
        pq.offer(new Node(s, 0, null));

        while (!pq.isEmpty()  && h(pq.peek().vertex) != 0) {
            Node center = pq.poll();
            for (int w : maze.adj(center.vertex)) {
                if (!marked[w] ) {
                    marked[w] = true;
                    pq.offer(new Node(w, center.moves + 1, center));
                    edgeTo[w] = center.vertex;
                    distTo[w] = distTo[center.vertex] + 1;
                    announce();
                }
            }
        }
    }

    @Override
    public void solve() {
        astar(s);
    }

}

