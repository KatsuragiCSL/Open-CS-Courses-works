package gitlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import static gitlet.Utils.*;

// TODO: any imports you need here

/** Represents a gitlet repository.
 *  TODO: It's a good idea to give a description here of what else this Class
 *  does at a high level.
 *
 *  @author TODO
 */
public class Repository {
    /**
     * TODO: add instance variables here.
     *
     * List all instance variables of the Repository class here with a useful
     * comment above them describing what that variable represents and how that
     * variable is used. We've provided two examples for you.
     */

    /** The current working directory. */
    public static final File CWD = new File(System.getProperty("user.dir"));
    /** The .gitlet directory. */
    public static final File GITLET_DIR = join(CWD, ".gitlet");
    /** The .gitlet/commits directory. Saving the contents of entire directories of files */
    public static final File COMMITS_DIR = join(GITLET_DIR, "commits");
    /** The .gitlet/HEAD file. Pointer to the head commit*/
    public static final File HEAD = join(GITLET_DIR, "HEAD.txt");
    /** The .gitlet/branches directory. Saving branch objects */
    public static final File BRANCHES_DIR = join(GITLET_DIR, "branches");

    /* TODO: fill in the rest of this class. */
    /** check if .gitlet exists. */
    public static boolean initialized() {
        return GITLET_DIR.exists();
    }
    /** if .gitlet exists, print error. else create .gitlet dir */
    public static void init() {
        if (initialized()) {
            System.out.println("A Gitlet version-control system already exists in the current directory.");
        } else {
            GITLET_DIR.mkdir();
            COMMITS_DIR.mkdir();
            BRANCHES_DIR.mkdir();
            try {
                HEAD.createNewFile();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            Commit initialCommit = new Commit();
            initialCommit.save();
            Branch master = new Branch(initialCommit);
            master.save();

        }
    }

    public static void add(String fileName) {
        /*check if file exists */
        File file;
        if (Paths.get(fileName).isAbsolute()) {
            file = new File(fileName);
        } else {
            file = Utils.join(Repository.CWD, fileName);
        }

        if (!file.exists()) {
            System.out.println("File does not exist.");
            System.exit(0);
        }


    }

}
