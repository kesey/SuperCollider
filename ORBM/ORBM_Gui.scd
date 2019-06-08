(

///////////////////////////////////////  Gui

///////////////////////////////////////  Mixer

var channel, channelMaster, ccStart, mixerMidiChan,
arguments, synthCcStart, synthWindow, button, knob, active, pdefGuiView, ccStartPdMute, pdMidiChan;

~ccStart = 21; // start mapping midi cc from here
~ccStart = ~ccStart.max(1).min(127); // limit ccStart

mixerMidiChan = 0; // 0 for midi channel 1
mixerMidiChan = mixerMidiChan.max(0).min(15);
(mixerMidiChan).debug("mixer midi channel");

channel = IdentityDictionary.new;

w = Window("Mixer",Rect(0, 0, 850, 725), scroll: true);
w.front;
//w.alwaysOnTop_(true);
w.view.decorator = FlowLayout(w.view.bounds, 3@3, 3@3);

///////////////////////////////////////  Channel

~channelNumber.do { arg i;
	var bgColor;
	switch(i,
		2, { bgColor = ~aux1Color; },
		3, { bgColor = ~aux2Color; },
		{ bgColor = Color.white; }
	);
	channel[\channelView] = CompositeView(w, 118@720);
	channel[\channelView].background_(bgColor);
	channel[\channelView].decorator_(FlowLayout(channel[\channelView].bounds, 3@3, 3@3));

	// Channel name
	StaticText(channel[\channelView], 100@10)
	    .string_("Channel " ++ i)
	    .stringColor_(Color.black)
	    .align_(\center);
	channel[\channelView].decorator.nextLine;

	// lpf
	channel[(\activeLpf ++ i).asSymbol] = false;
	channel[(\lpfreq ++ i).asSymbol] = EZKnob(channel[\channelView], 124@70, 'lpfreq', ControlSpec(20, 20000, step: 1, default: 20000, units: 'hz'), { arg lpfreq; currentEnvironment.at((\channel ++ i).asSymbol).set(\lpfreq, lpfreq.value); channel[(\activeLpf ++ i).asSymbol] = false; }, margin: 39@0);
	channel[\channelView].decorator.nextLine;

	// lpf midi map
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, threshold;
		midiControl = val.linlin(0, 127, 20, 20000);
		guiControl = channel[(\lpfreq ++ i).asSymbol].value;
		threshold = 500;
		if ( // soft takeover
			(channel[(\activeLpf ++ i).asSymbol] or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
			{
				channel[(\activeLpf ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\lpfreq, midiControl);
					channel[(\lpfreq ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, mixerMidiChan);
	(~ccStart).debug("channel " ++ i ++ " lpfreq cc number");
	~ccStart = ~ccStart + 1;

	3.do({ arg j;
		var default;
		switch(j,
			0, { default = 8000; },
			1, { default = 1200; },
			2, { default = 80; },
			{ default = 1200; }
		);
		j = j + 1;
		// freq
		channel[(\activeBand ++ j ++ \Freq ++ i).asSymbol] = false;
		channel[(\band ++ j ++ \freq ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'freq' ++ j, ControlSpec(20, 20000, step: 1, default: default, units: 'hz'), { arg freq; currentEnvironment.at((\channel ++ i).asSymbol).set((\band ++ j ++ \freq).asSymbol, freq.value); channel[(\activeBand ++ j ++ \Freq ++ i).asSymbol] = false; });

		// freq midi map
		MIDIFunc.cc({ arg val, num, chan, src;
			var guiControl, midiControl, threshold;
			midiControl = val.linlin(0, 127, 20, 20000);
			guiControl = channel[(\band ++ j ++ \freq ++ i).asSymbol].value;
			threshold = 500;
			if ( // soft takeover
				(channel[(\activeBand ++ j ++ \Freq ++ i).asSymbol] or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
				{
					channel[(\activeBand ++ j ++ \Freq ++ i).asSymbol] = true;
					{
						currentEnvironment.at((\channel ++ i).asSymbol).set((\band ++ j ++ \freq).asSymbol, midiControl);
						channel[(\band ++ j ++ \freq ++ i).asSymbol].value_(midiControl);
					}.defer;
				}
			);
		}, ~ccStart, mixerMidiChan);
		(~ccStart).debug("channel " ++ i ++ " band" ++ j ++ "freq cc number");
		~ccStart = ~ccStart + 1;

		// rq
		channel[(\activeBand ++ j ++ \Rq ++ i).asSymbol] = false;
		channel[(\band ++ j ++ \rq ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'rq' ++ j, ControlSpec(0, 1, step: 0.01, default: 1), { arg rq; currentEnvironment.at((\channel ++ i).asSymbol).set((\band ++ j ++ \rq).asSymbol, rq.value); channel[(\activeBand ++ j ++ \Rq ++ i).asSymbol] = false; });

		// rq midi map
		MIDIFunc.cc({ arg val, num, chan, src;
			var guiControl, midiControl, threshold;
			midiControl = val.linlin(0, 127, 0, 1);
			guiControl = channel[(\band ++ j ++ \rq ++ i).asSymbol].value;
			threshold = 0.1;
			if ( // soft takeover
				(channel[(\activeBand ++ j ++ \Rq ++ i).asSymbol] or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
				{
					channel[(\activeBand ++ j ++ \Rq ++ i).asSymbol] = true;
					{
						currentEnvironment.at((\channel ++ i).asSymbol).set((\band ++ j ++ \rq).asSymbol, midiControl);
						channel[(\band ++ j ++ \rq ++ i).asSymbol].value_(midiControl);
					}.defer;
				}
			);
		}, ~ccStart, mixerMidiChan);
		(~ccStart).debug("channel " ++ i ++ " band" ++ j ++ "rq cc number");
		~ccStart = ~ccStart + 1;

		// db
		channel[(\activeBand ++ j ++ \Db ++ i).asSymbol] = false;
		channel[(\band ++ j ++ \db ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'db' ++ j, ControlSpec(0, 60, step: 1, default: 0, units: 'db'), { arg db; currentEnvironment.at((\channel ++ i).asSymbol).set((\band ++ j ++ \db).asSymbol, db.value); channel[(\activeBand ++ j ++ \Db ++ i).asSymbol] = false; });

		// db midi map
		MIDIFunc.cc({ arg val, num, chan, src;
			var guiControl, midiControl, threshold;
			midiControl = val.linlin(0, 127, 0, 60);
			guiControl = channel[(\band ++ j ++ \db ++ i).asSymbol].value;
			threshold = 10;
			if ( // soft takeover
				(channel[(\activeBand ++ j ++ \Db ++ i).asSymbol] or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
				{
					channel[(\activeBand ++ j ++ \Db ++ i).asSymbol] = true;
					{
						currentEnvironment.at((\channel ++ i).asSymbol).set((\band ++ j ++ \db).asSymbol, midiControl);
						channel[(\band ++ j ++ \db ++ i).asSymbol].value_(midiControl);
					}.defer;
				}
			);
		}, ~ccStart, mixerMidiChan);
		(~ccStart).debug("channel " ++ i ++ " band" ++ j ++ "db cc number");
		~ccStart = ~ccStart + 1;
	});

	// hpf
	channel[(\activeHpf ++ i).asSymbol] = false;
	channel[(\hpfreq ++ i).asSymbol] = EZKnob(channel[\channelView], 120@70, 'hpfreq', ControlSpec(20, 20000, step: 1, default: 20, units: 'hz'), { arg hpfreq; currentEnvironment.at((\channel ++ i).asSymbol).set(\hpfreq, hpfreq.value); channel[(\activeHpf ++ i).asSymbol] = false; }, margin: 39@0);
	channel[\channelView].decorator.nextLine;

	// hpf midi map
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, threshold;
		midiControl = val.linlin(0, 127, 20, 20000);
		guiControl = channel[(\hpfreq ++ i).asSymbol].value;
		threshold = 500;
		if ( // soft takeover
			(channel[(\activeHpf ++ i).asSymbol] or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
			{
				channel[(\activeHpf ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\hpfreq, midiControl);
					channel[(\hpfreq ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, mixerMidiChan);
	(~ccStart).debug("channel " ++ i ++ " hpfreq cc number");
	~ccStart = ~ccStart + 1;

	2.do({ arg j;
		var color;
		switch(j,
			0, { color = ~aux1Color; },
			1, { color = ~aux2Color; },
			{ color = Color.white; }
		);
		j = j + 1;
		// aux
		channel[(\activeAux ++ j ++ i).asSymbol] = false;
		channel[(\aux ++ j ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'aux' ++ j, ControlSpec(0, 1, step: 0.01, default: 0), { arg aux; currentEnvironment.at((\channel ++ i).asSymbol).set((\auxsend ++ j).asSymbol, aux.value); channel[(\activeAux ++ j ++ i).asSymbol] = false; }).setColors(background: color);

		// aux midi map
		MIDIFunc.cc({ arg val, num, chan, src;
			var guiControl, midiControl, threshold;
			midiControl = val.linlin(0, 127, 0, 1);
			guiControl = channel[(\aux ++ j ++ i).asSymbol].value;
			threshold = 0.1;
			if ( // soft takeover
				(channel[(\activeAux ++ j ++ i).asSymbol] or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
				{
					channel[(\activeAux ++ j ++ i).asSymbol] = true;
					{
						currentEnvironment.at((\channel ++ i).asSymbol).set((\auxsend ++ j).asSymbol, midiControl);
						channel[(\aux ++ j ++ i).asSymbol].value_(midiControl);
					}.defer;
				}
			);
		}, ~ccStart, mixerMidiChan);
		(~ccStart).debug("channel " ++ i ++ " aux" ++ j ++ " cc number");
		~ccStart = ~ccStart + 1;

		if (j == 1, {
			StaticText(channel[\channelView], 35@65)
			    .string_("Send")
	            .align_(\center);
		});
	});

	// mute
	channel[(\mute ++ i).asSymbol] = Button(channel[\channelView], Rect(10,110,112,35)).states_([["Mute", Color.black, Color.white],["Active", Color.white, Color.grey]]).action = { arg mute; currentEnvironment.at((\channel ++ i).asSymbol).set(\mute, mute.value.linlin(0, 1, 1, 0)); };

	// mute midi map
	MIDIFunc.cc({ arg val, num, chan, src;
		var midiControl;
		midiControl = val.linlin(0, 127, 0, 1);
		{ channel[(\mute ++ i).asSymbol].valueAction_(midiControl); }.defer;
	}, ~ccStart, mixerMidiChan);
	(~ccStart).debug("channel " ++ i ++ " mute cc number");
	~ccStart = ~ccStart + 1;

	// pan
	channel[(\activePan ++ i).asSymbol] = false;
	channel[(\pan ++ i).asSymbol] = EZSlider(channel[\channelView], 112@60, 'pan', ControlSpec(-1, 1, step: 0.01, default: 0), { arg pan; currentEnvironment.at((\channel ++ i).asSymbol).set(\pan, pan.value); channel[(\activePan ++ i).asSymbol] = false; }, layout: 'vert');
	channel[\channelView].decorator.nextLine;

	// pan midi map
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, threshold;
		midiControl = val.linlin(0, 127, -1, 1);
		guiControl = channel[(\pan ++ i).asSymbol].value;
		threshold = 0.1;
		if ( // soft takeover
			(channel[(\activePan ++ i).asSymbol] or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
			{
				channel[(\activePan ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\pan, midiControl);
					channel[(\pan ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, mixerMidiChan);
	(~ccStart).debug("channel " ++ i ++ " pan cc number");
	~ccStart = ~ccStart + 1;

	// level
	channel[(\activeLevel ++ i).asSymbol] = false;
	channel[(\level ++ i).asSymbol] = EZSlider(channel[\channelView], 110@160, 'level', ControlSpec(0, 1, step: 0.01, default: 0.5), { arg level; currentEnvironment.at((\channel ++ i).asSymbol).set(\level, level.value); channel[(\activeLevel ++ i).asSymbol] = false; }, layout: 'vert', margin: 39@0);

	// level midi map
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, threshold;
		midiControl = val.linlin(0, 127, 0, 1);
		guiControl = channel[(\level ++ i).asSymbol].value;
		threshold = 0.1;
		if ( // soft takeover
			(channel[(\activeLevel ++ i).asSymbol] or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
			{
				channel[(\activeLevel ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\level, midiControl);
					channel[(\level ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, mixerMidiChan);
	(~ccStart).debug("channel " ++ i ++ " level cc number");
	~ccStart = ~ccStart + 1;
};

channelMaster = CompositeView(w, 118@350);
channelMaster.background_(Color.grey);
channelMaster.decorator_(FlowLayout(channelMaster.bounds, 3@3, 3@3));

// Channel name
StaticText(channelMaster, 100@10)
	.string_("Master")
	.stringColor_(Color.white)
	.align_(\center);
channelMaster.decorator.nextLine;

// lpf
channel[\lpfreqMaster] = EZKnob(channelMaster, 124@70, 'lpfreq', ControlSpec(20, 20000, step: 1, default: 20000, units: 'hz'), { arg lpfreq; ~master.set(\lpfreq, lpfreq.value); }, margin: 39@0).setColors(stringColor: Color.white);
channelMaster.decorator.nextLine;

// hpf
channel[\hpfreqMaster] = EZKnob(channelMaster, 120@70, 'hpfreq', ControlSpec(20, 20000, step: 1, default: 20, units: 'hz'), { arg hpfreq; ~master.set(\hpfreq, hpfreq.value); }, margin: 39@0).setColors(stringColor: Color.white);
channelMaster.decorator.nextLine;

// level
channel[\levelMaster] = EZSlider(channelMaster, 110@160, 'level', ControlSpec(0, 1, step: 0.01, default: 0.5), { arg level; ~master.set(\level, level.value); }, layout: 'vert', margin: 39@0).setColors(stringColor: Color.white);

///////////////////////////////////////  SynthDef Gui

x = Window("SynthDef", Rect(0, 0, 1200, 725));
x.layout = VLayout();
x.front;

v = ScrollView(x, x.view.bounds);
v.canvas = View();
v.canvas.layout = VLayout();

~autoGui.value(v, ~samplerStereoSynthDef, ~samplerStereo, 85/*cc start*/, 0/*midi channel*/, Color.new255(107, 142, 35), Dictionary.newFrom(List["pan", ["none"], "attack", ["slider", ControlSpec(0, 10, step: 0.01, default: 10), true], "buffer", ["List", Array.fill(b[\Bowed_Empty_Sweep_Slow].size, { arg i; var filePath; filePath = PathName.new(b[\Bowed_Empty_Sweep_Slow][i].path); filePath.fileName.asString; }), true], "gate", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "loop", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "rate", ["knob", ControlSpec(0.01, 24, step: 0.01, default: 0.21), true], "startPos", ["slider", ControlSpec(0, 1, step: 0.01, default: 0.07), true], "release", ["slider", ControlSpec(0, 10, step: 0.01, default: 2), true], "amp", ["knob", ControlSpec(0, 1, step: 0.01, default: 0.23), true]]));

~autoGui.value(v, ~sinBassSynthDef, ~sinBass, 93, 0, Color.new255(205, 149, 12), Dictionary.newFrom(List["pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false], "amp", ["slider", ControlSpec(0, 10, step: 0.01, default: 1.84), true], "gate", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "curve", ["knob", ControlSpec(-8, 8, step: 1, default: 0), true], "loopNode", ["knob", ControlSpec(0, 4, step: 1, default: 0), true], "attack", ["knob", ControlSpec(0, 10, step: 0.01, default: 0.2), true], "release", ["knob", ControlSpec(0, 10, step: 0.01, default: 4), true], "envLevel1", ["knob", ControlSpec(0, 80, step: 0.1, default: 0), true], "envLevel2", ["knob", ControlSpec(0, 80, step: 0.1, default: 40), true], "envLevel3", ["knob", ControlSpec(0, 80, step: 0.1, default: 32), true], "envLevel4", ["knob", ControlSpec(0, 80, step: 0.1, default: 50), true], "envLevel5", ["knob", ControlSpec(0, 80, step: 0.1, default: 0), true], "envLevel6", ["knob", ControlSpec(0, 80, step: 0.1, default: 60), true], "envTime1", ["knob", ControlSpec(0, 1, step: 0.01, default: 0.5), true], "envTime2", ["knob", ControlSpec(0, 1, step: 0.01, default: 0.3), true], "envTime3", ["knob", ControlSpec(0, 1, step: 0.01, default: 0.25), true], "envTime4", ["knob", ControlSpec(0, 1, step: 0.01, default: 1), true], "envTime5", ["knob", ControlSpec(0, 1, step: 0.01, default: 0.5), true]]));

////////////////////  Pdef Mute Gui

ccStartPdMute = 1;
pdMidiChan = 0; // 0 for midi channel 1
pdMidiChan = pdMidiChan.max(0).min(15);
(pdMidiChan).debug("units midi channel");

~activePdefMute = Dictionary.new;

pdefGuiView = CompositeView(bounds: (~pdefNumber * 62)@110)
.scroll(autoScrolls: true)
.minHeight_(115)
.minWidth_(780)
.background_(Color.grey);

pdefGuiView.layout = HLayout();

// Pdef Mute
~pdefNumber.do({ arg i;
	var mute, pdefNameString, pdefNameSymbol;

	mute = Dictionary.new;
	pdefNameString = ("unit" ++ (i + 1)).asString;
	pdefNameSymbol = pdefNameString.asSymbol;
	~activePdefMute.put(pdefNameString, false);

	mute.put(("mute" ++ i).asString,
		Button()
		.minHeight_(60)
		.states_([
			["mute " ++ pdefNameString, Color.black, Color.white],
			["unmute " ++ pdefNameString, Color.white, Color.new255(48, 48, 48)]
		])
		.action = { arg guiControl;
			var type, state;
			if(guiControl.value > 0,
				{
					type = \rest;
					state = true;
				},
				{
					type = ~patternType.at(pdefNameString);
					state = false;
				}
			);
			if(Pdef(pdefNameSymbol).source.notNil,
				{ Pbindef(pdefNameSymbol, \type, type).quant_(~globalQuant); }
			);
			~activePdefMute.put(pdefNameString, state);
		}
	);

	// button midi map
	MIDIFunc.cc({ arg val, num, chan, src;
		var midiControl;
		midiControl = val.linlin(0, 127, 0, 1);
		{
			mute.at(("mute" ++ i).asString).valueAction_(midiControl);
		}.defer;
	}, ccStartPdMute, pdMidiChan);
	(ccStartPdMute).debug(pdefNameString ++ " mute cc number");
	ccStartPdMute = ccStartPdMute + 1;

	pdefGuiView.layout.add(mute.at(("mute" ++ i).asString));
});

v.canvas.layout.insert(pdefGuiView);

///////////////////////////////////////  Fx Gui

y = Window("Fx", Rect(250, 120, 820, 520));
y.layout = VLayout();
y.front;

u = ScrollView(y, y.view.bounds);
u.canvas = View();
u.canvas.layout = VLayout();

// Aux 2
~autoGui.value(u, ~verbSynthDef, ~verb, 110, 0, ~aux2Color, Dictionary.newFrom(List["pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false], "amp", ["none"], "drywet", ["knob", ControlSpec(0, 1, step: 0.01, default: 1), true]]));

~autoGui.value(u, ~flangingSynthDef, ~flanging, 666, 0, ~aux2Color, Dictionary.newFrom(List["fgfreq", ["slider", ControlSpec(0.01, 1000, step: 1, default: 0.2), true]]));

~autoGui.value(u, ~pitchShifterSynthDef, ~pitchShifter, 666, 0, ~aux2Color, Dictionary.newFrom(List["pitchRatio", ["slider", ControlSpec(0, 4, step: 0.01, default: 1), true]]));

~autoGui.value(u, ~quadDelaySynthDef, ~quadDelay, 115, 1, ~aux2Color, Dictionary.newFrom(List["tempoClock", ["none"], "amp", ["none"], "sync1", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "sync2", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "sync3", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "sync4", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "pan1", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false], "pan2", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false], "pan3", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false], "pan4", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false]]));

)