(

///////////////////////////////////////  Mixer Gui

var channel, channelMaster, ccStart,
arguments, samplerCcStart, synthWindow, button, knob, active;

~ccStart = 21; // start mapping midi cc from here
~ccStart = ~ccStart - 1;
channel = IdentityDictionary.new;

w = Window("Mixer",Rect(0, 0, 850, 725), scroll: true);
w.front;
//w.alwaysOnTop_(true);
w.view.decorator = FlowLayout(w.view.bounds, 3@3, 3@3);

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
	channel[(\hpfreq ++ i).asSymbol] = EZKnob(channel[\channelView], 112@70, 'hpfreq', ControlSpec(20, 20000, step: 1, default: 20, units: 'hz'), { arg hpfreq; currentEnvironment.at((\channel ++ i).asSymbol).set(\hpfreq, hpfreq.value); channel[(\activeHpf ++ i).asSymbol] = false; }, margin: 39@0);
	channel[\channelView].decorator.nextLine;

	// hpf midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 20, 20000);
		guiControl = channel[(\hpfreq ++ i).asSymbol].value;
		treshold = 500;
		if ( // soft takeover
			(channel[(\activeHpf ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
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

	// band 1 freq
	channel[(\activeBand1Freq ++ i).asSymbol] = false;
	channel[(\band1freq ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'freq1', ControlSpec(20, 20000, step: 1, default: 80, units: 'hz'), { arg band1freq; currentEnvironment.at((\channel ++ i).asSymbol).set(\band1freq, band1freq.value); channel[(\activeBand1Freq ++ i).asSymbol] = false; });

	// band 1 freq midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 20, 20000);
		guiControl = channel[(\band1freq ++ i).asSymbol].value;
		treshold = 500;
		if ( // soft takeover
			(channel[(\activeBand1Freq ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeBand1Freq ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\band1freq, midiControl);
					channel[(\band1freq ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " band1freq cc number");

	// band 1 rq
	channel[(\activeBand1Rq ++ i).asSymbol] = false;
	channel[(\band1rq ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'rq1', ControlSpec(0, 1, step: 0.01, default: 1), { arg band1rq; currentEnvironment.at((\channel ++ i).asSymbol).set(\band1rq, band1rq.value); channel[(\activeBand1Rq ++ i).asSymbol] = false; });

	// band 1 rq midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 0, 1);
		guiControl = channel[(\band1rq ++ i).asSymbol].value;
		treshold = 0.1;
		if ( // soft takeover
			(channel[(\activeBand1Rq ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeBand1Rq ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\band1rq, midiControl);
					channel[(\band1rq ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " band1rq cc number");

	// band 1 db
	channel[(\activeBand1Db ++ i).asSymbol] = false;
	channel[(\band1db ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'db1', ControlSpec(0, 60, step: 1, default: 0, units: 'db'), { arg band1db; currentEnvironment.at((\channel ++ i).asSymbol).set(\band1db, band1db.value); channel[(\activeBand1Db ++ i).asSymbol] = false; });

	// band 1 db midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 0, 60);
		guiControl = channel[(\band1db ++ i).asSymbol].value;
		treshold = 10;
		if ( // soft takeover
			(channel[(\activeBand1Db ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeBand1Db ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\band1db, midiControl);
					channel[(\band1db ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " band1db cc number");

	// band 2 freq
	channel[(\activeBand2Freq ++ i).asSymbol] = false;
	channel[(\band2freq ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'freq2', ControlSpec(20, 20000, step: 1, default: 1200, units: 'hz'), { arg band2freq; currentEnvironment.at((\channel ++ i).asSymbol).set(\band2freq, band2freq.value); channel[(\activeBand2Freq ++ i).asSymbol] = false; });

	// band 2 freq midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 20, 20000);
		guiControl = channel[(\band2freq ++ i).asSymbol].value;
		treshold = 500;
		if ( // soft takeover
			(channel[(\activeBand2Freq ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeBand2Freq ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\band2freq, midiControl);
					channel[(\band2freq ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " band2freq cc number");

	// band 2 rq
	channel[(\activeBand2Rq ++ i).asSymbol] = false;
	channel[(\band2rq ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'rq2', ControlSpec(0, 1, step: 0.01, default: 1), { arg band2rq; currentEnvironment.at((\channel ++ i).asSymbol).set(\band2rq, band2rq.value); channel[(\activeBand2Rq ++ i).asSymbol] = false; });

	// band 2 rq midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 0, 1);
		guiControl = channel[(\band2rq ++ i).asSymbol].value;
		treshold = 0.1;
		if ( // soft takeover
			(channel[(\activeBand2Rq ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeBand2Rq ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\band2rq, midiControl);
					channel[(\band2rq ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " band2rq cc number");

	// band 2 db
	channel[(\activeBand2Db ++ i).asSymbol] = false;
	channel[(\band2db ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'db2', ControlSpec(0, 60, step: 1, default: 0, units: 'db'), { arg band2db; currentEnvironment.at((\channel ++ i).asSymbol).set(\band2db, band2db.value); channel[(\activeBand2Db ++ i).asSymbol] = false; });

	// band 2 db midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 0, 60);
		guiControl = channel[(\band2db ++ i).asSymbol].value;
		treshold = 10;
		if ( // soft takeover
			(channel[(\activeBand2Db ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeBand2Db ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\band2db, midiControl);
					channel[(\band2db ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " band2db cc number");

	// band 3 freq
	channel[(\activeBand3Freq ++ i).asSymbol] = false;
	channel[(\band3freq ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'freq3', ControlSpec(20, 20000, step: 1, default: 8000, units: 'hz'), { arg band3freq; currentEnvironment.at((\channel ++ i).asSymbol).set(\band3freq, band3freq.value); channel[(\activeBand3Freq ++ i).asSymbol] = false; });

	// band 3 freq midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 20, 20000);
		guiControl = channel[(\band3freq ++ i).asSymbol].value;
		treshold = 500;
		if ( // soft takeover
			(channel[(\activeBand3Freq ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeBand3Freq ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\band3freq, midiControl);
					channel[(\band3freq ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " band3freq cc number");

	// band 3 rq
	channel[(\activeBand3Rq ++ i).asSymbol] = false;
	channel[(\band3rq ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'rq3', ControlSpec(0, 1, step: 0.01, default: 1), { arg band3rq; currentEnvironment.at((\channel ++ i).asSymbol).set(\band3rq, band3rq.value); channel[(\activeBand3Rq ++ i).asSymbol] = false; });

	// band 3 rq midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 0, 1);
		guiControl = channel[(\band3rq ++ i).asSymbol].value;
		treshold = 0.1;
		if ( // soft takeover
			(channel[(\activeBand3Rq ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeBand3Rq ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\band3rq, midiControl);
					channel[(\band3rq ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " band3rq cc number");

	// band 3 db
	channel[(\activeBand3Db ++ i).asSymbol] = false;
	channel[(\band3db ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'db3', ControlSpec(0, 60, step: 1, default: 0, units: 'db'), { arg band3db; currentEnvironment.at((\channel ++ i).asSymbol).set(\band3db, band3db.value); channel[(\activeBand3Db ++ i).asSymbol] = false; });

	// band 3 db midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 0, 60);
		guiControl = channel[(\band3db ++ i).asSymbol].value;
		treshold = 10;
		if ( // soft takeover
			(channel[(\activeBand3Db ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeBand3Db ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\band3db, midiControl);
					channel[(\band3db ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " band3db cc number");

	// lpf
	channel[(\activeLpf ++ i).asSymbol] = false;
	channel[(\lpfreq ++ i).asSymbol] = EZKnob(channel[\channelView], 112@70, 'lpfreq', ControlSpec(20, 20000, step: 1, default: 20000, units: 'hz'), { arg lpfreq; currentEnvironment.at((\channel ++ i).asSymbol).set(\lpfreq, lpfreq.value); channel[(\activeLpf ++ i).asSymbol] = false; }, margin: 39@0);
	channel[\channelView].decorator.nextLine;

	// lpf midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 20, 20000);
		guiControl = channel[(\lpfreq ++ i).asSymbol].value;
		treshold = 500;
		if ( // soft takeover
			(channel[(\activeLpf ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
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

	// aux 1
	channel[(\activeAux1 ++ i).asSymbol] = false;
	channel[(\aux1 ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'aux1', ControlSpec(0, 1, step: 0.01, default: 0), { arg aux1; currentEnvironment.at((\channel ++ i).asSymbol).set(\auxsend1, aux1.value); channel[(\activeAux1 ++ i).asSymbol] = false; });

	// aux 1 midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 0, 1);
		guiControl = channel[(\aux1 ++ i).asSymbol].value;
		treshold = 0.1;
		if ( // soft takeover
			(channel[(\activeAux1 ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeAux1 ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\auxsend1, midiControl);
					channel[(\aux1 ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " aux1 cc number");

	StaticText(channel[\channelView], 35@65)
	    .string_("Send")
	    .align_(\center);

	// aux 2
	channel[(\activeAux2 ++ i).asSymbol] = false;
	channel[(\aux2 ++ i).asSymbol] = EZKnob(channel[\channelView], 35@70, 'aux2', ControlSpec(0, 1, step: 0.01, default: 0), { arg aux2; currentEnvironment.at((\channel ++ i).asSymbol).set(\auxsend2, aux2.value); channel[(\activeAux2 ++ i).asSymbol] = false; });

	// aux 2 midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 0, 1);
		guiControl = channel[(\aux2 ++ i).asSymbol].value;
		treshold = 0.1;
		if ( // soft takeover
			(channel[(\activeAux2 ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
			{
				channel[(\activeAux2 ++ i).asSymbol] = true;
				{
					currentEnvironment.at((\channel ++ i).asSymbol).set(\auxsend2, midiControl);
					channel[(\aux2 ++ i).asSymbol].value_(midiControl);
				}.defer;
			}
		);
	}, ~ccStart, 0);
	(~ccStart).debug("Channel " ++ i ++ " aux2 cc number");

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
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, -1, 1);
		guiControl = channel[(\pan ++ i).asSymbol].value;
		treshold = 0.1;
		if ( // soft takeover
			(channel[(\activePan ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
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
	channel[(\level ++ i).asSymbol] = EZSlider(channel[\channelView], 112@160, 'level', ControlSpec(0, 1, step: 0.01, default: 0.5), { arg level; currentEnvironment.at((\channel ++ i).asSymbol).set(\level, level.value); channel[(\activeLevel ++ i).asSymbol] = false; }, layout: 'vert', margin: 39@0);

	// level midi map
	~ccStart = ~ccStart + 1;
	MIDIFunc.cc({ arg val, num, chan, src;
		var guiControl, midiControl, treshold;
		midiControl = val.linlin(0, 127, 0, 1);
		guiControl = channel[(\level ++ i).asSymbol].value;
		treshold = 0.1;
		if ( // soft takeover
			(channel[(\activeLevel ++ i).asSymbol] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
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
channel[\hpfreqMaster] = EZKnob(channelMaster, 112@70, 'hpfreq', ControlSpec(20, 20000, step: 1, default: 20, units: 'hz'), { arg hpfreq; ~master.set(\hpfreq, hpfreq.value); }, margin: 39@0).setColors(stringColor: Color.white);
	channelMaster.decorator.nextLine;

// lpf
channel[\lpfreqMaster] = EZKnob(channelMaster, 112@70, 'lpfreq', ControlSpec(20, 20000, step: 1, default: 20000, units: 'hz'), { arg lpfreq; ~master.set(\lpfreq, lpfreq.value); }, margin: 39@0).setColors(stringColor: Color.white);
	channelMaster.decorator.nextLine;

// level
channel[\levelMaster] = EZSlider(channelMaster, 112@160, 'level', ControlSpec(0, 1, step: 0.01, default: 0.5), { arg level; ~master.set(\level, level.value); }, layout: 'vert', margin: 39@0).setColors(stringColor: Color.white);

///////////////////////////////////////  SynthDef Gui

x = Window("SynthDef",Rect(0, 0, 850, 725), scroll: true);
x.front;
x.view.decorator = FlowLayout(x.view.bounds, 3@3, 3@3);

////////////////////  Sampler
if (~sampler.notNil,
	{
	arguments = ~samplerSynthDef.allControlNames;

 	samplerCcStart = 9;

 	synthWindow = CompositeView(x, (arguments.size * 30)@(arguments.size * 10));
 	synthWindow.background_(Color.white);
 	synthWindow.decorator_(FlowLayout(synthWindow.bounds, 3@3, 3@3));

	// SynthDef name
 	StaticText(synthWindow, 100@10)
	    .string_(~samplerSynthDef.name)
	    .stringColor_(Color.black)
 	    .align_(\center);
 	synthWindow.decorator.nextLine;

	button = Array.newClear;
	knob = Array.newClear;
	active = Array.newClear;

 	},
	{
 		arguments = 0;
    }
);

arguments.do({
	arg control, i;
	var caseFind;
	caseFind = false;

	case
	{"trigger trig gate t_trig t_gate loop".contains(control.name.asString) }
	{
		"button gui".postln;
		/*button[i] = Button(synthWindow, Rect(10,110,112,35)).states_([["Trig", Color.black, Color.white],["stop", Color.white, Color.grey]]).action = { arg gate; ~sampler.set(control.name.asSymbol, gate.value;) };

		// button midi map
		samplerCcStart = samplerCcStart + 1;
		MIDIFunc.cc({ arg val, num, chan, src;
			var midiControl;
			midiControl = val.linlin(0, 127, 0, 1);
			{ button[i].valueAction_(midiControl); }.defer;
		}, samplerCcStart, 0);
		(samplerCcStart).debug("sampler" ++ control.name.asString ++ " cc number");*/
		caseFind = true;
	}
	{caseFind.not}
	{
		"knob gui".postln;
		/*active[i] = false;
		knob[i] = EZKnob(synthWindow, 35@70, control.name.asString, ControlSpec(0, 1, step: 0.01, default: control.defaultValue), { arg control; ~sampler.set(control.name.asSymbol, control.value); active[i] = false; });

		samplerCcStart = samplerCcStart + 1;
		MIDIFunc.cc({ arg val, num, chan, src;
			var guiControl, midiControl, treshold;
			midiControl = val.linlin(0, 127, 0, 1);
			guiControl = knob[i].value;
			treshold = 0.1;
			if ( // soft takeover
				(active[i] or: ((midiControl > (guiControl - treshold)) and: (midiControl < (guiControl + treshold)))),
				{
					active[i] = true;
					{
						~sampler.set(control.name.asSymbol, midiControl);
						knob[i].value_(midiControl);
					}.defer;
				}
			);
		}, samplerCcStart, 0);
		(samplerCcStart).debug("sampler" ++ control.name.asString ++ " cc number");*/
	};
});

)