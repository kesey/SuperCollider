///////////////////////////////////////  Set-up & boot server

this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Start.scd"); // Execute Me First

( // Execute Me After

s.serverRunning.if({

	///////////////////////////////////////  Routing

	this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Routing.scd");

	///////////////////////////////////////  Sequence

	n = 60; // Tempo in beat per minutes
	TempoClock.default.tempo = n / 60; // TempoClock in beat per seconds
	t = TempoClock((n * 2) / 60); // Another TempoClock twice as fast as the TempoClock default

	Pdefn(\durSnapkick, Pseq([1,3/2], inf));
	Pdefn(\durIkedaBreath, Pseq([3/2,3/4], inf));
	Pdefn(\durIkedaNoise, Pseq([1/4,1/8,1/2], inf));
	Pdefn(\durIkedaBass, Pseq([3/4,1], inf));
	Pdefn(\durIkedaClick, Pseq([1/8,1/4], inf));

	Pdef(\unit1,
		Pbind(
			\instrument, \snapkick,
			\dur, Pdefn(\durSnapkick),
			\amp, 0.7,
			\out, ~channelBus[0]
		),
	).play;

	Pdef(\unit2,
		Pchain(
			~swingify,
			Pbind(
				\instrument, \IkedaBreath,
				\dur, Pdefn(\durIkedaBreath),
				\amp, 1.5,
				\out, ~channelBus[1]
			),
			(swingBase: 0.8, swingAmount: 0, swingThreshold: 0.2)
		)
	).play;

	Pdef(\unit3,
		Pbind(
			\instrument, \IkedaHiNoise,
			\dur, Pdefn(\durIkedaNoise),
			\amp, 0.06,
			\out, ~channelBus[1]
		)
	).play;

	Pdef(\unit4,
		Pbind(
			\instrument, \IkedaBass,
			\dur, Pdefn(\durIkedaBass),
			\amp, 0.8,
			\out, ~channelBus[0]
		)
	).play;

	Pdef(\unit5,
		Pbind(
			\instrument, \IkedaClick,
			\dur, Pdefn(\durIkedaClick),
			\amp, Pseq([1,0.5,0.8,0.3,0.9]*8, inf),
			\out, ~channelBus[1]
		)
	).play;

	///////////////////////////////////////  Gui

	this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Gui.scd");
});

)

Pdef(\unit1).pause;
Pdef(\unit1).resume;

Pdef(\unit2).pause;
Pdef(\unit2).resume;

Pdef(\unit3).pause;
Pdef(\unit3).resume;

Pdef(\unit4).pause;
Pdef(\unit4).resume;

Pdef(\unit5).pause;
Pdef(\unit5).resume;

Pbindef(\unit5, \pan, 1);
Pbindef(\unit1, \pan, -1);

// Pbindef(\unit1,
// 	\instrument, \sampler,
// 	\buffer, b[\Bowed_Empty_Sweep_Slow][1].bufnum,
// 	\startPos, 0.3,
// 	\dur, 2,
// 	\amp, 1
// );

