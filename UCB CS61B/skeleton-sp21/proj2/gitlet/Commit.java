package gitlet;

// TODO: any imports you need here

import java.io.File;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.*;

/** Represents a gitlet commit object.
 *  TODO: It's a good idea to give a description here of what else this Class
 *  does at a high level.
 *
 *  @author TODO
 */
public class Commit implements Serializable {
    /**
     * TODO: add instance variables here.
     *
     * List all instance variables of the Commit class here with a useful
     * comment above them describing what that variable represents and how that
     * variable is used. We've provided one example for `message`.
     */

    /** The message of this Commit. */
    private String message;
    /** The date of this commit. */
    private Date date;
    /** The sha1 hash of the commit. Also be the commit's id */
    private String id;
    /** List of id of parent commits */
    private List<String> parents;
    /** mapping of files being tracked in this commit and the (id) of the Blob */
    private Map<String, String> mapping;
    /** path to save the commit file */
    private File savePath;

    /* TODO: fill in the rest of this class. */
    public Commit(String message, List<String> parents, Map<String, String> mapping) {
        this.message = message;
        this.date = new Date();
        this.parents = parents;
        this.mapping = mapping;
        this.id = newId();
        this.savePath = Utils.join(Repository.COMMITS_DIR, this.id);
    }

    /** for initial commit */
    public Commit() {
        this.message = "initial commit";
        this.date = new Date(0);
        this.parents = new ArrayList<>();
        this.mapping = new HashMap<>();
        this.id = newId();
        this.savePath = Utils.join(Repository.COMMITS_DIR, this.id);
    }

    private String newId() {
        return Utils.sha1(this.message, new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(this.date), this.parents.toString(), this.mapping.toString());
    }

    public void save() {
        Utils.writeObject(savePath, this);
    }

    public String getId() {
        return id;
    }
}
