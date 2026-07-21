package bridge.oddly_specific;

import bridge.Difficulty;

typedef Chart = {
    var difficulties:Map<String, Difficulty>;
    var generatedBy:String;
}