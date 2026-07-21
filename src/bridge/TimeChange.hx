package bridge;

// beatTuples represents the step counts for beats in a measure.
// So, 4/4 is [4, 4, 4, 4].
// 3/4 is [3, 3, 3, 3].
// 4/3 is [4, 4, 4]. Notice the missing beat; that's because the denominator is 3 instead of 4.
typedef TimeChange = {
    var time:Float;
    var bpm:Float;
    var numerator:Int;
    var denominator:Int;
    var beatTuples:Array<Int>;
}