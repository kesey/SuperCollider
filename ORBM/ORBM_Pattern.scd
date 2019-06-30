(

///////////////////////////////////////  Pattern

Pdefn(\durSnapkick, Pseq([1,Pwrand([0.5, 0.75], [0.3, 0.7].normalizeSum, 1),3/2], inf)).quant_(~globalQuant);
Pdefn(\durIkedaBreath, Pseq([3/2, 0.75, 1], inf)).quant_(~globalQuant);
Pdefn(\durIkedaBass, Pseq([3/4, Rest(0.75), Pwrand([1, 0.5], [0.4, 0.6].normalizeSum, 1)], inf)).quant_(~globalQuant);
Pdefn(\durIkedaClick, Pseq([1/8, 1/4], inf)).quant_(~globalQuant);

~initPattern = Pbind( // use PbindProxy to persist live changes
	\type, \rest,
	\instrument, \default,
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			{
				~removePrev.value(synthWindowKey);
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern1 = Pbind(
	\instrument, \snapkick,
	\dur, Pdefn(\durSnapkick),
	\amp, 0.4,
	\out, ~channelBus[0]
);

~defaultPattern2 = Pbind(
	\instrument, \IkedaBreath,
	\dur, Pdefn(\durIkedaBreath),
	\level, 1,
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~ikedaBreathSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"level", ["knob", ControlSpec(0, 2, step: 0.1, default: event.at(\level)), true],
					"note1", ["slider", ControlSpec(0, 127, step: 0.1, default: 44), true],
					"note2", ["slider", ControlSpec(0, 127, step: 0.1, default: 90), true],
					"lpfFreq", ["knob", ControlSpec(20, 20000, step: 0.1, default: 103.82), true],
					"hpfFreq", ["knob", ControlSpec(20, 20000, step: 0.1, default: 2400), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern3 = Pbind(
	\instrument, \IkedaHiNoise,
	/*\dur, Pseq([3/4, 3/24, 3/12, 3/8, 3/12, 3/24], inf)
	\timingOffset, Pseq([0, 0, 0, 0.02, 0.015, 0], inf), // add groove in beats
	\lag, Pseq([0, 0, 0, 0.02, 0.015, 0], inf), // add groove in seconds*/
	[\dur, \lag], Pseq([[3/4/*dur value*/, 0/*lag value*/], [3/24, 0], [3/12, 0], [3/8, 0.02], [3/12, 0.015], [3/24, 0]], inf), // easier to read
	\amp, 0.014,
	\pan , Pwhite(-1, 1, inf),
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~ikedaHiNoiseSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\amp)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern4 = Pbind(
	\instrument, \IkedaBass,
	\dur, Pdefn(\durIkedaBass),
	\amp, 0.6,
	\out, ~channelBus[0],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~ikedaBassSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\amp)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern5 = Pbind(
	\instrument, \IkedaClick,
	\dur, Pdefn(\durIkedaClick),
	\amp, Pseq([1,0.5,0.8,0.3,0.9]*6, inf),
	\pan , Pwhite(-1, 1, inf),
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~ikedaClickSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 6, step: 0.01, default: event.at(\amp)), true],
					"centerFreq", ["slider", ControlSpec(20, 20000, step: 1, default: 15000), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern6 = Pbind(
	\instrument, \t1kick,
	\dur, Pseq([1.25, 0.625, 2.5]/*/2*/, inf), // /2 to play twice as fast
	\amp, 0.25,
	\rel, 0,
	\pan, Pwhite(-1, 1, inf),
	\out, ~channelBus[0],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);
		ccStart = ~pdefCcStart;
		midiChan = ~pdefMidiChan;

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~t1kickSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"rel", ["knob", ControlSpec(0, 28, step: 0.1, default: event.at(\rel)), true],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 2, step: 0.1, default: event.at(\amp)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern7 = Pbind(
	\instrument, \kick2,
	\dur, Pseq([0.5, Pwrand([0.25, 0.5], [0.3, 0.7].normalizeSum, 1), Rest(0.5), 0.125], inf),
	\amp, 1,
	\out, ~channelBus[0],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~kick2SynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_gate", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 6, step: 0.01, default: event.at(\amp)), true],
					"freq", ["knob", ControlSpec(20, 600, step: 0.01, default: 60), true],
					"atf", ["knob", ControlSpec(0, 200, step: 0.01, default: 80), true],
					"rel", ["knob", ControlSpec(0, 20, step: 0.01, default: 1), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern8 = Pbind(
	\instrument, \t1kick2,
	\dur, Pseq([1.5, 0.125, 1], inf),
	\rel, 0.2,
	\amp, 0.35,
	\out, ~channelBus[0],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~t1kick2SynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 6, step: 0.01, default: event.at(\amp)), true],
					"snd", ["knob", ControlSpec(0, 42, step: 0.01, default: 18), true],
					"rel", ["knob", ControlSpec(0, 20, step: 0.01, default: 0.6), true],
					"pitch", ["knob", ControlSpec(0, 12, step: 0.01, default: 0.1), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern9 = Pbind(
	\instrument, \prayerBell,
	\dur, 5,
	\level, 0.03,
	\freq, 378,
	\decayscale, 0.48,
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~prayerBellSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"i_doneAction", ["none"],
					"freq", ["knob", ControlSpec(20, 4500, step: 1, default: event.at(\freq)), true],
					"level", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\level)), true],
					"decayscale", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\decayscale)), true],
					"lag", ["knob", ControlSpec(0, 20, step: 0.01, default: 10), true],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~defaultPattern10 = Pbind(
	\instrument, \samplerStereo,
	\buffer, b[\Bowed_Empty_Sweep_Slow][1].bufnum,
	\dur, 5,
	\amp, 2,
	\rate, 0.06,
	\startPos, 0.04,
	\attack, 2.2,
	\release, 2,
	\out, ~channelBus[1],
	\function, Pfunc({ arg event;
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~samplerStereoSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"buffer", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"attack", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"gate", ["none"],
					"loop", ["button", ControlSpec(0, 1, step: 1, default: 0), true],
					"amp", ["knob", ControlSpec(0, 2, step: 0.1, default: event.at(\amp)), true],
					"startPos", ["slider", ControlSpec(0, 1, step: 0.01, default: event.at(\startPos)), true],
					"rate", ["knob", ControlSpec(0.01, 1, step: 0.01, default: event.at(\rate)), true],
					"release", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
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
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~samplerStereoSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"buffer", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"attack", ["slider", ControlSpec(0, 10, step: 0.01, default: 0), true],
					"gate", ["none"],
					"loop", ["button", ControlSpec(0, 1, step: 1, default: 0), true],
					"amp", ["knob", ControlSpec(0, 2, step: 0.1, default: event.at(\amp)), true],
					"startPos", ["slider", ControlSpec(0, 1, step: 0.01, default: event.at(\startPos)), true],
					"rate", ["knob", ControlSpec(0.01, 1, step: 0.01, default: event.at(\rate)), true],
					"release", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~pattern2 = Pbind(
	\instrument, \sinBass,
	\amp, 1.84,
	\dur, 1.5,//Pdefn(\durSnapkick),
	\function, Pfunc({ arg event; // Pif ? or Pn(Plazy, inf)
		var currentInstr, synthWindowKey, instance, ccStart, midiChan;
		currentInstr = event.at(\instrument);

		if (currentInstr != ~pdefPrevInstr, {
			synthWindowKey = (~pdefPrevInstr ++ ~pdefName).asString;
			instance = ~pdefName.asSymbol;
			ccStart = ~pdefCcStart.asInt;
			midiChan = ~pdefMidiChan.asInt;
			{
				~removePrev.value(synthWindowKey);
				~autoGui.value(v, ~sinBassSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false],
					"amp", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\amp)), true],
					"gate", ["none"],
					"curve", ["knob", ControlSpec(-8, 8, step: 1, default: 0), true],
					"loopNode", ["knob", ControlSpec(0, 4, step: 1, default: 0), true],
					"attack", ["knob", ControlSpec(0, 10, step: 0.01, default: 0.2), true],
					"release", ["knob", ControlSpec(0, 10, step: 0.01, default: 4), true],
					"envLevel1", ["knob", ControlSpec(0, 80, step: 0.1, default: 0), true],
					"envLevel2", ["knob", ControlSpec(0, 80, step: 0.1, default: 40), true],
					"envLevel3", ["knob", ControlSpec(0, 80, step: 0.1, default: 32), true],
					"envLevel4", ["knob", ControlSpec(0, 80, step: 0.1, default: 50), true],
					"envLevel5", ["knob", ControlSpec(0, 80, step: 0.1, default: 0), true],
					"envLevel6", ["knob", ControlSpec(0, 80, step: 0.1, default: 60), true],
					"envTime1", ["knob", ControlSpec(0, 1, step: 0.01, default: 0.5), true],
					"envTime2", ["knob", ControlSpec(0, 1, step: 0.01, default: 0.3), true],
					"envTime3", ["knob", ControlSpec(0, 1, step: 0.01, default: 0.25), true],
					"envTime4", ["knob", ControlSpec(0, 1, step: 0.01, default: 1), true],
					"envTime5", ["knob", ControlSpec(0, 1, step: 0.01, default: 0.5), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	}),
	\out, ~channelBus[0]
);

)
