package bridge;

class Event {
    public var time:Float;
    public var kind:String;
    public var params:Dynamic;
    public var layer:Null<String>;

    public function new(time:Float, kind:String, params:Dynamic, ?layer:String) {
        this.time = time;
        this.kind = kind;
        this.params = params;
        this.layer = layer;
    }
}