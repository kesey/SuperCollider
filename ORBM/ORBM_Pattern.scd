(

///////////////////////////////////////  Pattern

Pdefn(\durSnapkick, Pseq([1,Pwrand([0.5, 0.75], [0.3, 0.7].normalizeSum, 1),3/2], inf)).quant_(~globalQuant);
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
				~autoGui.value(v, ~snapKickSynthDef, instance, 666, 0, Color.white, Dictionary.newFrom(List["pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.1, default: event.at(\amp)), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern2 = Pbind(
	\instrument, \IkedaBreath,
	\dur, Pdefn(\durIkedaBreath),
	\level, 1.5,
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(v, ~ikedaBreathSynthDef, instance, 666, 0, Color.white, Dictionary.newFrom(List["t_trig", ["none"], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "level", ["knob", ControlSpec(0, 2, step: 0.1, default: event.at(\level)), true], "note1", ["slider", ControlSpec(0, 127, step: 0.1, default: 44), true], "note2", ["slider", ControlSpec(0, 127, step: 0.1, default: 90), true], "lpfFreq", ["knob", ControlSpec(20, 20000, step: 0.1, default: 103.82), true], "hpfFreq", ["knob", ControlSpec(20, 20000, step: 0.1, default: 2400), true]]));
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
	\pan , Pwhite(-1, 1, inf),
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(v, ~ikedaHiNoiseSynthDef, instance, 666, 0, Color.white, Dictionary.newFrom(List["t_trig", ["none"], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\amp)), true]]));
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
	\pan , Pwhite(-1, 1, inf),
	\out, ~channelBus[1]
);

~defaultPattern6 = Pbind(
	\instrument, \t1kick,
	\dur, Pseq([1.25, 0.625, 2.5]/*/2*/, inf), // /2 to play twice as fast
	\amp, 0.25,
	\rel, 0,
	\pan, Pwhite(-1, 1, inf),
	\out, ~channelBus[0],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~prevInstr, {
			synthWindowKey = (~prevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			{
				~removePrevView.value(~synthWindow, synthWindowKey);
				~autoGui.value(v, ~t1kickSynthDef, instance, 666, 0, Color.white, Dictionary.newFrom(List["rel", ["knob", ControlSpec(0, 28, step: 0.1, default: event.at(\rel)), true], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.1, default: event.at(\amp)), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern7 = Pbind(
	\instrument, \kick2,
	\dur, Pseq([0.5, Pwrand([0.25, 0.5], [0.3, 0.7].normalizeSum, 1), Rest(0.5), 0.125], inf),
	\amp, 0.8,
	\out, ~channelBus[0]
);

~defaultPattern8 = Pbind(
	\instrument, \t1kick2,
	\dur, Pseq([1.5, 0.125, 1], inf),
	\rel, 0.2,
	\amp, 0.3,
	\out, ~channelBus[0]
);

~pattern1 = Pbind( // use PbindProxy to persist live changes
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
				~autoGui.value(v, ~samplerStereoSynthDef, instance, 116, 0, Color.white, Dictionary.newFrom(List["buffer", ["none"], "pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true], "attack", ["slider", ControlSpec(0, 10, step: 0.01, default: 0), true], "gate", ["none"], "loop", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "amp", ["knob", ControlSpec(0, 2, step: 0.1, default: event.at(\amp)), true], "startPos", ["slider", ControlSpec(0, 1, step: 0.01, default: event.at(\startPos)), true], "rate", ["knob", ControlSpec(0.01, 1, step: 0.01, default: event.at(\rate)), true], "release", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true]]));
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
				~autoGui.value(v, ~sinBassSynthDef, instance, 123, 0, Color.white, Dictionary.newFrom(List["pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false], "attack", ["slider", ControlSpec(0, 10, step: 0.01, default: 0), true], "loopNode", ["slider", ControlSpec(0, 10, step: 0.01, default: 2), true], "gate", ["none"], "amp", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\amp)), true]]));
			}.defer;
			~prevInstr = currentInstr;
		});
		0;
	}),
	\out, ~channelBus[0]
);
)
