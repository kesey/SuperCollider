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
				Pdef(name).quant_(~globalQuant)
			)
		);
	});

	p = Ppar(~listUnits.value(~sequencer), inf).play(t, quant: ~globalQuant); // play all unit in parallel

	this.executeFile(~path ++ "ORBM_Gui.scd"); // ~pdefNumber need to exist before executing ORBM_Gui.scd

});

)

// Sequencer transport

p.play(t, quant: ~globalQuant);
p.stop;

(
p.reset;
~synthWindow.keysValuesDo({
	arg key, value;
	if(key.contains("unit"), {
		value.removeAll;
		value.remove;
	});
});
)

// Song transport

(
g = ~defaultSong; // ~song2;
g.play;
)

g.pause;
g.resume;
g.stop;
g.reset;

/*Tdef(\song, ~defaultSong).play;

Tdef(\song).pause;
Tdef(\song).resume;
Tdef(\song).stop;
Tdef(\song).reset;*/

///////////////////////////////////////  Playground

Pbindef(\unit4, \dur, Pseq([1, 1.25, Rest(1), 1.5, Rest(2)], inf)).quant_(~globalQuant);
~changePattern.value(Pdef(\unit1), ~defaultPattern1);

// Tdef(\song, ~song2).play;
~samplerStereo.set(\out, ~channelBus[0]);

(



)