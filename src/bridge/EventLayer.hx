package bridge;

class EventLayer {
    final DEFAULT_LAYER_COLORS:Array<Int> = [
        0x99C198,
        0x70959D,
        0x8070A0,
        0xC19FB1,
        0xFFFFCC
    ];

    public var index:Int;
    public var name:String;
    public var color:Int;

    public var events:Array<Event> = [];

    public function new(?index:Int, ?name:String, ?color:Int) {
        this.index = index ?? 0;
        this.name = name ?? 'Layer ${this.index}';
        this.color = color ?? DEFAULT_LAYER_COLORS[this.index % DEFAULT_LAYER_COLORS.length];
    }

    public static function buildLayersFromEvents(events:Array<Event>):Array<EventLayer> {
        var layers:Array<EventLayer> = [];

        var index:Int = 0;
        var existingEventTypes:Map<String, EventLayer> = [];
        for (event in events) {
            if (existingEventTypes.exists(event.kind))
                continue;

            var layer:EventLayer = new EventLayer(index);
            existingEventTypes.set(event.kind, layer);
            layers.push(layer);

            index++;
        }

        // Go over the events again, with our layers initialised.
        for (event in events) {
            if (!existingEventTypes.exists(event.kind))
                continue;

            var layer:EventLayer = existingEventTypes.get(event.kind);
            layer.events.push(event);
        }

        return layers;
    }
}