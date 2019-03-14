this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Start.scd"); // Execute Me First

( // Execute Me After
s.serverRunning.if({
	///////////////////////////////////////  Routing
	var channelBus, masterBus;

	this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_SynthDef.scd");

	masterBus = Bus.audio(s, 2);
	~master = Synth(\MasterStrip, [\in, masterBus], addAction: 'addToTail');

	~channelNumber = 4; // number of channels
	channelBus = Array.newClear(~channelNumber);
	~channelNumber.do {
		arg i;
		channelBus[i] = Bus.audio(s, 2);
		currentEnvironment.put((\channel ++ i).asSymbol, Synth(\ChannelStrip, [\in, channelBus[i], \out, masterBus]));
	};

	s.bind { Synth(\InputSig, [\in, 0, \out, channelBus[1], \amp, 4]) };
	s.bind { Synth(\InputSig, [\in, 2, \out, channelBus[1], \amp, 0.5]) };
	s.bind { Synth(\Reverb, [\in, ~aux1, \out, channelBus[2]], ~master, 'addBefore') }; // s.bind consider server latency
	s.bind { Synth(\SimpleDelay, [\in, ~aux2, \out, channelBus[3]], ~master, 'addBefore') };


	///////////////////////////////////////  Sequence

	n = 60; // Tempo in beat per minutes
	TempoClock.default.tempo = n / 60; // TempoClock in beat per seconds
	t = TempoClock((n * 2) / 60); // Another TempoClock twice as fast as the TempoClock default

	Pdefn(\durSnapkick, Pseq([1,3/2], inf));
	Pdefn(\durIkedaBreath, Pseq([3/2,3/4], inf));
	Pdefn(\durIkedaNoise, Pseq([1/4,1/8,1/2], inf));
	Pdefn(\durIkedaBass, Pseq([3/4,1], inf));
	Pdefn(\durIkedaClick, Pseq([1/8,1/4], inf));

	Pdef(\zed,
		Pbind(
			\instrument, \snapkick,
			\dur, Pdefn(\durSnapkick),
			\amp, 0.7,
			\out, channelBus[0]
		),
	).play;

	Pdef(\bit,
		Pbind(
			\instrument, \IkedaBreath,
			\dur, Pdefn(\durIkedaBreath),
			\amp, 1,
			\out, channelBus[1]
		),
	).play;

	Pdef(\nib,
		Pbind(
			\instrument, \IkedaHiNoise,
			\dur, Pdefn(\durIkedaNoise),
			\amp, 0.06,
			\out, channelBus[1]
		),
	).play;

	Pdef(\fes,
		Pbind(
			\instrument, \IkedaBass,
			\dur, Pdefn(\durIkedaBass),
			\amp, 0.8,
			\out, channelBus[0]
		),
	).play;

	Pdef(\cli,
		Pbind(
			\instrument, \IkedaClick,
			\dur, Pdefn(\durIkedaClick),
			\amp, Pseq([1,0.5,0.8,0.3,0.9]*8, inf),
			\out, channelBus[1]
		),
	).play;

	this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Gui.scd");
	s.meter; // level meter
});
)

Pdef(\nib).pause;
Pdef(\nib).resume;

Pdef(\fes).pause;
Pdef(\fes).resume;

Pdef(\bit).pause;
Pdef(\bit).resume;

Pdef(\zed).pause;
Pdef(\zed).resume;

Pdef(\cli).pause;
Pdef(\cli).resume;

Pbindef(\cli, \pan, 1);
Pbindef(\nib, \pan, -1);

Pbindef(\nib,
	\instrument, \samplerStereo,
	\buffer, b[\Bowed_Empty_Sweep_Slow][0].bufnum,
	\dur, 4,
	\amp, 1
);

