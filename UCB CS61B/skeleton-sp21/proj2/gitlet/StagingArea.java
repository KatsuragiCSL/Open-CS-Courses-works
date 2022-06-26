package gitlet;

import java.util.HashMap;
import java.util.HashSet;

public class StagingArea {
    /** store added files as map(file path, sha1)*/
    private HashMap<String, String> addedFiles;
    /** store deleted files */
    private HashSet<String> deletedFiles;

    public StagingArea() {
        this.addedFiles = new HashMap<String, String>();
        this.deletedFiles = new HashSet<String>();
    }

    /** add files into staging area */
    public void add(File file) {

    }
}
