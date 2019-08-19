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
	\pan , Pwhite(-1.0, 1.0, inf),
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
	\pan , Pwhite(-1.0, 1.0, inf),
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
	\pan, Pwhite(-1.0, 1.0, inf),
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

~song2Pattern1 = Pbind(
	\instrument, \kick808,
	\dur, Pseq(
		[
			Rest(0.75), 0.5, Rest(0.25), 0.75, 1, 0.25, Rest(0.5), // 0.75+ 0.5+ 0.25+ 0.75+ 1+ 0.25+ 0.5 == 4
			Rest(0.25), 0.5, 0.75, 0.75, 0.5, 0.75, 0.5 // 0.25+ 0.5+ 0.75+ 0.75+ 0.5+ 0.75+ 0.5 == 4
		],
		inf
	),
	\envL1, 0,
    \envL2, 0.94,
	\envL3, 0,
	\envT1, 0.01,
	\envT2, 0.31,
	\enfL1, 400,
	\enfL2, 742,
	\enfL3, 82,
	\enfT1, 0.001,
	\enfT2, 0.001,
	\enfT3, 0.001,
	\tu, 0.68,
	\amp, 1.48,
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
				~autoGui.value(v, ~kick808SynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\amp)), true],
					"tu", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\tu)), true],
					"envL1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL1)), true],
					"envL2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL2)), true],
					"envL3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL3)), true],
					"envT1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envT1)), true],
					"envT2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envT2)), true],
					"enfL1", ["knob", ControlSpec(0, 2000, step: 1, default: event.at(\enfL1)), true],
					"enfL2", ["knob", ControlSpec(0, 2000, step: 1, default: event.at(\enfL2)), true],
					"enfL3", ["knob", ControlSpec(0, 2000, step: 1, default: event.at(\enfL3)), true],
					"enfT1", ["knob", ControlSpec(0, 1, step: 0.001, default: event.at(\enfT1)), true],
					"enfT2", ["knob", ControlSpec(0, 1, step: 0.001, default: event.at(\enfT2)), true],
					"enfT3", ["knob", ControlSpec(0, 1, step: 0.001, default: event.at(\enfT3)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

/*~song2Pattern1 = Pbind(
	\instrument, \kick808,
	\dur, Pseq([Rest(0.25), 0.5, 0.75, 0.75, 0.5, 0.5, 0.75, Rest(0.25), 0.5, 0.75, 0.75, 0.5, 0.75, 0.5], inf),
	\envL1, 0,
    \envL2, 1,
	\envL3, 0,
	\envT1, 0.09,
	\envT2, 0.29,
	\enfL1, 877,
	\enfL2, 0,
	\enfL3, 17,
	\enfT1, 0.04,
	\enfT2, 0.4,
	\enfT3, 0,
	\tu, 0.94,
	\amp, 0.9,
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
				~autoGui.value(v, ~kick808SynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\amp)), true],
					"tu", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\tu)), true],
					"envL1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL1)), true],
					"envL2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL2)), true],
					"envL3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL3)), true],
					"envT1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envT1)), true],
					"envT2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envT2)), true],
					"enfL1", ["knob", ControlSpec(0, 2000, step: 1, default: event.at(\enfL1)), true],
					"enfL2", ["knob", ControlSpec(0, 2000, step: 1, default: event.at(\enfL2)), true],
					"enfL3", ["knob", ControlSpec(0, 2000, step: 1, default: event.at(\enfL3)), true],
					"enfT1", ["knob", ControlSpec(0, 1, step: 0.001, default: event.at(\enfT1)), true],
					"enfT2", ["knob", ControlSpec(0, 1, step: 0.001, default: event.at(\enfT2)), true],
					"enfT3", ["knob", ControlSpec(0, 1, step: 0.001, default: event.at(\enfT3)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);*/

~song2Pattern2 = Pbind(
	\instrument, \hatnew,
	\dur, Pseq([0.25, Pn(0.125, 3), 0.25, 0.25, 0.125, 0.25, 0.125, 0.25, 0.125], inf),
	                      // 0.25 +  (0.125 *3)+ 0.25 +0.25 +0.125 +0.25 +0.125 +0.25 +0.125 == 2
	\pan, Pwhite(-0.75, 0.75, inf),
	\freq, 0.44,
	\hpf, 8500,
	\rel, 0.15,
	\amp, 2.6,
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
				~autoGui.value(v, ~hatnewSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\amp)), true],
					"rel", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true],
					"freq", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\freq)), true],
					"hpf", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\hpf)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song2Pattern3 = Pbind(
	\instrument, \kickmed,
	\dur, Pseq([Rest(1), 3], inf),
	\env0L2, 0.63,
	\env0L3, 0.15,
	\fratio, 1.11,
	\env1L1, 0,
	\env1L2, 37,
	\env1L3, 24,
	\env1T1, 0.3,
	\level, 0.8,
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
				~autoGui.value(v, ~kickMedSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"dc", ["none"],
					"done", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"level", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\level)), true],
					"snd", ["knob", ControlSpec(0, 100, step: 0.1, default: 18), true],
					"atkEnv0", ["knob", ControlSpec(0, 10, step: 0.01, default: 0.01), true],
					"decEnv0", ["knob", ControlSpec(0, 10, step: 0.01, default: 0.2), true],
					"relEnv0", ["knob", ControlSpec(0, 10, step: 0.01, default: 0.26), true],
					"fratio", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\fratio)), true],
					"env0L2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\env0L2)), true],
					"env0L3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\env0L3)), true],
					"env1L1", ["knob", ControlSpec(0, 120, step: 0.1, default: event.at(\env1L1)), true],
					"env1L2", ["knob", ControlSpec(0, 120, step: 0.1, default: event.at(\env1L2)), true],
					"env1L3", ["knob", ControlSpec(0, 120, step: 0.1, default: event.at(\env1L3)), true],
					"env1T1", ["knob", ControlSpec(0, 1, step: 1, default: event.at(\env1T1)), true],
					"curve1", ["knob", ControlSpec(-4, 4, step: 0.01, default: -4), true],
					"curve2", ["knob", ControlSpec(-4, 4, step: 0.01, default: -2), true],
					"curve3", ["knob", ControlSpec(-4, 4, step: 0.01, default: -4), true],
					"owhich2", ["slider", ControlSpec(0, 3, step: 1, default: 0), true],
					"ochoose", ["slider", ControlSpec(0, 3, step: 1, default: 0), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song2Pattern4 = Pbind(
	\instrument, \dStowell,
	\dur, 2,
	\attack, 0,
	\release, 3,
	\lpf, 370,
	\amp, 2,
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
				~autoGui.value(v, ~dStowellSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\amp)), true],
					"attack", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"release", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"lpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\lpf)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song2Pattern5 = Pbind(
	\instrument, \kikAw,
	\dur, Pseq([0.125, Rest(0.25), 1, 1.125, 0.5, Rest(1)], inf), // 0.125 +0.25+ 1 + 1.125+ 0.5+ 1 == 4
	\basefreq, 51,
	\ratio, 0.65,
	\sweeptime, 0.81,
	\envL1, 1.11,
	\envL2, 4.31,
	\envL3, 0,
	\envT1, 0.02,
	\envT2, 0.4,
	\amp, 0.4,
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
				~autoGui.value(v, ~kikAwSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\amp)), true],
					"basefreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\basefreq)), true],
					"ratio", ["knob", ControlSpec(0, 20, step: 0.01, default: event.at(\ratio)), true],
					"sweeptime", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\sweeptime)), true],
					"envL1", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\envL1)), true],
					"envL2", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\envL2)), true],
					"envL3", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\envL3)), true],
					"envT1", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\envT1)), true],
					"envT2", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\envT2)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song2Pattern6 = Pbind(
	\instrument, \sd,
	\dur, Pseq([2, 4, 2], inf),
	\amp, 0.12,
	\att, 0.02,
	\rel, 0.05,
	\freq, 266,
	\ffreq, 16004,
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
				~autoGui.value(v, ~sdSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"rel", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true],
					"att", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\att)), true],
					"freq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\freq)), true],
					"ffreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\ffreq)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song2Pattern7 = Pbind(
	\instrument, \hat808,
	\dur, Pseq([0.125, 0.25, 0.125, 0.125, 0.25, 1, 0.125], inf),
	         // 0.125 +0.25 +0.125 +0.125 +0.25 +1 +0.125 == 2
	\amp, 0.018,
	\tu, 0.63,
	\attack, 0,
	\release, Pseq([0.01, 0.03, 0.02, 0.01, 0.02, 0.05, 0.03], inf),
	\hpf, 14776,
	\rq, 0,
	\rel, 0.92,
	\lpf, 2834,
	\pan, Pwhite(-1.0, 1.0, inf),
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
				~autoGui.value(v, ~hat808SynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_gate", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.001, default: event.at(\amp)), true],
					"attack", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"release", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"tu", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\tu)), true],
					"hpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\hpf)), true],
					"lpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\lpf)), true],
					"rel", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true],
					"rq", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\rq)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song2Pattern8 = Pbind(
	\instrument, \ping_mh,
	\dur, 8,
	\amp, 0.04,
	\freq, 417,
	\attack, 1.79,
	\pan, Pwhite(-0.5, 0.5, inf),
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
				~autoGui.value(v, ~ping_mhSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"freq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\freq)), true],
					"attack", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song2Pattern9 = Pbind(
	\instrument, \tabass,
	\dur, 0.125,
	\freq, Pseq([0.0625, 0.125, 0.0625, 0.5, 1, 0.9], inf),
	\attack, 0,
	\release, Pseq([0.42, 0.2, 0.9, 0.2], inf),
	\amp, 0.12,
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
				~autoGui.value(v, ~tabassSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 2, step: 0.1, default: event.at(\amp)), true],
					"attack", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"release", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"freq", ["slider", ControlSpec(0, 12, step: 0.01, default: event.at(\freq)), true]

				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song2Pattern10 = Pbind(
	\instrument, \noise2new,
	\dur, Pseq([2, 1, 1], inf),
	\att, 0.01,
	\rel, 1,
	\del1, 23.48,
	\del2, 0,
	\div, 0.02,
	\amp, 0.08,
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
				~autoGui.value(v, ~noise2newSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\amp)), true],
					"att", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\att)), true],
					"rel", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true],
					"del1", ["knob", ControlSpec(0, 30, step: 0.01, default: event.at(\del1)), true],
					"del2", ["knob", ControlSpec(0, 30, step: 0.01, default: event.at(\del2)), true],
					"div", ["knob", ControlSpec(0, 30, step: 0.01, default: event.at(\div)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song2Pattern11 = Pbind(
	\instrument, \sinBass,
	\amp, 0.6,
	\dur, 2,
	\curve, 0,
	\loopNode, 0,
	\attack, 0,
	\release, 2,
	\envLevel1, 0,
	\envLevel2, 20.3,
	\envLevel3, 64,
	\envLevel4, 20.9,
	\envLevel5, 73.5,
	\envLevel6, 56,
	\envTime1, 0.01,
	\envTime2, 0.15,
	\envTime3, 0.75,
	\envTime4, 0.52,
	\envTime5, 0.5,
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
				~autoGui.value(v, ~sinBassSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false],
					"amp", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\amp)), true],
					"gate", ["none"],
					"curve", ["knob", ControlSpec(-8, 8, step: 1, default: event.at(\curve)), true],
					"loopNode", ["knob", ControlSpec(0, 4, step: 1, default: event.at(\loopNode)), true],
					"attack", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"release", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"envLevel1", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel1)), true],
					"envLevel2", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel2)), true],
					"envLevel3", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel3)), true],
					"envLevel4", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel4)), true],
					"envLevel5", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel5)), true],
					"envLevel6", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel6)), true],
					"envTime1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envTime1)), true],
					"envTime2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envTime2)), true],
					"envTime3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envTime3)), true],
					"envTime4", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envTime4)), true],
					"envTime5", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envTime5)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	}),
	\out, ~channelBus[0]
);

~song2Pattern12 = Pbind(
	\instrument, \samplerStereo,
	\buffer, b[\Bowed_Empty_Sweep_Slow][1].bufnum,
	\dur, 4,
	\amp, 1.2,
	\rate, 0.06,
	\startPos, 0.08,
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

~song3Pattern1 = Pbind(
	\instrument, \kickMist,
	\dur, Pseq([2.625, 1.75, Rest(0.875), 1.75], inf),
	\level, 0.12,
	\tu, 1,
	\noise, 1,
	\env0L1, 0.35,
	\env0L2, 0.29,
	\env0L3, 52,
	\env0L4, 0.26,
	\env0T1, 0.24,
	\env0T2, 0,
	\env0T3, 0,
	\env1L1, 60,
	\env1L2, 58,
	\env1L3, 29,
	\env1T1, 0,
	\env1T2, 0.04,
	\pan, 0,
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
				~autoGui.value(v, ~kickMistSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"doneAction", ["none"],
					"level", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\level)), true],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"env0L1", ["knob", ControlSpec(0, 400, step: 0.01, default: event.at(\env0L1)), true],
					"env0L2", ["knob", ControlSpec(0, 400, step: 0.01, default: event.at(\env0L2)), true],
					"env0L3", ["knob", ControlSpec(0, 400, step: 0.01, default: event.at(\env0L3)), true],
					"env0L4", ["knob", ControlSpec(0, 400, step: 0.01, default: event.at(\env0L4)), true],
					"env0T1", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\env0T1)), true],
					"env0T2", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\env0T2)), true],
					"env0T3", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\env0T3)), true],
					"env1L1", ["knob", ControlSpec(0, 400, step: 0.01, default: event.at(\env1L1)), true],
					"env1L2", ["knob", ControlSpec(0, 400, step: 0.01, default: event.at(\env1L2)), true],
					"env1L3", ["knob", ControlSpec(0, 400, step: 0.01, default: event.at(\env1L3)), true],
					"env1T1", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\env0T1)), true],
					"env1T2", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\env0T2)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern2 = Pbind(
	\instrument, \drumkick,
	\dur, Pseq([3.5, Rest(0.875), 1.75, Rest(0.875)], inf), // 3.5+ 0.875+ 1.75+ 0.875 == 7
	\amp, 0.2,
	\attack, 1.47,
	\release, 2.47,
	\curve, 60,
	\pan, 0,
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
				~autoGui.value(v, ~drumkickSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_gate", ["none"],
					"doneAction", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"attack", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"release", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"curve", ["knob", ControlSpec(-200, 200, step: 0.01, default: event.at(\curve)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern3 = Pbind(
	\instrument, \kicklaserbeam,
	\dur, Pseq([0.875, 1.75, 1.25, 0.875, 1.375, 0.875], inf), // 1.75+ 1.25+ 0.875+ 1.75+ 1.375 == 7 1.75 - 0.875
	\amp, 0.004,
	\freq, 15794,
	\att, 1.06,
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
				~autoGui.value(v, ~kicklaserbeamSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"doneAction", ["none"],
					"amp", ["knob", ControlSpec(0, 1, step: 0.001, default: event.at(\amp)), true],
					"att", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\att)), true],
					"freq", ["slider", ControlSpec(20, 20000, step: 1, default: event.at(\freq)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern4 = Pbind(
	\instrument, \kickbass,
	\dur, 1.75,
	\level, 0.08,
	\pan, Pwhite(-1.0, 1.0, inf),
	\attack, 1.32,
	\decay, 2.63,
	\release, 1.32,
	\fratio, 0.32,
	\freq1, 34,
	\freq2, 60,
	\freq3, 56,
	\aamp1, 1,
	\aamp2, 0,
	\aamp3, 1,
	\aamp4, 1,
	\curve1, -20.09,
	\curve2, 8.86,
	\curve3, 1.36,
	\famp1, 0.16,
	\famp2, 0.71,
	\famp3, 0,
	\famp4, 0,
	\p1, 0.83,
	\oamp, 0.63,
	\owhich2, 0,
	\ochoose, 0.54,
	\filter, 177,
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
				~autoGui.value(v, ~kickbassSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"done", ["none"],
					"level", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\level)), true],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"attack", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"decay", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\decay)), true],
					"release", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"fratio", ["slider", ControlSpec(0.01, 2, step: 0.01, default: event.at(\fratio)), true],
					"freq1", ["knob", ControlSpec(20, 120, step: 1, default: event.at(\freq1)), true],
					"freq2", ["knob", ControlSpec(20, 120, step: 1, default: event.at(\freq2)), true],
					"freq3", ["knob", ControlSpec(20, 120, step: 1, default: event.at(\freq3)), true],
					"aamp1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\aamp1)), true],
					"aamp2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\aamp2)), true],
					"aamp3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\aamp3)), true],
					"curve1", ["knob", ControlSpec(-50, 50, step: 0.01, default: event.at(\curve1)), true],
					"curve2", ["knob", ControlSpec(-50, 50, step: 0.01, default: event.at(\curve2)), true],
					"curve3", ["knob", ControlSpec(-50, 50, step: 0.01, default: event.at(\curve3)), true],
					"famp1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\famp1)), true],
					"famp2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\famp2)), true],
					"famp3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\famp3)), true],
					"famp4", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\famp4)), true],
					"p1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\p1)), true],
					"oamp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\oamp)), true],
					"owhich2", ["knob", ControlSpec(0, 3, step: 1, default: event.at(\owhich2)), true],
					"ochoose", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\ochoose)), true],
					"filter", ["knob", ControlSpec(150, 20000, step: 1, default: event.at(\filter)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern5 = Pbind(
	\instrument, \IkedaBreath,
	\dur, Pseq([0.4375, 1.75, 1.3125, 1.75, 0.4375, 1.3125], inf), // 0.4375+ 1.75+ 1.3125+ 1.75 +0.4375+ 1.3125 == 7
	\level, 0.08,
	\pan, Pwhite(-0.35, 0.35, inf),
	\note1, 127,
	\note2, 47.8,
	\amp1, 0.37,
	\amp2, 0.7,
	\lpfFreq, 20000,
	\hpfFreq, 20,
	\attack, 0.17,
	\decay, 0,
	\release, 0,
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
					"level", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\level)), true],
					"note1", ["slider", ControlSpec(0, 127, step: 0.1, default: event.at(\note1)), true],
					"note2", ["slider", ControlSpec(0, 127, step: 0.1, default: event.at(\note2)), true],
					"amp1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp1)), true],
					"amp2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp2)), true],
					"lpfFreq", ["knob", ControlSpec(20, 20000, step: 0.1, default: event.at(\lpfFreq)), true],
					"hpfFreq", ["knob", ControlSpec(20, 20000, step: 0.1, default: event.at(\hpfFreq)), true],
					"attack", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"decay", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\decay)), true],
					"release", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern6 = Pbind(
	\instrument, \cymnew,
	\dur, 0.875,
	\amp, 0.014,
	\att, 0,
	\rel, 2,
	\curve, -8,
	\tu, 6,
	\pan, Pwhite(-0.5, 0.5, inf),
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
				~autoGui.value(v, ~cymnewSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"att", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\att)), true],
					"rel", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true],
					"curve", ["knob", ControlSpec(-200, 200, step: 0.01, default: event.at(\curve)), true],
					"tu", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\tu)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern7 = Pbind(
	\instrument, \hat808,
	\dur, Pseq([0.4375, 0.21875, Rest(0.875), 0.4375, 0.21875, 0.4375, 0.875], inf),
             // 0.4375+ 0.21875+      0.875 + 0.4375+ 0.21875+ 0.4375+ 0.875 == 3.5
	\amp, 0.002,
	\tu, 1.23,
	\attack, 0,
	\release, Pseq([0.01, 0.03, 0.02, 0.01, 0.02, 0.05, 0.03], inf),
	\hpf, 14069,
	\rq, 0,
	\rel, 0.92,
	\lpf, 2834,
	\pan, Pwhite(-1.0, 1.0, inf),
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
				~autoGui.value(v, ~hat808SynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_gate", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.001, default: event.at(\amp)), true],
					"attack", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"release", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"tu", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\tu)), true],
					"hpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\hpf)), true],
					"lpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\lpf)), true],
					"rel", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true],
					"rq", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\rq)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern8 = Pbind(
	\instrument, \cym,
	\dur, Pwrand([3.5, 7], [0.7, 0.3].normalizeSum, inf),
	\amp, 0.05,
	\att, 0.47,
	\rel, 0.88,
	\curve, -8,
	\pan, Pwhite(-0.5, 0.5, inf),
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
				~autoGui.value(v, ~cymSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"doneAction", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"att", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\att)), true],
					"rel", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true],
					"curve", ["knob", ControlSpec(-200, 200, step: 0.01, default: event.at(\curve)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern9 = Pbind(
	\instrument, \harrish,
	\dur, Pseq([1.75, 3.5, 1.75], inf),
	\amp, 0.4,
	\pan, 0,
	\attack, 0.57,
	\sustain, 0,
	\release, 0,
	\curve, 5.13,
	\clipLevel, 0.006,
	\impFreq, 34,
	\impPhase, 0,
	\impLevel, 1,
	\noiseLevel, 0.3,
	\lpf, 20000,
	\eqfreq, 516,
	\eqrq, 0.16,
	\eqdb, -60,
	\hpf, 20,
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
				~autoGui.value(v, ~harrishSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"doneAction", ["none"],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"attack", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"sustain", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\sustain)), true],
					"release", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"curve", ["knob", ControlSpec(-6, 6, step: 0.01, default: event.at(\curve)), true],
					"clipLevel", ["knob", ControlSpec(0, 6, step: 0.01, default: event.at(\clipLevel)), true],
					"impFreq", ["knob", ControlSpec(0, 10000, step: 1, default: event.at(\impFreq)), true],
					"impPhase", ["slider", ControlSpec(0, 1, step: 0.01, default: event.at(\impPhase)), true],
					"impLevel", ["knob", ControlSpec(0, 6, step: 0.01, default: event.at(\impLevel)), true],
					"noiseLevel", ["knob", ControlSpec(0, 6, step: 0.01, default: event.at(\noiseLevel)), true],
					"lpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\lpf)), true],
					"eqfreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\eqfreq)), true],
					"eqrq", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\eqrq)), true],
					"eqdb", ["knob", ControlSpec(-60, 60, step: 0.01, default: event.at(\eqdb)), true],
					"hpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\hpf)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern10 = Pbind(
	\instrument, \sinBass,
	\amp, 0.2,
	\dur, 3.5,
	\curve, 0,
	\loopNode, 0,
	\attack, 0,
	\release, 2,
	\envLevel1, 0,
	\envLevel2, 64,
	\envLevel3, 20.3,
	\envLevel4, 73.5,
	\envLevel5, 20.9,
	\envLevel6, 56,
	\envTime1, 0.01,
	\envTime2, 0.15,
	\envTime3, 0.75,
	\envTime4, 0.52,
	\envTime5, 0.5,
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
				~autoGui.value(v, ~sinBassSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false],
					"amp", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\amp)), true],
					"gate", ["none"],
					"curve", ["knob", ControlSpec(-8, 8, step: 1, default: event.at(\curve)), true],
					"loopNode", ["knob", ControlSpec(0, 4, step: 1, default: event.at(\loopNode)), true],
					"attack", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"release", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"envLevel1", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel1)), true],
					"envLevel2", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel2)), true],
					"envLevel3", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel3)), true],
					"envLevel4", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel4)), true],
					"envLevel5", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel5)), true],
					"envLevel6", ["knob", ControlSpec(0, 80, step: 0.1, default: event.at(\envLevel6)), true],
					"envTime1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envTime1)), true],
					"envTime2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envTime2)), true],
					"envTime3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envTime3)), true],
					"envTime4", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envTime4)), true],
					"envTime5", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envTime5)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern11 = Pbind(
	\instrument, \main,
	[\dur, \freq, \att], Pseq([[0.75, 49, 0.79], [1, 49, 1], [0.5, 46, 0.02], [3, 49, 0.16], [0.75, 39.2, 0.02], [1, 49, 0.5]/**/, [0.75, 49, 0.79], [1, 49, 1], [0.5, 46, 0.02], [3, 49, 0.16], [0.75, 39.2, 0.02], [1, 52.8, 0.55]], inf), // 0.75+ 1+ 0.5+ 3+ 0.75+ 1 == 7
	/*\dur, Pseq([0.75, 1, 0.5, 3, 0.75, 1], inf),
	\att, Pseq([0.79, 1, 0.02, 0.16], inf),
	\freq, 49,*/
	\amp, 0.043,
	\sinAmp, 2,
	\sel, 0,
	\levelScale, 1.53,
	\timeScale, 1,
	\hpf, 8000,
	\sinFreq, 30,
	\rel, 0.79,
	\pan, 0,
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
				~autoGui.value(v, ~mainSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"doneAction", ["none"],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"sinAmp", ["knob", ControlSpec(0, 5, step: 0.01, default: event.at(\sinAmp)), true],
					"levelScale", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\levelScale)), true],
					"timeScale", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\timeScale)), true],
					"hpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\hpf)), true],
					"sinFreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\sinFreq)), true],
					"freq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\freq)), true],
					"sel", ["slider", ControlSpec(0, 3, step: 1, default: event.at(\sel)), true],
					"att", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\att)), true],
					"rel", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern12 = Pbind(
	\instrument, \kSpluck3,
	\dur, Pwrand([3.5, Rest(3.5)], [0.85, 0.15].normalizeSum, inf),
	\amp, 0.03,
	\att, 0.47,
	\rel, 0.88,
	\midiPitch, 24,
	\art, Pwhite(-3.0, 3.0, inf),
	\noiseFreq, 1,
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
				~autoGui.value(v, ~kSpluck3SynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"doneAction", ["none"],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"att", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\att)), true],
					"rel", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true],
					"midiPitch", ["knob", ControlSpec(0, 127, step: 0.1, default: event.at(\midiPitch)), true],
					"art", ["knob", ControlSpec(-3, 3, step: 0.1, default: event.at(\art)), true],
					"noiseFreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\noiseFreq)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern13 = Pbind( // randLo = 0, randHi = 20000, bprq = 1
	\instrument, \Lumbricost,
	\dur, Pwrand([3.5, 7], [0.7, 0.3].normalizeSum, inf),
	\amp, 0.05,
	\attTim, 1,
	\relTim, 2.5,
	\scale, 6,
	\offset, 40,
	\synch, 10,
	\timescale, 10,
	\randLo, 0,
	\randHi, 20000,
	\bprq, 1,
	\pan, Pwhite(-0.5, 0.5, inf),
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
				~autoGui.value(v, ~lumbricostSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"doneAction", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"attTim", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\attTim)), true],
					"relTim", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\relTim)), true],
					"scale", ["knob", ControlSpec(0, 128, step: 1, default: event.at(\scale)), true],
					"offset", ["knob", ControlSpec(0, 60, step: 0.1, default: event.at(\offset)), true],
					"synch", ["knob", ControlSpec(0, 40, step: 0.1, default: event.at(\synch)), true],
					"timescale", ["knob", ControlSpec(0, 40, step: 0.1, default: event.at(\timescale)), true],
					"randLo", ["knob", ControlSpec(0, 20000, step: 1, default: event.at(\randLo)), true],
					"randHi", ["knob", ControlSpec(0, 20000, step: 1, default: event.at(\randHi)), true],
					"bprq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\bprq)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~pattern1 = Pbind(
	\instrument, \samplerStereo,
	\dur, Pdefn(\durSnapkick),
	\amp, 0.7,
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
				~autoGui.value(v, ~samplerStereoSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
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
