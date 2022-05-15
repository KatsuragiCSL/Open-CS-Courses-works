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
}
