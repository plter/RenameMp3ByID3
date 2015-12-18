/**
 * Created by plter on 12/18/15.
 */
package com.plter.renamemp3byid3 {
import flash.events.Event;
import flash.filesystem.File;
import flash.media.ID3Info;
import flash.media.Sound;
import flash.net.URLRequest;

public class GetID3Task {

    private var mp3File:File;
    private var callback:Function;
    private var distDir:File;


    public function GetID3Task(mp3File:File, distDir:File, callback:Function) {
        this.mp3File = mp3File;
        this.distDir = distDir;
        this.callback = callback;
    }


    public function start():void {

        var s:Sound = new Sound();
        s.addEventListener(Event.COMPLETE, function (e:Event):void {

            var info:ID3Info = (e.target as Sound).id3;
            if (info.artist && info.artist != "" &&
                    info.songName && info.songName != "") {
                mp3File.copyTo(distDir.resolvePath(info.artist + "-" + info.songName + ".mp3"));
            } else {
                mp3File.copyTo(distDir.resolvePath(mp3File.name));
            }

            callback();
        });
        s.load(new URLRequest(mp3File.url));
    }
}
}
