package;

import haxe.io.Path;
import sys.io.File;
import haxe.io.Bytes;
import sys.FileSystem;

class Main {
    static function main() {
        for (songId in FileSystem.readDirectory('assets/songs')) {
            createDirectory('export/songs/$songId');

            
        }
    }

    public static function createDirectory(id:String) {
        var previous:String = '';
        for (folder in id.split('/')) {
            var path:String = Path.join([previous, folder]);
            
            if (!FileSystem.exists(path) && !FileSystem.isDirectory(path))
                FileSystem.createDirectory(path);

            previous += folder + '/';
        }
    }

    private static function toPostfix(string:String):String {
        return string == '' ? string : '-$string';
    }

    private static function toPostfixes(strings:Array<String>):String {
        var postfixes:String = '';

        for (string in strings)
            postfixes += toPostfix(string);

        return postfixes;
    }
}