this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Start.scd"); // Execute Me First

( // Execute Me After

///////////////////////////////////////  Sequencer

s.serverRunning.if({

	~pdefNumber = 8; // number of pdef or units
	~pdefNumber = ~pdefNumber.max(1).min(12); // limit number of pdef

	~sequencer = Dictionary.new;

	~pdefNumber.do({ // sequencer creation with pdefNumber of units
		arg i;
		var name;
		name = ("unit" ++ (i + 1)).asSymbol;
		~sequencer.put(name,
			Penvir(
				(pdefName: name, pdefPrevInstr: nil, pdefCcStart: 666, pdefMidiChan: i),
				Pdef(name, ~initPattern).quant_(~globalQuant);
			)
		);
	});

	p = Ppar(~listUnits.value(~sequencer), inf).play(t, quant: ~globalQuant); // play all units in parallel

	this.executeFile(~path ++ "ORBM_Gui.scd"); // ~pdefNumber need to exist before executing ORBM_Gui.scd
	this.executeFile(~path ++ "ORBM_Song.scd"); // Gui need to exist before executing ORBM_Song.scd

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
		~synthWindow.removeAt(key); // remove previous composite views
	});
});
)

// Song transport

Tdef(\song, ~defaultSong).play(t, quant: ~globalQuant); // play me

Tdef(\song).pause;
Tdef(\song).resume;
Tdef(\song).stop;
Tdef(\song).reset;

///////////////////////////////////////  Playground

Pbindef(\unit4, \dur, Pseq([1, 1.25, Rest(1), 1.5, Rest(2)], inf)).quant_(1);
~changePattern.value(Pdef(\unit1), ~defaultPattern1);

Tdef(\song, ~song2).play(t, quant: ~globalQuant);
~samplerStereo.set(\out, ~channelBus[0]);

(



)