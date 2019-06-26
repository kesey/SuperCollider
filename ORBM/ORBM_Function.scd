(

///////////////////////////////////////  Function

// call on server boot
~makeBuffers = { // create a dictionary with folders names under the Audio folder in the first key and sample number in the next key
	b = Dictionary.new;
	PathName(~path ++ "Audio").entries.do{
		arg subfolder;
		b.add(
			subfolder.folderName.asSymbol ->
			Array.fill(
				subfolder.entries.size,
				{
					arg i;
					Buffer.read(s, subfolder.entries[i].fullPath);
				}
			)
		);
	};
};
// b[\Bowed_Empty_Sweep_Slow][0].play; // use it in a SynthDef like this: s.bind { Synth(\sampler, [\out, 0, \buffer, b[\Bowed_Empty_Sweep_Slow][0].bufnum]) };

// call on server quit
~cleanup = { arg server;
	Window.closeAll;
	Buffer.freeAll;
	currentEnvironment.removeAll;
	Pdef.removeAll;
	Tdef.removeAll;
	server.newBusAllocators;
	server.freeAll;
};

// return an Array of Penvir use it in Ppar to play all the units
~listUnits = { arg sequencer;
	var listUnits;
	listUnits = sequencer.size.collect({
		arg i;
		sequencer.at(("unit" ++ (i + 1)).asSymbol);
	});
	listUnits;
};

// remove previous Pdef, use it when you reset sequencer
~resetPdefView = {
	~synthWindow.keysValuesDo({
		arg key, value;
		if(key.contains("unit"), {
			value.removeAll;
			value.remove;
			{ ~synthWindow.removeAt(key); }.fork(t, 0.2); // need to be delayed
		});
	});
};

~removePrevView = { arg synthWindow, synthWindowKey; // use it inside a defer function
	var synthView;
	if (synthWindow.includesKey(synthWindowKey), {
		synthView = synthWindow.at(synthWindowKey);
		synthView.removeAll; // removes all children
		synthView.remove; // remove the composite view
		~autoGuiControl.keysValuesDo({ // remove controls no longer in use
			arg key;
			if(key.contains(synthWindowKey), {
				~autoGuiControl.removeAt(key);
			});
		});
	});
};

// persist Pdef mute state at pattern change and check pattern type
~changePattern = { arg pdef, pattern;
	var pdefNameSymbol, pdefNameString, type;
	pdefNameSymbol = pdef.key.asSymbol;
	pdefNameString = pdefNameSymbol.asString;
	type = pattern.patternpairs.asEvent.at(\type);
	if (type.isNil, {
		type = \note;
	});
	~patternType.put(pdefNameString, type);

	if (~activePdefMute.at(pdefNameString), {
		Pdef(pdefNameSymbol, pattern).quant_(~sequenceQuant);
		Pbindef(pdefNameSymbol, \type, \rest).quant_(~sequenceQuant / 2);
	}, {
		Pdef(pdefNameSymbol, pattern).quant_(~sequenceQuant);
	});
};

// use it with SynthDef sync on a clock like sync delay
~updateTempo = { arg synth, tempoClock;
	var updater;
	updater = SimpleController(tempoClock).put(\tempo, {
		synth.set(\tempoClock, tempoClock.tempo);
	})
	// clean up garbage when the clock is stopped
	.put(\stop, { updater.remove; });
};

// automatic GUI creation and midi mapping
~autoGui = { arg parentWindow = nil, synthDef = nil, instance = nil, ccStart = 10, midiChan = 0, backGroundColor = Color.white, specDict = Dictionary.new;
	var arguments, synthWindow, list, slider, button, knob, active, synthDefName, pdefName, id;

	if ((parentWindow.notNil and: synthDef.notNil and: instance.notNil), {
		synthDefName = synthDef.name.asString;
		arguments = synthDef.allControlNames;
		midiChan = midiChan.max(0).min(15);

		specDict.put("default", ["knob", ControlSpec(0, 1, step: 0.01, default: 0), true]);

		if (instance.isSymbol, {
			pdefName = instance.asString;
		}, {
			pdefName = UniqueID.next;
			if (instance.isString, {
				pdefName = instance;
				instance = instance.asSymbol;
			});
		});

		id = (synthDefName ++ pdefName).asString;
		(midiChan).debug(synthDefName ++ " " ++ pdefName ++ " midi channel");

		~synthWindow.put(id,
			CompositeView(bounds: (arguments.size * 63)@110)
			.scroll(autoScrolls: true)
			.minHeight_(115)
			.minWidth_(230)
			.background_(backGroundColor);
		);
		synthWindow = ~synthWindow.at(id);

		synthWindow.decorator_(FlowLayout(synthWindow.bounds, 3@3, 6@3));

		// SynthDef name
		StaticText(synthWindow, 100@26)
		.string_(synthDefName ++ " " ++ pdefName)
		.stringColor_(Color.black)
		.align_(\center);
		synthWindow.decorator.nextLine;

		active = Dictionary.new;

		arguments.do({
			arg control, i;
			var caseFind, controlName, controlNameSymb, controlType, controlSpec, midiMap, controlId;
			caseFind = false;
			controlName = control.name.asString;
			controlId = (id ++ controlName).asString;
			controlNameSymb = control.name.asSymbol;

			if (control.defaultValue.notNil, {
				specDict.add("default" -> ["knob", ControlSpec(0, 1, step: 0.01, default: control.defaultValue), true]);
			});

			if (specDict.includesKey(controlName),
				{
					controlType = specDict.at(controlName)[0].value.asString.toLower;
					if (specDict.at(controlName)[1].notNil, { controlSpec = specDict.at(controlName)[1].value; });
					if (specDict.at(controlName)[2].notNil, { midiMap = specDict.at(controlName)[2].value; });
				},
				{
					controlType = specDict.at("default")[0].value.asString.toLower;
					controlSpec = specDict.at("default")[1].value;
					midiMap = specDict.at("default")[2].value;
				}
			);

			case
			{ controlType == "none" or: "out in input output inbus outbus doneaction".contains(controlName.toLower) }
			{
				caseFind = true;
			}
			{ controlType == "list" and: caseFind.not }
			{
				// list creation
				active.put(controlId, false);
				~autoGuiControl.put(controlId, EZListView(synthWindow, 60@70, controlName, controlSpec, {
					arg guiControl;
					if (instance.isSymbol,
						{ Pbindef(instance, controlNameSymb, guiControl.value).quant_(~globalQuant); },
						{ { instance.set(controlNameSymb, guiControl.value); }.fork(t, ~globalQuant); }
					);
					active.put(controlId, false);
				}));

				if (midiMap, { // list midi map
					MIDIFunc.cc({ arg val, num, chan, src;
						var guiControl, midiControl, threshold;
						threshold = 0.5;
						midiControl = val.linlin(0, 127, 0, list.at(("list" ++ i).asString).items.size - 1);
						{
							guiControl = ~autoGuiControl.at(controlId).value;
							if ( // soft takeover
								(active.at(controlId) or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
								{
									active.put(controlId, true);
									if (instance.isSymbol,
										{ Pbindef(instance, controlNameSymb, midiControl).quant_(~globalQuant); },
										{ { instance.set(controlNameSymb, midiControl); }.fork(t, ~globalQuant); }
									);
									~autoGuiControl.at(controlId).value_(midiControl);
								}
							);
						}.defer;
					}, ccStart, midiChan);
					(ccStart).debug(synthDefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});

				caseFind = true;
			}
			{ controlType == "slider" and: caseFind.not }
			{
				// slider creation
				active.put(controlId, false);
				~autoGuiControl.put(controlId, EZSlider(synthWindow, 60@70, controlName, controlSpec, {
					arg guiControl;
					if (instance.isSymbol,
						{ Pbindef(instance, controlNameSymb, guiControl.value).quant_(~globalQuant); },
						{ { instance.set(controlNameSymb, guiControl.value); }.fork(t, ~globalQuant); }
					);
					active.put(controlId, false);
				}, layout: \vert, gap: 6@6));

				if (midiMap, { // slider midi map
					MIDIFunc.cc({ arg val, num, chan, src;
						var guiControl, midiControl, threshold, minValue, maxValue;
						minValue = ~autoGuiControl.at(controlId).controlSpec.minval;
						maxValue = ~autoGuiControl.at(controlId).controlSpec.maxval;
						threshold = ((maxValue - minValue) * 5) / 100; // 5% of the range
						midiControl = val.linlin(0, 127, minValue, maxValue);
						guiControl = ~autoGuiControl.at(controlId).value;
						if ( // soft takeover
							(active.at(controlId) or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
							{
								active.put(controlId, true);
								{
									if (instance.isSymbol,
										{ Pbindef(instance, controlNameSymb, midiControl).quant_(~globalQuant); },
										{ { instance.set(controlNameSymb, midiControl); }.fork(t, ~globalQuant); }
									);
									~autoGuiControl.at(controlId).value_(midiControl);
								}.defer;
							}
						);
					}, ccStart, midiChan);
					(ccStart).debug(synthDefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});

				caseFind = true;
			}
			{ /*"trigger trig gate t_trig t_gate loop mute start stop on off".contains(controlName) or: */controlType == "button" and: caseFind.not } // in this case create button
			{
				// button creation
				~autoGuiControl.put(controlId,
					Button(synthWindow, Rect(10,110,60,25))
					.states_([
						[controlName ++ " on", Color.black, Color.white],
						[controlName ++ " off", Color.white, Color.grey]
					])
					.action = {
						arg guiControl;
						if (instance.isSymbol,
							{ Pbindef(instance, controlNameSymb, guiControl.value).quant_(~globalQuant); },
							{ instance.set(controlNameSymb, guiControl.value); }
						);
					}
				);

				if (midiMap, { // button midi map
					MIDIFunc.cc({ arg val, num, chan, src;
						var midiControl;
						midiControl = val.linlin(0, 127, 0, 1);
						{
							~autoGuiControl.at(controlId).valueAction_(midiControl);
						}.defer;
					}, ccStart, midiChan);
					(ccStart).debug(synthDefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});

				caseFind = true;
			}
			{  controlType == "knob" or: caseFind.not } // default case create knob
			{
				// knob creation
				active.put(controlId, false);
				~autoGuiControl.put(controlId, EZKnob(synthWindow, 60@70, controlName, controlSpec, {
					arg guiControl;
					if (instance.isSymbol,
						{ Pbindef(instance, controlNameSymb, guiControl.value).quant_(~globalQuant); },
						{ { instance.set(controlNameSymb, guiControl.value); }.fork(t, ~globalQuant); }
					);
					active.put(controlId, false);
				}));

				if (midiMap, { // knob midi map
					MIDIFunc.cc({ arg val, num, chan, src;
						var guiControl, midiControl, threshold, minValue, maxValue;
						minValue = ~autoGuiControl.at(controlId).controlSpec.minval;
						maxValue = ~autoGuiControl.at(controlId).controlSpec.maxval;
						threshold = ((maxValue - minValue) * 5) / 100; // 5% of the range
						midiControl = val.linlin(0, 127, minValue, maxValue);
						guiControl = ~autoGuiControl.at(controlId).value;
						if ( // soft takeover
							(active.at(controlId) or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
							{
								active.put(controlId, true);
								{
									if (instance.isSymbol,
										{ Pbindef(instance, controlNameSymb, midiControl).quant_(~globalQuant); },
										{ { instance.set(controlNameSymb, midiControl); }.fork(t, ~globalQuant); }
									);
									~autoGuiControl.at(controlId).value_(midiControl);
								}.defer;
							}
						);
					}, ccStart, midiChan);
					(ccStart).debug(synthDefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});
			};
		});

		parentWindow.canvas.layout.insert(synthWindow);

		if (instance.isSymbol, {
			// removes all the children of the view and destroys them then remove the composite view
			Button(synthWindow, Rect(10,110,20,20)).states_([["X", Color.white, Color.red]]).action = { synthWindow.removeAll; synthWindow.remove; };
		});
	}, {
		"autoGui wrong arguments".postln;
	});
};

)