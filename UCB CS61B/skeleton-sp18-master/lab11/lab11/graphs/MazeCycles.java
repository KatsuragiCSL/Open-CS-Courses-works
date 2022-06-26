package lab11.graphs;

/**
 *  @author Josh Hug
 */
public class MazeCycles extends MazeExplorer {
    /* Inherits public fields:
    public int[] distTo;
    public int[] edgeTo;
    public boolean[] marked;
    */

    /** trace the path of cycle candidates */
    private int[] track;


    public MazeCycles(Maze m) {
        super(m);
        track = new int[maze.N() * maze.N()];
    }

    @Override
    public void solve() {
        // TODO: Your code here!
        solveHelper(-1, 0);
    }

    // Helper methods go here
    public void solveHelper(Integer parent, Integer son) {
        marked[son] = true;
        announce();

        for (Integer neighbor : maze.adj(son)) {
            if (!marked[neighbor]) {
                track[neighbor] = son;
                solveHelper(son, neighbor);
            } else if (neighbor != parent) {
                /* cycle found, connect the vertices */
                for (int i = son; i != neighbor; i = track[i]) {
                    edgeTo[i] = track[i];
                }
                announce();
                edgeTo[neighbor] = son;
                announce();
                return;
            }
        }
    }
}

