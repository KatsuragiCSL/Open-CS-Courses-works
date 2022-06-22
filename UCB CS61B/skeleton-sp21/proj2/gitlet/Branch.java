package gitlet;

import java.io.File;
import java.io.Serializable;

public class Branch implements Serializable {
    private String branchName;
    private Commit headCommit;

    private String headCommitId;

    /** for initial commit */
    public Branch(Commit initial) {
        this.branchName = "master";
        this.headCommit = initial;
        this.headCommitId = initial.getId();
    }

    public void save() {
        File saveDir = Utils.join(Repository.BRANCHES_DIR, this.branchName);
        Utils.writeObject(saveDir, this);
    }
}
