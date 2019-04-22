(

///////////////////////////////////////  Pattern

Pdefn(\durSnapkick, Pseq([1,3/2], inf));
Pdefn(\durIkedaBreath, Pseq([3/2,3/4], inf));
Pdefn(\durIkedaNoise, Pseq([1/4,1/8,1/2], inf));
Pdefn(\durIkedaBass, Pseq([3/4,1], inf));
Pdefn(\durIkedaClick, Pseq([1/8,1/4], inf));

~defaultPattern1 = Pbind(
	\instrument, \snapkick,
	\dur, Pdefn(\durSnapkick),
	\amp, 0.7,
	\out, ~channelBus[0],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(x, ~snapKickSynthDef, instance, 9, Color.white, Dictionary.newFrom(List["pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.1, default: 1), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern2 = Pbind(
	\instrument, \IkedaBreath,
	\dur, Pdefn(\durIkedaBreath),
	\amp, 1.5,
	\release, 10,
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(x, ~ikedaBreathSynthDef, instance, 11, Color.white, Dictionary.newFrom(List["t_trig", ["none"], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "level", ["knob", ControlSpec(0, 2, step: 0.1, default: 1), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern3 = Pbind(
	\instrument, \IkedaHiNoise,
	\dur, Pdefn(\durIkedaNoise),
	\amp, 0.06,
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(x, ~ikedaHiNoiseSynthDef, instance, 11, Color.white, Dictionary.newFrom(List["t_trig", ["none"], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.1, default: 1), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern4 = Pbind(
	\instrument, \IkedaBass,
	\dur, Pdefn(\durIkedaBass),
	\amp, 0.8,
	\out, ~channelBus[0]
);

~defaultPattern5 = Pbind(
	\instrument, \IkedaClick,
	\dur, Pdefn(\durIkedaClick),
	\amp, Pseq([1,0.5,0.8,0.3,0.9]*8, inf),
	\out, ~channelBus[1]
);

~pattern1 = Pbind(
	\instrument, \samplerStereo,
	\buffer, b[\Bowed_Empty_Sweep_Slow][1].bufnum,
	\dur, Pdefn(\durSnapkick),
	\rate, Pseq([0.8, 0.3, 0.8, 0.2], inf),
	\amp, 0.7,
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(x, ~samplerStereoSynthDef, instance, 110, Color.white, Dictionary.newFrom(List["buffer", ["none"], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "attack", ["slider", ControlSpec(0, 10, step: 0.01, default: 0), true], "gate", ["none"], "loop", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.1, default: 1), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	})
);

~pattern2 = Pbind(
	\instrument, \sinBass,
	\amp, 0.7,
	\dur, 1.5,//Pdefn(\durSnapkick),
	\function, Pfunc({ arg event; // Pif ? or Plazy
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(x, ~sinBassSynthDef, instance, 117, Color.white, Dictionary.newFrom(List["pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false], "attack", ["slider", ControlSpec(0, 10, step: 0.01, default: 0), true], "loopNode", ["slider", ControlSpec(0, 10, step: 0.01, default: 2), true], "gate", ["none"], "amp", ["knob", ControlSpec(0, 10, step: 0.01, default: 1), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	}),
	\out, ~channelBus[0]
);
)