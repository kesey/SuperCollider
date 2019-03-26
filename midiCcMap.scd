(
MIDIClient.init; // post a list of available devices

// MIDIClient.sources; // list avalaible midi sources
// MIDIIn.connectAll; // connect to all attached input sources
MIDIIn.connect(0, MIDIClient.sources[0]); // connect on first port with first device equivalent to MIDIIn.connect

// MIDIClient.destinations; // list avalaible midi destinations
~midiOut = MIDIOut.new(2).latency_(s.latency);

~samplerStereoSynthDef = SynthDef(\samplerStereo,{ arg out = 0, buffer = 0, rate = 1, startPos = 0, loop = 0, attack = 0.001, release = 1, pan = 0, amp = 1, gate = 1;
	var sig, env;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), gate, gate);
	sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate, gate, BufFrames.ir(buffer)*startPos, loop) * env;
	sig = Balance2.ar(sig[0], sig[1], pan, amp);
	Out.ar(out, sig);
}).add;
)

(
var knob, button, activeKnob;
b = Buffer.read(s, "/Users/Fabien/SuperCollider/ORBM/Audio/Bowed_Empty_Sweep_Slow/waterharp_fx_empty_sweep_slow_01.wav");

~samplerStereo = Synth(\samplerStereo, [\buffer, b.bufnum, \gate, 0]);

~ccStart = 21; // start mapping midi cc from here
~ccStart = ~ccStart.max(0).min(127); // limit ccStart

~ccStart = ~ccStart - 1;

w = Window("GUI_TEST",Rect(0, 0, 250, 225), scroll: true);
w.front;
//w.alwaysOnTop_(true);
w.view.decorator = FlowLayout(w.view.bounds, 3@3, 3@3);

~midiCcMap = { arg ccNum = 0, guiControl = nil, active = false, threshold = 0.1, instance = nil, parameter = "amp", min = 0, max = 1;

	if ((instance.notNil and: guiControl.notNil), {
		MIDIFunc.cc({ arg val, num, chan, src;
			var guiValue, midiControl, caseFind;
			caseFind = false;

			midiControl = val.linlin(0, 127, min, max);
			{ guiValue = guiControl.value;
				active.debug("active"); // This fuck the whole thing

				if ( // soft takeover
					(active or: ((midiControl > (guiValue - threshold)) and: (midiControl < (guiValue + threshold)))),
					{
						active = true;
						/*{
							instance.set(parameter.asSymbol, midiControl);
							guiControl.value_(midiControl);
						}.defer;*/
						case
						{ guiControl.asString.contains("EZKnob") and: caseFind.not }
						{
							{
								instance.set(parameter.asSymbol, midiControl);
								guiControl.value_(midiControl);
							}.defer;
							caseFind = true;
						}
						{ guiControl.asString.contains("Button") and: caseFind.not }
						{
						    {
								guiControl.valueAction_(midiControl);
							}.defer;
							caseFind = true;
						};
					}
				);
			}.defer;
		}, ccNum, 0);
		(ccNum).debug(instance.defName.asString ++ " " ++ parameter ++ " cc number");
	}, {
		"midiCcMap wrong arguments".postln;
	});

};

///////////////////////////////// Button

button = Button(w, Rect(10,110,112,35)).states_([["Gate", Color.black, Color.white],["Stop", Color.white, Color.grey]]).action = { arg guiControl; ~samplerStereo.set(\gate, guiControl.value/*.linlin(0, 1, 1, 0)*/); };

// midi map
~midiCcMap.value(~ccStart, button, true, 0.1, ~samplerStereo, "gate", 0, 1);

///////////////////////////////// Knob

activeKnob = false;
	knob = EZKnob(w, 112@70, 'knobTest', ControlSpec(-6, 6, step: 0.1, default: 1, units: 'hz'), { arg guiControl; ~samplerStereo.set(\rate, guiControl.value); activeKnob = false; }, margin: 39@0);

~ccStart = ~ccStart + 1;
~midiCcMap.value(~ccStart, knob, activeKnob, 500, ~samplerStereo, "rate", -6, 6);

)