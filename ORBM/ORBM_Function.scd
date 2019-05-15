(

///////////////////////////////////////  Function

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

~swingify = Prout({ |ev| // use it with a Pchain in a Pind to add swing
    var now, nextTime = 0, thisShouldSwing, nextShouldSwing = false, adjust;
    while { ev.notNil } {
        // current time is what was "next" last time
        now = nextTime;
        nextTime = now + ev.delta;
        thisShouldSwing = nextShouldSwing;
        nextShouldSwing = ((nextTime absdif: nextTime.round(ev[\swingBase])) <= (ev[\swingThreshold] ? 0)) and: {
            (nextTime / ev[\swingBase]).round.asInteger.odd
        };
        adjust = ev[\swingBase] * ev[\swingAmount];
        // an odd number here means we're on an off-beat
        if(thisShouldSwing) {
            ev[\timingOffset] = (ev[\timingOffset] ? 0) + adjust;
            // if next note will not swing, this note needs to be shortened
            if(nextShouldSwing.not) {
                ev[\sustain] = ev.use { ~sustain.value } - adjust;
            };
        } {
            // if next note will swing, this note needs to be lengthened
            if(nextShouldSwing) {
                ev[\sustain] = ev.use { ~sustain.value } + adjust;
            };
        };
        ev = ev.yield;
    };
});

~cleanup = {
	currentEnvironment.removeAll;
	Buffer.freeAll;
	Window.closeAll;
	s.newBusAllocators;
	s.freeAll;
};

~removePrevView = { arg synthWindow, synthWindowKey;
	var synthView;
	if (synthWindow.includesKey(synthWindowKey), {
		synthView = synthWindow.at(synthWindowKey);
		synthView.removeAll; // removes all children
		synthView.remove; // remove the composite view
	});
};

// persist Pdef mute state at pattern change
~changePattern = { arg pdef, pattern;
	var pdefNameSymbol, pdefNameString;
	pdefNameSymbol = pdef.key;
	pdefNameString = pdefNameSymbol.asString;

	if (~activePdefMute.at(pdefNameString), {
		Pdef(pdefNameSymbol, pattern).quant_(1);
		Pbindef(pdefNameSymbol, \type, \rest).quant_(~globalQant);
	}, {
		Pdef(pdefNameSymbol, pattern).quant_(1);
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
~autoGui = { arg parentWindow = nil, synthDef = nil, instance = nil, ccStart = 10, backGroundColor = Color.white, specDict = Dictionary.new;
	var arguments, synthWindow, list, slider, button, knob, active, synthDefName, pdefName;

	if ((parentWindow.notNil and: synthDef.notNil and: instance.notNil), {
		synthDefName = synthDef.name.asString;
		arguments = synthDef.allControlNames;
		specDict.put("default", ["knob", ControlSpec(0, 1, step: 0.01, default: 0), true]);

		if (instance.isSymbol, {
			pdefName = instance.asString;
		}, {
			pdefName = "";
			if (instance.isString, {
				instance = instance.asSymbol;
			});
		});

		~synthWindow.put(synthDefName ++ pdefName,
			CompositeView(bounds: (arguments.size * 62)@110)
			.scroll(autoScrolls: true)
			.minHeight_(115)
			.minWidth_(230)
			.background_(backGroundColor);
		);
		synthWindow = ~synthWindow.at(synthDefName ++ pdefName);

		synthWindow.decorator_(FlowLayout(synthWindow.bounds, 3@3, 6@3));

		// SynthDef name
		StaticText(synthWindow, 100@26)
		.string_(synthDefName ++ " " ++ pdefName)
		.stringColor_(Color.black)
		.align_(\center);
		synthWindow.decorator.nextLine;

		list = Dictionary.new;
		slider = Dictionary.new;
		button = Dictionary.new;
		knob = Dictionary.new;
		active = Dictionary.new;

		arguments.do({
			arg control, i;
			var caseFind, controlName, controlNameSymb, controlType, controlSpec, midiMap;
			caseFind = false;
			controlName = control.name.asString;
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
			{ controlType == "none" or: "out in input output doneaction".contains(controlName.toLower) }
			{
				caseFind = true;
			}
			{ controlType == "list" and: caseFind.not }
			{
				// list creation
				active.put(("list" ++ i ++ "Active").asString, false);
				list.put(("list" ++ i).asString, EZListView(synthWindow, 60@70, controlName, controlSpec, { arg guiControl; if (instance.isSymbol, { Pbindef(instance, controlNameSymb, guiControl.value).quant_(~globalQant); }, { instance.set(controlNameSymb, guiControl.value); }); active.put(("list" ++ i ++ "Active").asString, false); }));

				if (midiMap, { // list midi map
					MIDIFunc.cc({ arg val, num, chan, src;
						var guiControl, midiControl, threshold;
						threshold = 0.5;
						midiControl = val.linlin(0, 127, 0, list.at(("list" ++ i).asString).items.size - 1);
						{
							guiControl = list.at(("list" ++ i).asString).value;
							if ( // soft takeover
								(active.at(("list" ++ i ++ "Active").asString) or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
								{
									active.put(("list" ++ i ++ "Active").asString, true);
									if (instance.isSymbol, { Pbindef(instance, controlNameSymb, midiControl).quant_(~globalQant); }, { instance.set(controlNameSymb, midiControl); });
									list.at(("list" ++ i).asString).value_(midiControl);
								}
							);
						}.defer;
					}, ccStart, 0);
					(ccStart).debug(synthDefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});

				caseFind = true;
			}
			{ controlType == "slider" and: caseFind.not }
			{
				// slider creation
				active.put(("slider" ++ i ++ "Active").asString, false);
				slider.put(("slider" ++ i).asString, EZSlider(synthWindow, 60@70, controlName, controlSpec, { arg guiControl; if (instance.isSymbol, { Pbindef(instance, controlNameSymb, guiControl.value).quant_(~globalQant); }, { instance.set(controlNameSymb, guiControl.value); }); active.put(("slider" ++ i ++ "Active").asString, false); }, layout: \vert, gap: 6@6));

				if (midiMap, { // slider midi map
					MIDIFunc.cc({ arg val, num, chan, src;
						var guiControl, midiControl, threshold, minValue, maxValue;
						minValue = slider.at(("slider" ++ i).asString).controlSpec.minval;
						maxValue = slider.at(("slider" ++ i).asString).controlSpec.maxval;
						threshold = ((maxValue - minValue) * 5) / 100; // 5% of the range
						midiControl = val.linlin(0, 127, minValue, maxValue);
						guiControl = slider.at(("slider" ++ i).asString).value;
						if ( // soft takeover
							(active.at(("slider" ++ i ++ "Active").asString) or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
							{
								active.put(("slider" ++ i ++ "Active").asString, true);
								{
									if (instance.isSymbol, { Pbindef(instance, controlNameSymb, midiControl).quant_(~globalQant); }, { instance.set(controlNameSymb, midiControl); });
									slider.at(("slider" ++ i).asString).value_(midiControl);
								}.defer;
							}
						);
					}, ccStart, 0);
					(ccStart).debug(synthDefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});

				caseFind = true;
			}
			{ /*"trigger trig gate t_trig t_gate loop mute start stop on off".contains(controlName) or: */controlType == "button" and: caseFind.not } // in this case create button
			{
				// button creation
				button.put(("button" ++ i).asString, Button(synthWindow, Rect(10,110,40,25)).states_([[controlName, Color.black, Color.white],["stop", Color.white, Color.grey]]).action = { arg guiControl; if (instance.isSymbol, { Pbindef(instance, controlNameSymb, guiControl.value).quant_(~globalQant); }, { instance.set(controlNameSymb, guiControl.value); }); });

				if (midiMap, { // button midi map
					MIDIFunc.cc({ arg val, num, chan, src;
						var midiControl;
						midiControl = val.linlin(0, 127, 0, 1);
						{
							button.at(("button" ++ i).asString).valueAction_(midiControl);
						}.defer;
					}, ccStart, 0);
					(ccStart).debug(synthDefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});

				caseFind = true;
			}
			{  controlType == "knob" or: caseFind.not } // default case create knob
			{
				// knob creation
				active.put(("knob" ++ i ++ "Active").asString, false);
				knob.put(("knob" ++ i).asString, EZKnob(synthWindow, 60@70, controlName, controlSpec, { arg guiControl; if (instance.isSymbol, { Pbindef(instance, controlNameSymb, guiControl.value).quant_(~globalQant); }, { instance.set(controlNameSymb, guiControl.value); }); active.put(("knob" ++ i ++ "Active").asString, false); }));

				if (midiMap, { // knob midi map
					MIDIFunc.cc({ arg val, num, chan, src;
						var guiControl, midiControl, threshold, minValue, maxValue;
						minValue = knob.at(("knob" ++ i).asString).controlSpec.minval;
						maxValue = knob.at(("knob" ++ i).asString).controlSpec.maxval;
						threshold = ((maxValue - minValue) * 5) / 100; // 5% of the range
						midiControl = val.linlin(0, 127, minValue, maxValue);
						guiControl = knob.at(("knob" ++ i).asString).value;
						if ( // soft takeover
							(active.at(("knob" ++ i ++ "Active").asString) or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
							{
								active.put(("knob" ++ i ++ "Active").asString, true);
								{
									if (instance.isSymbol, { Pbindef(instance, controlNameSymb, midiControl).quant_(~globalQant); }, { instance.set(controlNameSymb, midiControl); });
									knob.at(("knob" ++ i).asString).value_(midiControl);
								}.defer;
							}
						);
					}, ccStart, 0);
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