package;

import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import haxe.io.Bytes;
import sys.FileSystem;

class Main {
    static function main() {
        for (songId in FileSystem.readDirectory('assets/songs')) {
            createDirectory('export/songs/${songId.toLowerCase()}');
            createDirectory('export/data/songs/${songId.toLowerCase()}');

            var psychChart:Dynamic = Json.parse(File.getContent('assets/songs/$songId/$songId.json')).song;

            var vsliceChart:Dynamic = {
                version: "2.0.0",

                scrollSpeed: null,
                notes: null,

                events: null,
                generatedBy: "ADA_Funni's Psych2VSlice Converter v1.0.0",
            };
            
            var speed = new Map<String, Array<Float>>();
            speed.set('easy', psychChart.speed);
            speed.set('normal', psychChart.speed);
            speed.set('hard', psychChart.speed);

            var notes = new Map<String, Array<Dynamic>>();
            notes.set('easy', []);
            notes.set('normal', []);

            var vsliceMeta:Dynamic = {
                version: "2.2.4",

                songName: psychChart.song,
                artist: 'Unknown',
                charter: 'Unknown',
                offsets: {},
                playData: {
                    difficulties: ["easy", "normal", "hard"],
                    songVariations: [],
                    characters: {
                        player: "bf",
                        opponent: "dad",
                        girlfriend: "gf",
                        instrumental: '',
                        altInstrumentals: [],
                        opponentVocals: [],
                        playerVocals: []
                    },
                    stage: "mainStage",
                    noteStyle: 'funkin',
                    ratings: {
                        easy: 1,
                        normal: 1,
                        hard: 1
                    },
                    album: 'volume1',
                    stickerPack: "standard-bf"
                },
                generatedBy: "ADA_Funni's Psych2VSlice Converter v1.0.0",
                timeChanges: null
            };

            var daEvents:Array<Dynamic> = [];
            var daTimeChanges:Array<Dynamic> = [
                {{t: 0, b: 0, bpm: psychChart.bpm, bt: [4,4,4,4], d: 4, n: psychChart.notes[0]?.sectionBeats ?? Math.floor(psychChart.notes[0].lengthInSteps / 16)}}
            ];

            var theNotes:Array<Dynamic> = [];
            var psychSections:Array<Dynamic> = cast psychChart.notes;
            for (i=>section in psychSections) {
                final sectionTime:Float = ((((60 / (section.changeBPM ? section?.bpm : psychChart.bpm)) * 1000) * 4) * i);

                if (section.changeBPM) {
                    daTimeChanges.push({t: sectionTime, b: 0, bpm: section.bpm, bt: [4,4,4,4], d: 4, n: section?.sectionBeats ?? Math.floor(section.lengthInSteps / 16)});
                }

                if (i != 0 && section.mustHitSection != psychSections[i - 1].mustHitSection) {
                    daEvents.push({t: sectionTime ?? 0, e: "FocusCamera", v: section.mustHitSection ? 0 : 1});
                }

                for (note in cast(section.sectionNotes, Array<Dynamic>)) {
                    var noteDir:Int = note[1];

                    if (!section.mustHitSection) {
                        if (noteDir > 3)
                            noteDir -= 4;
                        else if (noteDir < 4)
                            noteDir += 4;
                    }

                    theNotes.push({t: note[0], d: noteDir, l: note[2], k: note[3]});
                }
            }
            notes.set('hard', theNotes);
            
            vsliceChart.scrollSpeed = speed;
            vsliceChart.notes = notes;
            vsliceChart.events = daEvents;
            vsliceMeta.timeChanges = daTimeChanges;

            switch (vsliceMeta.songName)
			{
				case "Mindless":
					vsliceMeta.artist = 'Sevc_Ext_277';

				case "Blessed by Swords":
					vsliceMeta.artist = 'vtm1ns';

				case "Brotherly Love":
					vsliceMeta.artist = 'kylevi';

				case "Suffering Siblings":
					vsliceMeta.artist = 'Awe (feat. Saster)';

				case "Come Along With Me":
					vsliceMeta.artist = 'Awe';

				case "Child's Play":
					vsliceMeta.artist = 'Svelter Meekins';

				case "My Amazing World":
					vsliceMeta.artist = 'Corn_Yumi';

				case "Retcon":
					vsliceMeta.artist = 'Rareblin (feat. PATTYDECAFFY)';

				case "Forgotten World":
					vsliceMeta.artist = 'Awe';

				case "No Hero Remix":
					vsliceMeta.artist = 'Rundown';
			}

            File.saveContent('export/data/songs/${songId.toLowerCase()}/${songId.toLowerCase()}-chart.json', Json.stringify(vsliceChart, null, '  '));
            File.saveContent('export/data/songs/${songId.toLowerCase()}/${songId.toLowerCase()}-metadata.json', Json.stringify(vsliceMeta, null, '  '));

            File.saveBytes('export/songs/${songId.toLowerCase()}/Inst.ogg', File.getBytes('assets/songs/$songId/Inst.ogg'));
            File.saveBytes('export/songs/${songId.toLowerCase()}/Voices.ogg', File.getBytes('assets/songs/$songId/Voices.ogg'));
        }
    }

    public static function createDirectory(id:String) {
        var previous:String = '';
        for (folder in id.split('/')) {
            var path:String = Path.join([previous, folder]);
            
            if (!FileSystem.exists(path) && !FileSystem.isDirectory(path))
                FileSystem.createDirectory(path);

            previous += folder + '/';
        }
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
}