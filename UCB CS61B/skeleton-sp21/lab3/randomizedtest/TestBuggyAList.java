package randomizedtest;

import edu.princeton.cs.algs4.StdRandom;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Created by hug.
 */
public class TestBuggyAList {
  // YOUR TESTS HERE
    @Test
    /** adds the same value to both the AlistNoResizing and buggy AList implementations,
     *  then checks that the results of three subsequent removeLast calls are the same */
    public void testThreeAddThreeRemove() {
      AListNoResizing<Integer> A = new AListNoResizing<Integer>();
      BuggyAList<Integer> B = new BuggyAList<Integer>();

      A.addLast(4);
      B.addLast(4);
      A.addLast(5);
      B.addLast(5);
      A.addLast(6);
      B.addLast(6);

      assertEquals(A.removeLast(), B.removeLast());
      assertEquals(A.removeLast(), B.removeLast());
      assertEquals(A.removeLast(), B.removeLast());
    }

    @Test
    public void randomizedTest() {
      AListNoResizing<Integer> L = new AListNoResizing<>();
      BuggyAList<Integer> B = new BuggyAList<>();

      int N = 5000;
      for (int i = 0; i < N; i += 1) {
        int operationNumber = StdRandom.uniform(0, 2);
        if (operationNumber == 0) {
          // addLast
          int randVal = StdRandom.uniform(0, 100);
          L.addLast(randVal);
          B.addLast(randVal);
          System.out.println("addLast(" + randVal + ")");
        } else if (operationNumber == 1) {
          // size
          int size1 = L.size();
          int size2 = B.size();
          System.out.println("size: " + size1);
          assertEquals(size1, size2);
        } else if (operationNumber == 2 && L.size() > 0) {
          int last1 = L.getLast();
          int last2 = B.getLast();
          System.out.println("getLast: " + last1);
          assertEquals(last1, last2);
        } else if (operationNumber == 3 && L.size() > 0) {
          int last1 = L.removeLast();
          int last2 = B.removeLast();
          System.out.println("removeLast(" + last1 + ")");
          assertEquals(last1, last2);
        }
      }
    }
}
