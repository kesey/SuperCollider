this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Start.scd"); // Execute Me First

( // Execute Me After

///////////////////////////////////////  Sequencer

s.serverRunning.if({

	~pdefNumber = 8; // number of pdef or unit
	~pdefNumber = ~pdefNumber.max(1).min(12); // limit number of pdef

	~sequencer = Dictionary.new;

	~pdefNumber.do({ // sequencer creation with pdefNumber of unit
		arg i;
		var name;
		name = ("unit" ++ (i + 1)).asSymbol;
		~sequencer.put(name,
			Penvir(
				(pdefName: name, prevInstr: nil),
				Pdef(name).quant_(~globalQant)
			)
		);
	});

	p = Ppar(~listUnits.value(~sequencer), inf).play(TempoClock.default, quant: ~globalQant); // play all unit in parallel

	this.executeFile(~path ++ "ORBM_Gui.scd"); // ~pdefNumber need to exist before executing ORBM_Gui.scd

});

)

// Sequencer transport
p.play(TempoClock.default, quant: ~globalQant);
p.stop;

(
p.reset;
~synthWindow.keysValuesDo({
	arg key, value;
	if(key.contains("unit");, {
		value.removeAll;
		value.remove;
	});
});
)

(

)

// Song transport
(
g = ~song2; // ~defaultSong;
g.play;
)

g.pause;
g.resume;
g.stop;
g.reset;

///////////////////////////////////////  Playground

Pbindef(\unit4, \dur, Pseq([1, 1.25, Rest(1), 1.5, Rest(2)], inf)).quant_(~globalQant);
Pdef(\unit1, ~defaultPattern1).quant_(~globalQant);
Pbindef(\unit1).source.at(\type).source;
//Pbindef(\unit1).source.patternpairs.asEvent.at(\type);

(



)