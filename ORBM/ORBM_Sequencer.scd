this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Start.scd"); // Execute Me First

( // Execute Me After

///////////////////////////////////////  Sequencer

s.serverRunning.if({

	n = 60; // Tempo in beat per minutes
	t = TempoClock.default;
	t.tempo = n / 60; // TempoClock by default in beat per seconds

	~pdefNumber = 8; // number of pdef or units
	~pdefNumber = ~pdefNumber.max(1).min(12); // limit number of pdef

	~sequencer = Dictionary.new;

	~pdefNumber.do({ // sequencer creation with pdefNumber of units
		arg i;
		var name;
		name = ("unit" ++ (i + 1)).asSymbol;
		~sequencer.put(name,
			Penvir(
				(pdefName: name, prevInstr: nil),
				Pdef(name, ~initPattern).quant_(~globalQuant);
			)
		);
	});

	p = Ppar(~listUnits.value(~sequencer), inf).play(t, quant: ~globalQuant); // play all units in parallel

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

Tdef(\song, ~defaultSong).play(t, quant: 1);

Tdef(\song).pause;
Tdef(\song).resume;
Tdef(\song).stop;
Tdef(\song).reset;

///////////////////////////////////////  Playground

Pbindef(\unit4, \dur, Pseq([1, 1.25, Rest(1), 1.5, Rest(2)], inf)).quant_(~globalQuant);
~changePattern.value(Pdef(\unit1), ~defaultPattern1);

Tdef(\song, ~song2).play(t, quant: 1);
~samplerStereo.set(\out, ~channelBus[0]);

(



)