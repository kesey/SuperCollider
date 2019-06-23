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

	p = Ppar(~listUnits.value(~sequencer), inf); // all units in parallel

	this.executeFile(~path ++ "ORBM_Gui.scd"); // ~pdefNumber need to exist before executing ORBM_Gui.scd
	this.executeFile(~path ++ "ORBM_Song.scd"); // Gui need to exist before executing ORBM_Song.scd
});

)

///////////////////////////////////////  Transport

// Sequencer + Song transport

( // Play Both
{
	~sequencerTransport = p.play;
	Tdef(\song, ~defaultSong).play;
}.fork(t, ~globalQuant); // use fork to quantize
)

( // Stop Both
{
	Tdef(\song).stop;
	~sequencerTransport.stop;
}.fork(t, ~globalQuant);
)

( // Reset Both
Tdef(\song).reset;
~sequencerTransport.reset;
~resetPdefView.value;
)

// Sequencer transport

~sequencerTransport.play(t, quant: ~globalQuant); // Play Sequencer
{ ~sequencerTransport.stop; }.fork(t, ~globalQuant); // Stop Sequencer

( // Reset Sequencer
~sequencerTransport.reset;
~resetPdefView.value;
)

// Song transport

Tdef(\song, ~defaultSong).play(t, quant: ~globalQuant); // Play Song

{ Tdef(\song).pause; }.fork(t, ~globalQuant); // Pause Song
Tdef(\song).resume(t, quant: ~globalQuant); // Resume Song
{ Tdef(\song).stop; }.fork(t, ~globalQuant); // Stop Song
Tdef(\song).reset; // Reset Song

///////////////////////////////////////  Playground

Pbindef(\unit4, \dur, Pseq([1, 1.25, Rest(1), 1.5, Rest(2)], inf)).quant_(~globalQuant);
~changePattern.value(Pdef(\unit1), ~defaultPattern1);

Tdef(\song, ~song2).play(t, quant: ~globalQuant);
{ ~samplerStereo.set(\out, ~channelBus[0]); }.fork(t, ~globalQuant);

(



)