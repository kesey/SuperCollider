(

///////////////////////////////////////  Pattern

Pdefn(\durSnapkick, Pseq([1,3/2], inf)).quant_(~globalQuant);
Pdefn(\durIkedaBreath, Pseq([3/2,3/4], inf)).quant_(~globalQuant);
Pdefn(\durIkedaNoise, Pseq([3/4, 3/24, 3/12, 3/8, 3/12, 3/24], inf)).quant_(~globalQuant);
Pdefn(\durIkedaBass, Pseq([3/4,1], inf)).quant_(~globalQuant);
Pdefn(\durIkedaClick, Pseq([1/8,1/4], inf)).quant_(~globalQuant);

~defaultPattern1 = Pbind(
	\instrument, \snapkick,
	\dur, Pdefn(\durSnapkick),
	\amp, 0.5,
	\out, ~channelBus[0],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(v, ~snapKickSynthDef, instance, 666, Color.white, Dictionary.newFrom(List["pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.1, default: 1), true]]));
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
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(v, ~ikedaBreathSynthDef, instance, 666, Color.white, Dictionary.newFrom(List["t_trig", ["none"], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "level", ["knob", ControlSpec(0, 2, step: 0.1, default: 1), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern3 = Pbind(
	\instrument, \IkedaHiNoise,
	\dur, Pdefn(\durIkedaNoise),
	\amp, 0.02,
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(v, ~ikedaHiNoiseSynthDef, instance, 666, Color.white, Dictionary.newFrom(List["t_trig", ["none"], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.1, default: 1), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern4 = Pbind(
	\instrument, \IkedaBass,
	\dur, Pdefn(\durIkedaBass),
	\amp, 0.6,
	\out, ~channelBus[0]
);

~defaultPattern5 = Pbind(
	\instrument, \IkedaClick,
	\dur, Pdefn(\durIkedaClick),
	\amp, Pseq([1,0.5,0.8,0.3,0.9]*8, inf),
	\out, ~channelBus[1]
);

~defaultPattern6 = Pbind(
	\instrument, \t1kick,
	\dur, Pseq([1.25, 0.125, 0.625, 2.5], inf),
	\amp, 0.25,
	\rel, 0,
	\out, ~channelBus[0],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(v, ~t1kickSynthDef, instance, 666, Color.white, Dictionary.newFrom(List["rel", ["knob", ControlSpec(0, 28, step: 0.1, default: 0), true], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.1, default: 1), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern7 = Pbind(
	\instrument, \kick2,
	\dur, 0.5,
	\amp, 0.7,
	\out, ~channelBus[0]
);

~defaultPattern8 = Pbind(
	\instrument, \t1kick2,
	\dur, Pseq([1.5, 0.125, 1], inf),
	\rel, 0.2,
	\amp, 0.3,
	\out, ~channelBus[0]
);

~pattern1 = Pbind(
	\instrument, \samplerStereo,
	\buffer, b[\Bowed_Empty_Sweep_Slow][1].bufnum,
	\dur, Pdefn(\durSnapkick),
	\amp, 0.7,
	\rate, 0.04,
	\startPos, 0.07,
	\release, 2,
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(v, ~samplerStereoSynthDef, instance, 110, Color.white, Dictionary.newFrom(List["buffer", ["none"], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "attack", ["slider", ControlSpec(0, 10, step: 0.01, default: 0), true], "gate", ["none"], "loop", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.1, default: 0.7), true], "startPos", ["slider", ControlSpec(0, 1, step: 0.01, default: 0.07), true], "rate", ["knob", ControlSpec(0, 1, step: 0.01, default: 0.04), true], "release", ["slider", ControlSpec(0, 10, step: 0.01, default: 2), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	})
);

~pattern2 = Pbind(
	\instrument, \sinBass,
	\amp, 2.6,
	\dur, 1.5,//Pdefn(\durSnapkick),
	\function, Pfunc({ arg event; // Pif ? or Plazy
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(v, ~sinBassSynthDef, instance, 117, Color.white, Dictionary.newFrom(List["pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false], "attack", ["slider", ControlSpec(0, 10, step: 0.01, default: 0), true], "loopNode", ["slider", ControlSpec(0, 10, step: 0.01, default: 2), true], "gate", ["none"], "amp", ["knob", ControlSpec(0, 10, step: 0.01, default: 2.6), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	}),
	\out, ~channelBus[0]
);
)