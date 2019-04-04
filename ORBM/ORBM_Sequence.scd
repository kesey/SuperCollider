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
		)
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

(
~pattern1 = Pbind(
	\instrument, \samplerStereo,
	\buffer, b[\Bowed_Empty_Sweep_Slow][1].bufnum,
	\dur, Pdefn(\durSnapkick),
	\amp, 0.7,
	\out, ~channelBus[1],
	\pan, Pfunc({ arg event;
		1.0.rand2;
		event.debug("event");
		/*if (event.at(\instrument) != ~prevInst, {
			{ ~autoGui.value(x, ~samplerStereoSynthDef, Pdef(\unit1), 85, Color.white, Dictionary.newFrom(List["pan", ["none"], "attack", ["slider", ControlSpec(0, 10, step: 0.01, default: 0), true], "buffer", ["List", Array.fill(b[\Bowed_Empty_Sweep_Slow].size, { arg i; var filePath; filePath = PathName.new(b[\Bowed_Empty_Sweep_Slow][i].path); filePath.fileName.asString; }), true], "gate", ["none"], "loop", ["button", ControlSpec(0, 1, step: 1, default: 0), true]])); }.defer;
			~prevInst = event.at(\instrument);
		});*/
	})
);

~pattern2 = Pbind(
	\instrument, \snapkick,
	\amp, 0.7,
	\dur, Pdefn(\durSnapkick),
	/*\autoGui, Pfuncn({ arg event;
		if (event.at(\instrument) != ~prevInst, {
	{ ~autoGui.value(x, ~snapKickSynthDef, Pdef(\unit1), 110, Color.white, Dictionary.newFrom(List["pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false]])); }.defer;
			~prevInst = event.at(\instrument);
		});
	}, 1),*/
	\out, ~channelBus[0]
);
)

Pdef(\unit1, ~pattern1);

Pdef(\unit1, ~pattern2);