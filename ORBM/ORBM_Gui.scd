(

///////////////////////////////////////  Mixer Gui

var channel, channelMaster, ccStart,
arguments, synthCcStart, synthWindow, button, knob, active;

~ccStart = 21; // start mapping midi cc from here
~ccStart = ~ccStart.max(0).min(127); // limit ccStart

~ccStart = ~ccStart - 1;
channel = IdentityDictionary.new;

w = Window("Mixer",Rect(0, 0, 850, 725), scroll: true);
w.front;
//w.alwaysOnTop_(true);
w.view.decorator = FlowLayout(w.view.bounds, 3@3, 3@3);

///////////////////////////////////////  Channel

~channelNumber.do {
	arg i;
	channel[\channelView] = CompositeView(w, 118@720);
	channel[\channelView].background_(Color.white);
	channel[\channelView].decorator_(FlowLayout(channel[\channelView].bounds, 3@3, 3@3));

	// Channel name
	StaticText(channel[\channelView], 100@10)
	    .string_("Channel " ++ i)
	    .stringColor_(Color.black)
	    .align_(\center);
	channel[\channelView].decorator.nextLine;

	// hpf
	channel[(\activeHpf ++ i).asSymbol] = false;
	channel[(\hpfreq ++ i).asSymbol] = EZKnob(channel[\channelView], 120@70, 'hpfreq', ControlSpec(20, 20000, step: 1, default: 20, units: 'hz'), { arg hpfreq; currentEnvironment.at((\channel ++ i).asSymbol).set(\hpfreq, hpfreq.value); channel[(\activeHpf ++ i).asSymbol] = false; }, margin: 39@0);
	channel[\channelView].decorator.nextLine;

	// hpf midi map
	~ccStart = ~ccStart + 1;
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
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " hpfreq cc number");

	3.do({
		arg j;
		var default;
		switch(j,
			0, { default = 80 },
			1, { default = 1200 },
			2, { default = 8000 },
			{ default = 1200; }
		);
		j = j + 1;
		// freq
		channel[(\activeBand ++ j ++ \Freq ++ i).asSymbol] = false;
		channel[(\band ++ j ++ \freq ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'freq' ++ j, ControlSpec(20, 20000, step: 1, default: default, units: 'hz'), { arg freq; currentEnvironment.at((\channel ++ i).asSymbol).set((\band ++ j ++ \freq).asSymbol, freq.value); channel[(\activeBand ++ j ++ \Freq ++ i).asSymbol] = false; });

		// freq midi map
		~ccStart = ~ccStart + 1;
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
		}, ~ccStart, 0);
		(~ccStart).debug("Channel " ++ i ++ " band" ++ j ++ "freq cc number");

		// rq
		channel[(\activeBand ++ j ++ \Rq ++ i).asSymbol] = false;
		channel[(\band ++ j ++ \rq ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'rq' ++ j, ControlSpec(0, 1, step: 0.01, default: 1), { arg rq; currentEnvironment.at((\channel ++ i).asSymbol).set((\band ++ j ++ \rq).asSymbol, rq.value); channel[(\activeBand ++ j ++ \Rq ++ i).asSymbol] = false; });

		// rq midi map
		~ccStart = ~ccStart + 1;
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
		}, ~ccStart, 0);
		(~ccStart).debug("Channel " ++ i ++ " band" ++ j ++ "rq cc number");

		// db
		channel[(\activeBand ++ j ++ \Db ++ i).asSymbol] = false;
		channel[(\band ++ j ++ \db ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'db' ++ j, ControlSpec(0, 60, step: 1, default: 0, units: 'db'), { arg db; currentEnvironment.at((\channel ++ i).asSymbol).set((\band ++ j ++ \db).asSymbol, db.value); channel[(\activeBand ++ j ++ \Db ++ i).asSymbol] = false; });

		// db midi map
		~ccStart = ~ccStart + 1;
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
		}, ~ccStart, 0);
		(~ccStart).debug("Channel " ++ i ++ " band" ++ j ++ "db cc number");
	});

	// lpf
	channel[(\activeLpf ++ i).asSymbol] = false;
	channel[(\lpfreq ++ i).asSymbol] = EZKnob(channel[\channelView], 124@70, 'lpfreq', ControlSpec(20, 20000, step: 1, default: 20000, units: 'hz'), { arg lpfreq; currentEnvironment.at((\channel ++ i).asSymbol).set(\lpfreq, lpfreq.value); channel[(\activeLpf ++ i).asSymbol] = false; }, margin: 39@0);
	channel[\channelView].decorator.nextLine;

	// lpf midi map
	~ccStart = ~ccStart + 1;
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
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " lpfreq cc number");



	2.do({
		arg j;
		j = j + 1;
		// aux
		channel[(\activeAux ++ j ++ i).asSymbol] = false;
		channel[(\aux ++ j ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'aux' ++ j, ControlSpec(0, 1, step: 0.01, default: 0), { arg aux; currentEnvironment.at((\channel ++ i).asSymbol).set((\auxsend ++ j).asSymbol, aux.value); channel[(\activeAux ++ j ++ i).asSymbol] = false; });

		// aux midi map
		~ccStart = ~ccStart + 1;
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
		}, ~ccStart, 0);
		(~ccStart).debug("Channel " ++ i ++ " aux" ++ j ++ " cc number");

		if (j == 1, {
			StaticText(channel[\channelView], 35@65)
			    .string_("Send")
	            .align_(\center);
		});
	});

	// mute
	channel[(\mute ++ i).asSymbol] = Button(channel[\channelView], Rect(10,110,112,35)).states_([["Mute", Color.black, Color.white],["Active", Color.white, Color.grey]]).action = { arg mute; currentEnvironment.at((\channel ++ i).asSymbol).set(\mute, mute.value.linlin(0, 1, 1, 0)); };

	// mute midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var midiControl;
		midiControl = val.linlin(0, 127, 0, 1);
		{ channel[(\mute ++ i).asSymbol].valueAction_(midiControl); }.defer;
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " mute cc number");

	// pan
	channel[(\activePan ++ i).asSymbol] = false;
	channel[(\pan ++ i).asSymbol] = EZSlider(channel[\channelView], 112@60, 'pan', ControlSpec(-1, 1, step: 0.01, default: 0), { arg pan; currentEnvironment.at((\channel ++ i).asSymbol).set(\pan, pan.value); channel[(\activePan ++ i).asSymbol] = false; }, layout: 'vert');
	channel[\channelView].decorator.nextLine;

	// pan midi map
	~ccStart = ~ccStart + 1;
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
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " pan cc number");

	// level
	channel[(\activeLevel ++ i).asSymbol] = false;
	channel[(\level ++ i).asSymbol] = EZSlider(channel[\channelView], 110@160, 'level', ControlSpec(0, 1, step: 0.01, default: 0.5), { arg level; currentEnvironment.at((\channel ++ i).asSymbol).set(\level, level.value); channel[(\activeLevel ++ i).asSymbol] = false; }, layout: 'vert', margin: 39@0);

	// level midi map
	~ccStart = ~ccStart + 1;
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
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " level cc number");
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

// hpf
channel[\hpfreqMaster] = EZKnob(channelMaster, 120@70, 'hpfreq', ControlSpec(20, 20000, step: 1, default: 20, units: 'hz'), { arg hpfreq; ~master.set(\hpfreq, hpfreq.value); }, margin: 39@0).setColors(stringColor: Color.white);
channelMaster.decorator.nextLine;

// lpf
channel[\lpfreqMaster] = EZKnob(channelMaster, 124@70, 'lpfreq', ControlSpec(20, 20000, step: 1, default: 20000, units: 'hz'), { arg lpfreq; ~master.set(\lpfreq, lpfreq.value); }, margin: 39@0).setColors(stringColor: Color.white);
channelMaster.decorator.nextLine;

// level
channel[\levelMaster] = EZSlider(channelMaster, 110@160, 'level', ControlSpec(0, 1, step: 0.01, default: 0.5), { arg level; ~master.set(\level, level.value); }, layout: 'vert', margin: 39@0).setColors(stringColor: Color.white);

///////////////////////////////////////  SynthDef Gui

x = Window("SynthDef",Rect(0, 0, 1200, 725), scroll: true);
x.front;
x.view.decorator = FlowLayout(x.view.bounds, 3@3, 3@3);

~autoGui.value(x, ~samplerStereoSynthDef, ~samplerStereo, 85, Color.new255(107, 142, 35), Dictionary.newFrom(List["pan", ["none"], "attack", ["slider", ControlSpec(0, 10, step: 0.01, default: 0), true], "buffer", ["List", Array.fill(b[\Bowed_Empty_Sweep_Slow].size, { arg i; var filePath; filePath = PathName.new(b[\Bowed_Empty_Sweep_Slow][i].path); filePath.fileName.asString; }), true], "gate", ["button", ControlSpec(0, 1, step: 1, default: 0), true], "loop", ["button", ControlSpec(0, 1, step: 1, default: 0), true]]));

~autoGui.value(x, ~sinBassSynthDef, ~sinBass, 93, Color.new255(205, 149, 12), Dictionary.newFrom(List["pan", ["knob", ControlSpec(-1, 1, step: 0.01, default: 0), false], "amp", ["slider", ControlSpec(0, 10, step: 0.01, default: 0), true], "gate", ["button", ControlSpec(0, 1, step: 1, default: 0), true]]));

)