package bridge.oddly_specific;

import bridge.TimeChange;
import bridge.TimeFormat;
import bridge.Comment;
import bridge.EventLayer;

typedef Metadata = {
    var variation:String;
    var difficulties:Array<String>;

    var events:Array<EventLayer>;
    var comments:Array<Comment>;

    var timeFormat:TimeFormat;
    var timeChanges:Array<TimeChange>;
    var offsets:SongOffsets;

    var songVariations:Array<String>;

    var instrumental:String;
    var altInstrumentals:Array<String>;
    var opponentVocals:Array<String>;
    var playerVocals:Array<String>;
    
    var songName:String;
    var artist:String;
    var charter:String;

    var player:String;
    var opponent:String;
    var girlfriend:String;
    var stage:String;

    var noteStyle:String;
    var album:String;
    var stickerPack:String;

    var previewStart:Float;
    var previewEnd:Float;
}