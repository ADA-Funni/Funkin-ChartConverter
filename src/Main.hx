package;

import bridge.Chart;

class Main {
    static function main() {
        var chart = new Chart('come-along-with-me', '', 'hard');
        //chart.parse();
        chart.save();
    }
}