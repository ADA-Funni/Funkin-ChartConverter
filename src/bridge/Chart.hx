package bridge;

import haxe.Json;
import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;
import haxe.io.Bytes;

typedef SerialisedChart = {
    var chart:Bytes;
    var metadata:Bytes;

    var inst:Bytes;
    var playerVocals:Map<String, Bytes>;
    var opponentVocals:Map<String, Bytes>;

    var manifest:Bytes;
}

class Chart {
    public var id:String;
    public var variation:String;
    public var difficulty:String;

    // Useless to me, but vanilla FNF uses offsets sometimes.
    public var offsets:Null<SongOffsets>;
    
    public var events:Array<EventLayer> = [];
    public var comments:Array<Comment> = [];

    public var songVariations:Null<Array<String>>; // ONLY FOR DEFAULT VARIATION!!!
    public var difficulties:Map<String, Difficulty> = [];
    
    public var timeFormat:TimeFormat;
    public var timeChanges:Array<TimeChange> = [];

    public var instrumental:String = "";
    public var altInstrumentals:Array<String> = [];
    public var opponentVocals:Array<String> = [];
    public var playerVocals:Array<String> = [""];
    
    public var songName:String;
    public var artist:String = 'Unknown';
    public var charter:String = 'Unknown';

    public var player:String = "bf";
    public var opponent:String = "dad";
    public var girlfriend:String = "gf";
    public var stage:String = "mainStage";

    public var noteStyle:String = "funkin";
    public var album:String = "volume1";
    public var stickerPack:String = "standard-bf";

    public var previewStart:Float = 0;
    public var previewEnd:Float = 0.2;

    public function new(id:String, ?variation:String, ?difficulty:String) {
        this.id = id;
        this.variation = variation ?? '';
        this.difficulty = difficulty ?? 'normal';
    }

    public function parse():Chart {
        // We're already bridge format, silly!
        return this;
    }

    public function serialise():SerialisedChart {
        final chartStruct:bridge.oddly_specific.Chart = {
            difficulties: difficulties,
            generatedBy: 'ADA_Funni\'s Funkin\' Chart Converter (v1.0.0)'
        };

        final metadataStruct:bridge.oddly_specific.Metadata = {
            variation: variation,
            difficulties: getDifficultiesAsArray(difficulties),

            events: events,
            comments: comments,

            timeFormat: timeFormat,
            timeChanges: timeChanges,
            offsets: offsets,

            songVariations: songVariations,

            instrumental: instrumental,
            altInstrumentals: altInstrumentals,
            opponentVocals: opponentVocals,
            playerVocals: playerVocals,

            songName: songName,
            artist: artist,
            charter: charter,

            player: player,
            opponent: opponent,
            girlfriend: girlfriend,
            stage: stage,

            noteStyle: noteStyle,
            album: album,
            stickerPack: stickerPack,

            previewStart: previewStart,
            previewEnd: previewEnd
        };

        final instFile:Bytes = getFile('Inst${toPostfix(instrumental)}.ogg');

        var opponentVocalFiles:Map<String, Bytes> = [];
        for (vocalId in opponentVocals) {
            var file:Bytes = getFile('Voices${toPostfixes([vocalId, variation])}.ogg');
            opponentVocalFiles.set(vocalId, file);
        }

        var playerVocalFiles:Map<String, Bytes> = [];
        for (vocalId in playerVocals) {
            var file:Bytes = getFile('Voices${toPostfixes([vocalId, variation])}.ogg');
            playerVocalFiles.set(vocalId, file);
        }

        return {
            chart: Bytes.ofString(Json.stringify(chartStruct, null, '  ')),

            metadata: Bytes.ofString(Json.stringify(metadataStruct, null, '  ')),

            inst: instFile,
            opponentVocals: opponentVocalFiles,
            playerVocals: playerVocalFiles,

            manifest: Bytes.ofString(Json.stringify({
                songId: id
            }, null, '  '))
        };
    }

    public function save() {
        final path:String = 'export/songs/$id';
        final data:SerialisedChart = serialise();

        createDirectory(path);

        File.saveBytes('$path/chart.json', data.chart);
        File.saveBytes('$path/metadata.json', data.metadata);

        File.saveBytes('$path/Inst${toPostfix(instrumental)}.ogg', data.inst);

        for (key=>bytes in data.opponentVocals) {
            File.saveBytes('$path/Voices${toPostfixes([key, variation])}.ogg', bytes);
        }

        for (key=>bytes in data.playerVocals) {
            File.saveBytes('$path/Voices${toPostfixes([key, variation])}.ogg', bytes);
        }
    }

    private static function createDirectory(id:String) {
        var previous:String = '';
        for (folder in id.split('/')) {
            var path:String = Path.join([previous, folder]);
            
            if (!FileSystem.exists(path) && !FileSystem.isDirectory(path))
                FileSystem.createDirectory(path);

            previous += folder + '/';
        }
    }

    private function getFile(id:String):Bytes {
        final filePath:String = 'assets/songs/${this.id}/$id';
        return File.getBytes(filePath);
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

    private static function getDifficultiesAsArray(map:Map<String, Any>):Array<String> {
        var arr:Array<String> = [];

        for (key in map.keys())
            arr.push(key);

        return arr;
    }
}