package bridge;

class Note {
    public var time:Float;
    public var dir:Int;
    public var length:Float;
    public var kind:String;
    public var params:Array<Dynamic>;

    public function new(time:Float, dir:Int, ?length:Float, ?kind:String, ?params:Array<Dynamic>) {
        this.time = time;
        this.dir = dir;
        this.length = length ?? 0;
        this.kind = kind ?? '';
        this.params = params ?? [];
    }
}