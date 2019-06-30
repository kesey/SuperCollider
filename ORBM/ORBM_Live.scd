this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Start.scd"); // Execute Me First

///////////////////////////////////////  Live

///////////////////// Transport

/////////// Sequencer + Song transport

( // Play Both
Tdef(\song, ~defaultSong).play(t, true, ~sequenceQuant);
if (~sequencerTransport.isPlaying.not, { ~sequencerTransport = p.play(t, quant: ~sequenceQuant); });
)

( // Stop Both
Tdef(\song).stop;
~sequencerTransport.stop;
)

( // Reset Both
Tdef(\song).reset;
~sequencerTransport.reset;
~resetPdefView.value;
)

/////////// Song transport

Tdef(\song, ~testSong).play(t, true, ~sequenceQuant); // Play Song

Tdef(\song).pause;
Tdef(\song).resume(t, ~sequenceQuant);
Tdef(\song).stop;
Tdef(\song).reset;

/////////// Sequencer transport

if (~sequencerTransport.isPlaying.not, { ~sequencerTransport = p.play(t, quant: ~sequenceQuant); }); // Play Sequencer
~sequencerTransport.stop; // Stop Sequencer

( // Reset Sequencer
~sequencerTransport.reset;
~resetPdefView.value;
)

///////////////////////////////////////  Playground

Pbindef(\unit4, \dur, Pseq([1, 1.25, Rest(1), 1.5, Rest(2)], inf)).quant_(~sequenceQuant);
~changePattern.value(Pdef(\unit1), ~defaultPattern1);

Tdef(\song, ~song2).play(t, quant: ~sequenceQuant);
Tdef(\song, ~testSong).play(t, quant: ~sequenceQuant);
{ ~samplerStereo.set(\out, ~channelBus[0]); }.fork(t, ~globalQuant);

(



)