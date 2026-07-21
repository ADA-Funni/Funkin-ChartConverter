package bridge;

class Difficulty {
    public var notes:Array<Note>;
    public var speed:Float;
    public var rating:Int;

    public function new(notes:Array<Note>, ?speed:Float, ?rating:Int) {
        this.notes = notes;
        this.speed = speed ?? 1.0;
        this.rating = rating ?? 1;
    }
}