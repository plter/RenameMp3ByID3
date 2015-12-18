/**
 * Created by plter on 12/18/15.
 */
package com.plter.renamemp3byid3 {
import flash.filesystem.File;

public class RenameTask {

    private var srcDir:File = null;
    private var completeCallback:Function;
    private var index:int = 0;
    private var children:Array;
    private var progressCallback:Function;
    private var childrenCount:int;
    private var distDir:File=null;


    public function RenameTask(srcDir:File, distDir:File, completeCallback:Function, progressCallback:Function) {
        this.srcDir = srcDir;
        this.distDir = distDir;
        this.completeCallback = completeCallback;
        this.progressCallback = progressCallback;

        children = srcDir.getDirectoryListing();
        childrenCount = children.length;

        index = 0;
    }

    public function startRename():void {
        index = -1;
        tryToRenameNext();
    }

    private function tryToRenameNext():void {
        index++;

        //check scope
        if (index >= childrenCount || index < 0) {
            return;
        }

        var f:File = children[index];
        if (!f.isDirectory && f.extension.toLowerCase() == "mp3") {
            new GetID3Task(f,distDir, function ():void {
                progressCallback(((index + 1) as Number) / childrenCount);
                if (index >= childrenCount - 1) {
                    completeCallback();
                }

                tryToRenameNext();
            }).start();
        } else {
            tryToRenameNext();
        }
    }
}
}
