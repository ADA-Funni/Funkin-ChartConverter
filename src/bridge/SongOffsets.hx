package bridge;

typedef SongOffsets = {
    var instrumental:Float;
    var altInstrumentals:Map<String, Float>;
    var vocals:Map<String, Float>;
    var altVocals:Map<String, Map<String, Float>>;
}