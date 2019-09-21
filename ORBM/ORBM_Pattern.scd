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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true]
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), false],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
	\dur, Pseq([0.875, 1.75, 1.25, 0.875, 1.375, 0.875], inf), // 0.875+ 1.75+ 1.25+ 0.875+ 1.375+ 0.875 == 7
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), false],
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
	\dur, Pseq([0.75, 1.5, 2, 1.75, 1]*2, inf), // 0.75+ 1.5+ 2+ 1.75+ 1 == 7
	\amp, 0.03,
	\att, Pseg([0.03, 0.21, 0.16, 0.13, 0.03, 0.23], [0.3, 0.03, 0.04, 0.09, 0.5], repeats: inf),
	\freq, Pseg([34, 37], [0.07], repeats: inf),
	\lev, 10,
	\sinAmp, 2,
	\sel, 0,
	\levelScale, 1.53,
	\levelBias, 0.48,
	\timeScale, 1,
	\hpf, 8000,
	\sinFreq, 30,
	\rel, 0.13,
	\revtime, 2.5,
	\room, Pseq([1.63, 16, 1.63, 10, 1.37], inf),
	\revMix, 0.3,
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), false],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"lev", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\lev)), true],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"sinAmp", ["knob", ControlSpec(0, 5, step: 0.01, default: event.at(\sinAmp)), true],
					"levelScale", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\levelScale)), true],
					"timeScale", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\timeScale)), true],
					"hpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\hpf)), true],
					"sinFreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\sinFreq)), true],
					"freq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\freq)), true],
					"sel", ["slider", ControlSpec(0, 3, step: 1, default: event.at(\sel)), true],
					"att", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\att)), true],
					"rel", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true],
					"revtime", ["slider", ControlSpec(0, 60, step: 0.1, default: event.at(\revtime)), true],
					"revMix", ["slider", ControlSpec(0, 60, step: 0.1, default: event.at(\revMix)), true],
					"room", ["knob", ControlSpec(0, 20, step: 0.01, default: event.at(\room)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern12 = Pbind(
	\instrument, \kSpluck3,
	//\dur, Pseq([7, 7, 7, 4.5, 2.5], inf),
	\amp, 0.014,
	[\dur, \att, \midiPitch],
	Pseq([
		[7, 0.47, 53.4],
		[14, 1.37, 53.4],
		[4.5, 1.32, 53.4],
		[2.5, 0.82, Penv([41,4, 35.3], [0.5], \exponential)]
	], inf),
	\rel, 2.11,
	\art, 0.6,
	\noiseFreq, Pseq([3707, 2700, 120, 3570, 4280], inf),
	\noiseLev, 13631,
	\noiseOffset, 13963,
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
					"art", ["knob", ControlSpec(-10, 10, step: 0.1, default: event.at(\art)), true],
					"noiseFreq", ["knob", ControlSpec(0, 20000, step: 1, default: event.at(\noiseFreq)), true],
					"noiseLev", ["knob", ControlSpec(0, 20000, step: 1, default: event.at(\noiseLev)), true],
					"noiseOffset", ["knob", ControlSpec(0, 20000, step: 1, default: event.at(\noiseLev)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song3Pattern13 = Pbind(
	\instrument, \lumbricost,
	\dur, 7, //Pwrand([3.5, 7], [0.7, 0.3].normalizeSum, inf),
	\amp, 0.3,
	\attTim, 1,
	\relTim, 2.5,
	\scale, 25,
	\offset, 24.7,
	\freq, 12,
	\timescale, 10,
	\randLo, 200,
	\randHi, 2000,
	\bprq, 1,
	\pan, Pwhite(-0.2, 0.2, inf),
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
					"t_gate", ["none"],
					"doneAction", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"amp", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\amp)), true],
					"attTim", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\attTim)), true],
					"relTim", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\relTim)), true],
					"scale", ["knob", ControlSpec(0, 48, step: 1, default: event.at(\scale)), true],
					"offset", ["knob", ControlSpec(0, 60, step: 0.1, default: event.at(\offset)), true],
					"freq", ["knob", ControlSpec(0, 40, step: 0.1, default: event.at(\freq)), true],
					"timescale", ["knob", ControlSpec(0, 40, step: 0.1, default: event.at(\timescale)), true],
					"randLo", ["knob", ControlSpec(0, 20000, step: 1, default: event.at(\randLo)), true],
					"randHi", ["knob", ControlSpec(0, 20000, step: 1, default: event.at(\randHi)), true],
					"bprq", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\bprq)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song4Pattern1 = Pbind(
	\instrument, \scratchi,
	\dur, 1.25,
	\amp, 13.2,
	\spread, 0.99, // 0
	\attack, 0.01,
	\release, 2,
	\freq, 6502, // 632, // 629 // 610 // 603 // 440
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
				~autoGui.value(v, ~scratchiSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"doneAction", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"amp", ["knob", ControlSpec(0, 24, step: 0.01, default: event.at(\amp)), true],
					"spread", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\spread)), true],
					"attack", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"release", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"freq", ["knob", ControlSpec(0, 20000, step: 0.1, default: event.at(\freq)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song4Pattern2 = Pbind(
	\instrument, \rim,
	\dur, 1.25,
	\timingOffset, Pseq([0.1, 0.375], inf),
	\amp, 0.16,
	\tu, 1.56,
	\envLev1, 0.65,
	\envLev2, 0.68,
	\envLev3, 0.11,
	\envLev4, 0.38,
	\att, 0.01,
	\dec, 0.004,
	\rel, 0.1,
	\hpf, 100,
	\lpf, 11100,
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
				~autoGui.value(v, ~rimSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_gate", ["none"],
					"doneAction", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"tu", ["knob", ControlSpec(0, 5, step: 0.01, default: event.at(\tu)), true],
					"envLev1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envLev1)), true],
					"envLev2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envLev2)), true],
					"envLev3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envLev3)), true],
					"envLev4", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envLev4)), true],
					"att", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\att)), true],
					"dec", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\dec)), true],
					"rel", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\rel)), true],
					"hpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\hpf)), true],
					"lpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\lpf)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song4Pattern3 = Pbind(
	\instrument, \tweetAnaBass,
	\dur, Pseq([2.5, 1.25], inf),
	\amp, 0.3,
	\attack, 0,
	\release, 1.75,
	\freq, 95,
	\ffreq, 53,
	\tu, 0.84,
	\compTresh, 0.31,
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
				~autoGui.value(v, ~tweetAnaBassSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_trig", ["none"],
					"doneAction", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"attack", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"release", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"freq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\freq)), true],
					"ffreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\ffreq)), true],
					"tu", ["knob", ControlSpec(0, 5, step: 0.01, default: event.at(\tu)), true],
					"compTresh", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\compTresh)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song4Pattern4 = Pbind(
	\instrument, \drumkick,
	\dur, Pseq([0.5, 0.75, 0.5, Rest(0.25), 0.5], inf),
	\amp, 0.2,
	\attack, 1.05,
	\release,0.16,
	\curve, -39.7,
	\attSinFreq, 0.01,
	\relSinFreq, 1.12,
	\curveSinFreq, -60,
	\levSin, 0.26,
	\attBpfFreq, 0.02,
	\relBpfFreq, 0.3,
	\timeScaleBpf, 1.11,
	\curveBpf, -200,
	\levBpf, 0.18,
	\levScaleBpf, 6000,
	\levBiasBpf, 21.3,
	\lineStartBpf, 0.3,
	\lineEndBpf, 0,
	\lineLevBpf, 0.15,
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
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"attack", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\attack)), true],
					"release", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\release)), true],
					"curve", ["knob", ControlSpec(-200, 200, step: 0.1, default: event.at(\curve)), true],
					"attSinFreq", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\attSinFreq)), true],
					"relSinFreq", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\relSinFreq)), true],
					"curveSinFreq", ["knob", ControlSpec(-200, 200, step: 0.1, default: event.at(\curveSinFreq)), true],
					"levSin", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\levSin)), true],
					"attBpfFreq", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\attBpfFreq)), true],
					"relBpfFreq", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\relBpfFreq)), true],
					"timeScaleBpf", ["slider", ControlSpec(0.01, 10, step: 0.01, default: event.at(\timeScaleBpf)), true],
					"curveBpf", ["knob", ControlSpec(-200, 200, step: 0.1, default: event.at(\curveBpf)), true],
					"levBpf", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\levBpf)), true],
					"levScaleBpf", ["knob", ControlSpec(0, 6000, step: 1, default: event.at(\levScaleBpf)), true],
					"levBiasBpf", ["knob", ControlSpec(0.1, 120, step: 0.1, default: event.at(\levBiasBpf)), true],
					"lineStartBpf", ["slider", ControlSpec(0, 2, step: 0.01, default: event.at(\lineStartBpf)), true],
					"lineEndBpf", ["slider", ControlSpec(0, 2, step: 0.01, default: event.at(\lineEndBpf)), true],
					"lineLevBpf", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\lineLevBpf)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song4Pattern5 = Pbind(
	\instrument, \kickhi,
	\dur, Pseq([Rest(0.375), 0.5, 0.375, Rest(0.25), 0.75, 0.25], inf),
	\amp, 0.8,
	\vcaLev1, 0.1,
	\vcaLev2, 0.26,
	\vcaLev3, 0.55,
	\vcaLev4, 0,
	\vcaLev5, 0,
	\vcaTime1, 0.02,
	\vcaTime2, 2.11,
	\vcaTime3, 1.84,
	\vcaTime4, 0.01,
	\vcaCurve1, -46.3,
	\vcaCurve2, -47.7,
	\vcaCurve3, -79.8,
	\vcfLev1, 0,
	\vcfLev2, 63.5,
	\vcfLev3, 16.2,
	\vcfLev4, 0,
	\vcfTime1, 0.02,
	\vcfTime2, 0.49,
	\vcfTime3, 0.02,
	\vcfCurve1, -8.4,
	\vcfCurve2, -85,
	\tu, 1.75,
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
				~autoGui.value(v, ~kickhiSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"doneAction", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"amp", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\amp)), true],
					"vcaLev1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\vcaLev1)), true],
					"vcaLev2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\vcaLev2)), true],
					"vcaLev3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\vcaLev3)), true],
					"vcaLev4", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\vcaLev4)), true],
					"vcaLev5", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\vcaLev5)), true],
					"vcaTime1", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\vcaTime1)), true],
					"vcaTime2", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\vcaTime2)), true],
					"vcaTime3", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\vcaTime3)), true],
					"vcaTime4", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\vcaTime4)), true],
					"vcaCurve1", ["knob", ControlSpec(-100, 100, step: 0.1, default: event.at(\vcaCurve1)), true],
					"vcaCurve2", ["knob", ControlSpec(-100, 100, step: 0.1, default: event.at(\vcaCurve2)), true],
					"vcaCurve3", ["knob", ControlSpec(-100, 100, step: 0.1, default: event.at(\vcaCurve3)), true],
					"vcfLev1", ["knob", ControlSpec(0, 127, step: 0.1, default: event.at(\vcfLev1)), true],
					"vcfLev2", ["knob", ControlSpec(0, 127, step: 0.1, default: event.at(\vcfLev2)), true],
					"vcfLev3", ["knob", ControlSpec(0, 127, step: 0.1, default: event.at(\vcfLev3)), true],
					"vcfLev4", ["knob", ControlSpec(0, 127, step: 0.1, default: event.at(\vcfLev4)), true],
					"vcfTime1", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\vcfTime1)), true],
					"vcfTime2", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\vcfTime2)), true],
					"vcfTime3", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\vcfTime3)), true],
					"vcfCurve1", ["knob", ControlSpec(-100, 100, step: 0.1, default: event.at(\vcfCurve1)), true],
					"vcfCurve2", ["knob", ControlSpec(-100, 100, step: 0.1, default: event.at(\vcfCurve2)), true],
					"tu", ["knob", ControlSpec(0, 5, step: 0.01, default: event.at(\tu)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song4Pattern6 = Pbind(
	\instrument, \snapkick,
	\dur, Pseq([1.5, Rest(0.5), 0.25, Rest(0.25), Rest(0.25), 1.5, 0.25, Rest(0.5)], inf),
	\amp, 0.25,
	\pan, 0,
	\bdFrqL1, 261,
	\bdFrqL2, 116,
	\bdFrqL3, 64,
	\bdFrqT1, 0.035,
	\bdFrqT2, 0.08,
	\bdFrqC, \exp,
	\bdAmpAtt, 0.01,
	\bdAmpSus, 0.1,
	\bdAmpRel, 0.3,
	\bdAmpLev, 1.36,
	\bdAmpCurve, 47.4,
	\popFrqSt, 750,
	\popFrqEnd, 261,
	\popFrqDur, 0.04,
	\popAmpAtt, 1.32,
	\popAmpSus, 0.02,
	\popAmpRel, 0.14,
	\popAmpLev, 0.39,
	\clkAmpAtt, 0,
	\clkAmpRel, 0.01,
	\clkAmpLev, 0.99,
	\clkAmpCurve, -14.9,
	\clkfFundFreq, 910,
	\clkfFormFreq, 5078,
	\clkfBwFreq, 14776,
	\clkLpfFreq, 5612,
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
				~autoGui.value(v, ~snapKickSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"doneAction", ["none"],
					"amp", ["knob", ControlSpec(0, 24, step: 0.01, default: event.at(\amp)), true],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"bdFrqL1", ["knob", ControlSpec(20, 20000, step: 0.1, default: event.at(\bdFrqL1)), true],
					"bdFrqL2", ["knob", ControlSpec(20, 20000, step: 0.1, default: event.at(\bdFrqL2)), true],
					"bdFrqL3", ["knob", ControlSpec(20, 20000, step: 0.1, default: event.at(\bdFrqL3)), true],
					"bdFrqT1", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\bdFrqT1)), true],
					"bdFrqT2", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\bdFrqT2)), true],
					"bdFrqC", ["knob", ControlSpec(-200, 200, step: 0.1, default: event.at(\bdFrqC)), true],
					"bdAmpAtt", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\bdFrqC)), true],
					"bodyAmpAtt", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\bdAmpAtt)), true],
					"bdAmpSus", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\bdAmpSus)), true],
					"bdAmpRel", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\bdAmpRel)), true],
					"bdAmpLev", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\bdAmpLev)), true],
					"bdAmpCurve", ["knob", ControlSpec(-200, 200, step: 0.1, default: event.at(\bdAmpCurve)), true],
					"popFrqSt", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\popFrqSt)), true],
					"popFrqEnd", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\popFrqEnd)), true],
					"popFrqDur", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\popFrqDur)), true],
					"popAmpAtt", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\popAmpAtt)), true],
					"popAmpSus", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\popAmpSus)), true],
					"popAmpRel", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\popAmpRel)), true],
					"popAmpLev", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\popAmpLev)), true],
					"clkAmpAtt", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\clkAmpAtt)), true],
					"clkAmpRel", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\clkAmpRel)), true],
					"clkAmpLev", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\clkAmpLev)), true],
					"clkAmpCurve", ["knob", ControlSpec(-200, 200, step: 0.1, default: event.at(\clkAmpCurve)), true],
					"clkfFundFreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\clkfFundFreq)), true],
					"clkfFormFreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\clkfFormFreq)), true],
					"clkfBwFreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\clkfBwFreq)), true],
					"clkLpfFreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\clkLpfFreq)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song4Pattern7 = Pbind(
	\instrument, \fabHi,
	\dur, 0.25,
	\amp, 0.02,
	\pan, Pwhite(-1.0, 1.0, inf),
	\wamp, 0.84,
	\envNatt, 0,
	\envNrel, 0.26,
	\wbpfFreq, 3182,
	\wbpfRq, 1,
	\sinFrq1, 1365,
	\sinFrq2, 12423,
	\sinPh1, 0,
	\sinPh2, 0.02,
	\sinLev1, 14.13,
	\sinLev2, 5.56,
	\envSatt, 0.24,
	\envSrel, 0.2,
	\mix, 0.6,
	\envL1, 0,
	\envL2, 1,
	\envL3, 0.94,
	\envT1, 0.04,
	\envT2, Pseq([0.02, 0.06, 0.01, 0.018, 0, 0.02, 0.06, 0.01, 0.018, 3.11], inf),
	\envT3, Pseq([0.07, 0.01, 0.07, 0.002, 0.03, 0.007], inf),
	\ffreq, 12018,
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
				~autoGui.value(v, ~fabHiSynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"t_gate", ["none"],
					"doneAction", ["none"],
					"amp", ["knob", ControlSpec(0, 4, step: 0.01, default: event.at(\amp)), true],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"wamp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\wamp)), true],
					"envNatt", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envNatt)), true],
					"envNrel", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envNrel)), true],
					"wbpfFreq", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\wbpfFreq)), true],
					"wbpfRq", ["knob", ControlSpec(0.01, 1, step: 0.01, default: event.at(\wbpfRq)), true],
					"sinFrq1", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\sinFrq1)), true],
					"sinFrq2", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\sinFrq2)), true],
					"sinPh1", ["slider", ControlSpec(0, 1, step: 0.01, default: event.at(\sinPh1)), true],
					"sinPh2", ["slider", ControlSpec(0, 1, step: 0.01, default: event.at(\sinPh2)), true],
					"sinLev1", ["knob", ControlSpec(0, 24, step: 0.01, default: event.at(\sinLev1)), true],
					"sinLev2", ["knob", ControlSpec(0, 24, step: 0.01, default: event.at(\sinLev2)), true],
					"envSatt", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envSatt)), true],
					"envSrel", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envSrel)), true],
					"mix", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\mix)), true],
					"envL1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL1)), true],
					"envL2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL2)), true],
					"envL3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL3)), true],
					"envT1", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envT1)), true],
					"envT2", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envT2)), true],
					"envT3", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envT3)), true],
					"ffreq", ["knob", ControlSpec(02, 20000, step: 1, default: event.at(\ffreq)), true]
				]));
			}.defer;
			~pdefPrevInstr = currentInstr;
		});
		0;
	})
);

~song4Pattern8 = Pbind(
	\instrument, \cym1,
	\dur, Pseq([Rest(0.125), 0.125, 0.25, 0.125, Rest(0.125), 0.25, 0.125, Rest(0.125), Rest(0.125), 0.25, 0.25, Rest(0.125), 0.25, Rest(0.125), 0.125], inf),
	\amp, 0.006,
	\pan, Pwhite(-0.35, 0.35, inf),
	\envL1, 0.76,
	\envL2, 0,
	\envL3, 0.32,
	\envL4, 0.72,
	\levScale, 1,
	\envT1, 0.11,
	\envT2, 0.13,
	\envT3, 0.04,
	\envC1, -3.1,
	\envC2, 5,
	\envC3, -4,
	\tu, 0.56,
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
				~autoGui.value(v, ~cym1SynthDef, instance, ccStart, midiChan, Color.white, Dictionary.newFrom(List[
					"doneAction", ["none"],
					"pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: event.at(\pan)), true],
					"amp", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\amp)), true],
					"envL1", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL1)), true],
					"envL2", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL2)), true],
					"envL3", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL3)), true],
					"envL4", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\envL4)), true],
					"levScale", ["knob", ControlSpec(0, 10, step: 0.01, default: event.at(\levScale)), true],
					"envT1", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envT1)), true],
					"envT2", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envT2)), true],
					"envT3", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envT3)), true],
					"envT4", ["slider", ControlSpec(0, 10, step: 0.01, default: event.at(\envT4)), true],
					"envC1", ["knob", ControlSpec(-200, 200, step: 0.1, default: event.at(\envC1)), true],
					"envC2", ["knob", ControlSpec(-200, 200, step: 0.1, default: event.at(\envC2)), true],
					"envC3", ["knob", ControlSpec(-200, 200, step: 0.1, default: event.at(\envC3)), true],
					"tu", ["knob", ControlSpec(0, 2, step: 0.01, default: event.at(\tu)), true],
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
