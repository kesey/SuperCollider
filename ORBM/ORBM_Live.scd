this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Start.scd"); // Execute Me First

///////////////////////////////////////  Live

///////////////////// Transport

/////////// Sequencer + Song transport

( // Play Both
Tdef(\song, ~song2).play(t, true, ~globalQuant);
if (~sequencerTransport.isPlaying.not, { ~sequencerTransport = p.play(t, quant: ~globalQuant); });
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

Tdef(\song, ~song2).play(t, true, ~globalQuant); // Play Song

Tdef(\song).pause;
Tdef(\song).resume(t, ~globalQuant);
Tdef(\song).stop;
Tdef(\song).reset;

/////////// Sequencer transport

if (~sequencerTransport.isPlaying.not, { ~sequencerTransport = p.play(t, quant: ~globalQuant); }); // Play Sequencer
~sequencerTransport.stop; // Stop Sequencer

( // Reset Sequencer
~sequencerTransport.reset;
~resetPdefView.value;
)

///////////////////////////////////////  Playground

Pbindef(\unit4, \dur, Pseq([1, 1.25, Rest(1), 1.5, Rest(2)], inf)).quant_(~globalQuant);
~changePattern.value(Pdef(\unit1), ~defaultPattern1);

Tdef(\song, ~song2).play(t, quant: ~globalQuant);
Tdef(\song, ~defaultSong).play(t, quant: ~globalQuant);
{ ~samplerStereo.set(\out, ~channelBus[0]); }.fork(t, ~globalQuant);

(



)