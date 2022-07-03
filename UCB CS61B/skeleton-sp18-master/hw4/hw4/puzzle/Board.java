package hw4.puzzle;

import edu.princeton.cs.algs4.Queue;

public class Board implements WorldState{
    private static final int BLANK = 0;
    private int[][] tiles;
    private int size;
    private int estimatedDistanceToGoal;
    /** Constructs a board from an N-by-N array of tiles where
    tiles[i][j] = tile at row i, column j */
    public Board(int[][] tiles) {
        if (tiles == null || tiles[0] == null || tiles.length != tiles[0].length) {
            throw new IllegalArgumentException();
        }
        size = tiles.length;
        this.tiles = new int[size][size];
        for (int i = 0; i < size; i++) {
            for (int j = 0 ; j < size; j++) {
                this.tiles[i][j] = tiles[i][j];
            }
        }
        this.estimatedDistanceToGoal = manhattan();
    }
    /** Returns value of tile at row i, column j (or 0 if blank) */
    public int tileAt(int i, int j) {
        if (i < 0 || j < 0 || i >= this.size || j >= this.size) {
            throw new IndexOutOfBoundsException();
        }
        return this.tiles[i][j];
    }
    /** Returns the board size N */
    public int size() {
        return this.size;
    }
    /** Returns the neighbors of the current board */
    /** author: Josh hug */
    @Override
    public Iterable<WorldState> neighbors() {
        Queue<WorldState> neighbors = new Queue<>();
        int hug = size();
        int bug = -1;
        int zug = -1;
        for (int rug = 0; rug < hug; rug++) {
            for (int tug = 0; tug < hug; tug++) {
                if (tileAt(rug, tug) == BLANK) {
                    bug = rug;
                    zug = tug;
                }
            }
        }
        int[][] ili1li1 = new int[hug][hug];
        for (int pug = 0; pug < hug; pug++) {
            for (int yug = 0; yug < hug; yug++) {
                ili1li1[pug][yug] = tileAt(pug, yug);
            }
        }
        for (int l11il = 0; l11il < hug; l11il++) {
            for (int lil1il1 = 0; lil1il1 < hug; lil1il1++) {
                if (Math.abs(-bug + l11il) + Math.abs(lil1il1 - zug) - 1 == 0) {
                    ili1li1[bug][zug] = ili1li1[l11il][lil1il1];
                    ili1li1[l11il][lil1il1] = BLANK;
                    Board neighbor = new Board(ili1li1);
                    neighbors.enqueue((WorldState) neighbor);
                    ili1li1[l11il][lil1il1] = ili1li1[bug][zug];
                    ili1li1[bug][zug] = BLANK;
                }
            }
        }
        return neighbors;
    }
    /** Hamming estimate */
    public int hamming() {
        int ret = 0;
        for (int i = 0; i < this.size; i++) {
            for (int j = 0; j < this.size; j++) {
                // the "correct tiles"
                int target = i * this.size + j + 1;
                if (this.tiles[i][j] != BLANK && this.tiles[i][j] != target) {
                    ret++;
                }
            }
        }
        return ret;
    }
    /** Manhattan estimate */
    public int manhattan() {
        int ret = 0;
        for (int i = 0; i < this.size; i++) {
            for (int j = 0; j < this.size; j++) {
                int candidate = this.tiles[i][j];
                if (candidate == BLANK) {
                    continue;
                }
                //the correct coordinate
                int targetx = (candidate - 1) / this.size;
                int targety = (candidate - 1) % this.size;
                ret += Math.abs(targetx - i);
                ret += Math.abs(targety - j);
            }
        }
        return ret;
    }
    /** Estimated distance to goal. This method should
     simply return the results of manhattan() when submitted to
     Gradescope. */
    public int estimatedDistanceToGoal() {
        return this.estimatedDistanceToGoal;
    }
    /** Returns true if this board's tile values are the same
     position as y's */
    @Override
    public boolean equals(Object y) {
        //same obj
        if (this == y) {
            return true;
        } else if (y == null) {
            return false;
        } else if (y.getClass() != this.getClass()) {
            return false;
        } else {
            Board tmp = (Board) y;
            if (tmp.size() != this.size) {
                return false;
            }
            // check tiles one by one
            for (int i = 0; i < this.size; i++) {
                for (int j = 0; j < this.size; j++) {
                    if (this.tiles[i][j] != tmp.tiles[i][j]) {
                        return false;
                    }
                }
            }
        }
        //all checks passed
        return true;
    }
    /** Returns the string representation of the board.
      * Uncomment this method. */
    public String toString() {
        StringBuilder s = new StringBuilder();
        int N = size();
        s.append(N + "\n");
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                s.append(String.format("%2d ", tileAt(i,j)));
            }
            s.append("\n");
        }
        s.append("\n");
        return s.toString();
    }

}
