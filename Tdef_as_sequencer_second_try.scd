s.boot;

(
// init
~globalQuant = 4;
~pdefNumber = 8; // number of pdef or units

~synthWindow = Dictionary.new;
~patternType = Dictionary.new;
~sequencer = Dictionary.new;
~firstTime = Dictionary.new;
~controlBus = Dictionary.new;
~autoGuiControl = Dictionary.new;
~active = Dictionary.new;

~path = PathName(thisProcess.nowExecutingPath).parentPath;

t = TempoClock.default;
t.tempo = 60 / 60;

// Function
// return an Array of Penvir use it in Ppar to play all the units
~listUnits = { arg sequencer;
	var listUnits;
	listUnits = sequencer.size.collect({ arg i;
		sequencer.at(("unit" ++ (i + 1)).asSymbol);
	});
	listUnits;
};

// remove previous Pdef, use it when you reset sequencer
~resetPdefView = {
	~synthWindow.keysValuesDo({ arg key, value;
		if(key.contains("unit"), {
			value.removeAll;
			value.remove;
			{ ~synthWindow.removeAt(key); }.fork(t, 0.2); // need to be delayed
		});
	});
};

~cleanDict = { arg dict, synthWindowKey;
	dict.keysDo({ arg key; // remove control no longer in use
		if(key.contains(synthWindowKey), {
			dict.removeAt(key);
		});
	});
};

~removePrev = { arg synthWindowKey; // use it inside a defer function
	var synthView;
	if (~synthWindow.includesKey(synthWindowKey), {
		synthView = ~synthWindow.at(synthWindowKey);
		synthView.removeAll; // removes all children
		synthView.remove; // remove the composite view
		{ ~synthWindow.removeAt(synthWindowKey); }.fork(t, 0.2);

		~cleanDict.value(~autoGuiControl, synthWindowKey);
		~cleanDict.value(~active, synthWindowKey);
		~cleanDict.value(~firstTime, synthWindowKey);

		~controlBus.keysDo({ arg key; // remove control bus no longer in use
			if(key.contains(synthWindowKey), {
				~controlBus.at(key).free;
				~controlBus.removeAt(key);
			});
		});

		MIDIdef.all.keysDo({ arg key; // remove mididef no longer in use
			if(key.contains(synthWindowKey), {
				MIDIdef(key).free;
			});
		});
	});
};

~makeBuffers = { // create a dictionary with folders names under the Audio folder in the first key and sample number in the next key
	b = Dictionary.new;
	PathName(~path ++ "ORBM/Audio").entries.do{ arg subfolder;
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

~makeBuffers.value;

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

	~firstTime.keysDo({ arg key; // reset control bus creation
		if(key.contains(pdefNameString), {
			~firstTime.put(key, true);
		});
	});

	Pdef(pdefNameSymbol, pattern).quant_(~globalQuant);
	/*if (~activePdefMute.at(pdefNameString), {
		Pbindef(pdefNameSymbol, \type, \rest).quant_(~globalQuant);
	}, {*/
		Pbindef(pdefNameSymbol, \type, type).quant_(~globalQuant);
	//});
};

~pdefUpdate = { arg controlId, instance, controlNameSymb, value;
	if (~firstTime.at(controlId), {
		~controlBus.put(controlId, Bus.control(s, 1).set(value));
		Pbindef(instance, controlNameSymb, ~controlBus.at(controlId).asMap).quant_(~globalQuant);
		~firstTime.put(controlId, false);
	}, {
		~controlBus.at(controlId).set(value);
	});
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
			CompositeView(bounds: (arguments.size * 64)@110)
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

		arguments.do({ arg control, i;
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
				~active.put(controlId, false);
				~firstTime.put(controlId, true);
				~autoGuiControl.put(controlId, EZListView(synthWindow, 60@70, controlName, controlSpec, {
					arg guiControl;
					if (instance.isSymbol,
						{ ~pdefUpdate.value(controlId, instance, controlNameSymb, guiControl.value); },
						{ instance.set(controlNameSymb, guiControl.value); }
					);
					~active.put(controlId, false);
				}));

				if (midiMap, { // list midi map
					MIDIdef.cc(controlId, { arg val, num, chan, src;
						var guiControl, midiControl, threshold;
						threshold = 0.5;
						midiControl = val.linlin(0, 127, 0, ~autoGuiControl.at(controlId).items.size - 1);
						{
							guiControl = ~autoGuiControl.at(controlId).value;
							if ( // soft takeover
								(~active.at(controlId) or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
								{
									~active.put(controlId, true);
									if (instance.isSymbol,
										{ ~pdefUpdate.value(controlId, instance, controlNameSymb, midiControl); },
										{ instance.set(controlNameSymb, midiControl); }
									);
									~autoGuiControl.at(controlId).value_(midiControl);
								}
							);
						}.defer;
					}, ccStart, midiChan);
					(ccStart).debug(synthDefName ++ " " ++ pdefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});

				caseFind = true;
			}
			{ controlType == "slider" and: caseFind.not }
			{
				// slider creation
				~active.put(controlId, false);
				~firstTime.put(controlId, true);
				~autoGuiControl.put(controlId, EZSlider(synthWindow, 60@70, controlName, controlSpec, {
					arg guiControl;
					if (instance.isSymbol,
						{ ~pdefUpdate.value(controlId, instance, controlNameSymb, guiControl.value); },
						{ instance.set(controlNameSymb, guiControl.value); }
					);
					~active.put(controlId, false);
				}, layout: \vert, gap: 6@6));

				if (midiMap, { // slider midi map
					MIDIdef.cc(controlId, { arg val, num, chan, src;
						var guiControl, midiControl, threshold, minValue, maxValue;
						minValue = ~autoGuiControl.at(controlId).controlSpec.minval;
						maxValue = ~autoGuiControl.at(controlId).controlSpec.maxval;
						threshold = ((maxValue - minValue) * 5) / 100; // 5% of the range
						midiControl = val.linlin(0, 127, minValue, maxValue);
						guiControl = ~autoGuiControl.at(controlId).value;
						if ( // soft takeover
							(~active.at(controlId) or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
							{
								~active.put(controlId, true);
								{
									if (instance.isSymbol,
										{ ~pdefUpdate.value(controlId, instance, controlNameSymb, midiControl); },
										{ instance.set(controlNameSymb, midiControl); }
									);
									~autoGuiControl.at(controlId).value_(midiControl);
								}.defer;
							}
						);
					}, ccStart, midiChan);
					(ccStart).debug(synthDefName ++ " " ++ pdefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});

				caseFind = true;
			}
			{ /*"trigger trig gate t_trig t_gate loop mute start stop on off".contains(controlName) or: */controlType == "button" and: caseFind.not } // in this case create button
			{
				// button creation
				~firstTime.put(controlId, true);
				~autoGuiControl.put(controlId,
					Button(synthWindow, Rect(10,110,60,25))
					.states_([
						[controlName ++ " on", Color.black, Color.white],
						[controlName ++ " off", Color.white, Color.grey]
					])
					.action = {
						arg guiControl;
						if (instance.isSymbol,
							{ ~pdefUpdate.value(controlId, instance, controlNameSymb, guiControl.value); },
							{ instance.set(controlNameSymb, guiControl.value); }
						);
					}
				);

				if (midiMap, { // button midi map
					MIDIdef.cc(controlId, { arg val, num, chan, src;
						var midiControl;
						midiControl = val.linlin(0, 127, 0, 1);
						{
							~autoGuiControl.at(controlId).valueAction_(midiControl);
						}.defer;
					}, ccStart, midiChan);
					(ccStart).debug(synthDefName ++ " " ++ pdefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});

				caseFind = true;
			}
			{  controlType == "knob" or: caseFind.not } // default case create knob
			{
				// knob creation
				~active.put(controlId, false);
				~firstTime.put(controlId, true);
				~autoGuiControl.put(controlId, EZKnob(synthWindow, 60@70, controlName, controlSpec, {
					arg guiControl;
					if (instance.isSymbol,
						{ ~pdefUpdate.value(controlId, instance, controlNameSymb, guiControl.value); },
						{ instance.set(controlNameSymb, guiControl.value); }
					);
					~active.put(controlId, false);
				}));

				if (midiMap, { // knob midi map
					MIDIdef.cc(controlId, { arg val, num, chan, src;
						var guiControl, midiControl, threshold, minValue, maxValue;
						minValue = ~autoGuiControl.at(controlId).controlSpec.minval;
						maxValue = ~autoGuiControl.at(controlId).controlSpec.maxval;
						threshold = ((maxValue - minValue) * 5) / 100; // 5% of the range
						midiControl = val.linlin(0, 127, minValue, maxValue);
						guiControl = ~autoGuiControl.at(controlId).value;
						if ( // soft takeover
							(~active.at(controlId) or: ((midiControl > (guiControl - threshold)) and: (midiControl < (guiControl + threshold)))),
							{
								~active.put(controlId, true);
								{
									if (instance.isSymbol,
										{ ~pdefUpdate.value(controlId, instance, controlNameSymb, midiControl); },
										{ instance.set(controlNameSymb, midiControl); }
									);
									~autoGuiControl.at(controlId).value_(midiControl);
								}.defer;
							}
						);
					}, ccStart, midiChan);
					(ccStart).debug(synthDefName ++ " " ++ pdefName ++ " " ++ controlName ++ " cc number");
					ccStart = ccStart + 1;
				});
			};
		});

		parentWindow.canvas.layout.insert(synthWindow);

		if (instance.isSymbol, {
			// removes all the children of the view and destroys them then remove the composite view
			Button(synthWindow, Rect(10,110,20,20)).states_([["X", Color.white, Color.new255(255, 48, 48)]]).action = {
				~removePrev.value(id);
			};
		});
	}, {
		"autoGui wrong arguments".postln;
	});
};

// Synthdef
~kick808SynthDef = SynthDef(\kick808,{arg out = 0, amp = 0.5,  pan = 0, tu = 1, t_trig = 1, envL1 = 0, envL2 = 1, envL3 = 0, envT1 = 0, envT2 = 1, enfL1 = 1000, enfL2 = 20, enfL3 = 20, enfT1 = 0.001, enfT2 = 0.001, enfT3 = 0.001;
	var env = EnvGen.ar(Env([envL1,envL2,envL3],[envT1,envT2],-8), t_trig, doneAction:2);
	var enf  = EnvGen.ar(Env([enfL1,enfL2,enfL3],[enfT1,enfT2,enfT3],-4));
	var sig = SinOsc.ar(tu*(enf+40))*env;
	sig = sig + LPF.ar(SinOsc.ar(SinOsc.ar(100,0,50,100*tu),0,0.2)*env,1000);
	OffsetOut.ar(out, Pan2.ar(sig * env, pan, amp));
}).add;

~hatnewSynthDef = SynthDef(\hatnew, {|out=0, amp=1, pan=0, freq=230, hpf=8500, rel=0.15, fxb=0, fxv=0, bbcb=0, bbcv=0, doneAction = 2|
  var pulse, sig, env, freqs;
  freqs = [freq, freq*1.4471, freq*1.617, freq*1.9265, freq*2.5028, freq*2.6637];
  pulse = Mix.ar(Pulse.ar(freqs, {0.9.rand}!6, mul: 1));
  sig = RHPF.ar(RHPF.ar(pulse, hpf), hpf);
  env = EnvGen.kr(Env.perc(0,rel), doneAction: doneAction);
  sig =  Pan2.ar(sig*env, pan, amp);
  OffsetOut.ar(out,sig);
}).add;

~kickMedSynthDef = SynthDef(\kickmed, { | out = 0, level = 1, pan = 0, noise = 1, done = 2, dc = 1, snd = 18, env0L1 = 1, env0L2 = 1, env0L3 = 1, env0L4 = 1, atkEnv0 = 0.01, decEnv0 = 0.2, relEnv0 = 0.26, fratio = 1.5, env1L1 = 120, env1L2 = 30, env1L3 = 30, env1T1, env1T2, env1T3, env1T4, curve1 = (-4), curve2 = (-2), curve3 = (-4), phase, oamp = 0.1, owhich2 = 0, ochoose = 0|
	var env0,env1,
env1m, son, son2,son3,son4,p2;
	p2 = phase * (-pi);
env0 = Env([env0L1,env0L2,env0L3,env0L4,0],[atkEnv0,decEnv0,relEnv0,0.5],[curve1, curve2, curve3]);
env1 = Env([env1L1,env1L2,env1L3],[env1T1,env1T2,env1T3,env1T4],[curve1, curve2, curve3]);
env0 = EnvGen.ar(env0, doneAction:done);
env1 = EnvGen.ar(env1);
env1m = env1.midicps;
	son = LFSaw.ar(env1m,0,oamp, 1,1.4);
	son2 = SinOsc.ar(env1m, 0, oamp, 1,1.4);
	son3 = LFPulse.ar(env1m,0, oamp, 1,1.4);
	son4 = LFTri.ar(env1m,0, oamp, 1,1.4);
son = SelectX.ar(ochoose,[son,son2,son3,son4]);
son = LeakDC.ar(son,dc,30);
son = son + WhiteNoise.ar(noise);
	son = LPF.ar(son, env1m*fratio.max(0.01), env0);
	son = son + SelectX.ar(owhich2,[ SinOsc.ar(env1m, phase, env0), LFSaw.ar(env1m, phase, env0), LFPulse.ar(env1m, phase, env0), LFTri.ar(env1m, phase, env0)]);
	son = son*level.distort;
	son = Pan2.ar(son, pan);
OffsetOut.ar(out, son*level).tanh;
}).add;

~dStowellSynthDef = SynthDef(\dStowell, { arg out = 0, amp = 1, pan = 0, t_trig = 1, attack = 0.01, release = 2, freq = 6/3, width = 1/5, lpf = 20000, doneAction = 2;
	var sig, env, spec, input;
	spec = `[{exprand(100,1000)}.dup(50)];
	input = Saw.ar(
		LFPulse.kr(freq,0,width).range(3,3000),
		0.0005
	);
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = Klank.ar(spec, input);
	sig = LPF.ar(sig, lpf);
	sig = sig * env;
	OffsetOut.ar(out, Pan2.ar(sig, pan, amp));
}).add;

~kikAwSynthDef = SynthDef(\kikAw, { |out = 0, amp = 1, basefreq = 50, ratio = 7, sweeptime = 0.05, envL1 = 1, envL2 = 0.8, envL3 = 0, envT1 = 0.3, envT2 = 0.15|
    var fcurve = EnvGen.kr(Env([basefreq * ratio, basefreq], [sweeptime], \exp)),
	env = EnvGen.kr(Env([envL1, envL2, envL3], [envT1, envT2], -4), doneAction: 2),
	sig = SinOsc.ar(fcurve, 0.5pi, env).distort * amp;
    OffsetOut.ar(out, sig ! 2)
}).add;

~sdSynthDef = SynthDef(\sd, { | out = 0, amp = 1, att = 0, rel = 0.05, freq = 200, ffreq = 12000 |
	var osc1, osc2, env;
	osc1 = WhiteNoise.ar;
	osc2 = FSinOsc.ar(freq);
	env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	OffsetOut.ar(out, Pan2.ar(LPF.ar(Mix([osc1, osc2]), ffreq), 0, env*amp));
}).add;

~hat808SynthDef = SynthDef(\hat808, { arg out = 0, amp = 0.1, pan = 0, tu = 1, t_gate = 1, attack = 0.01, release = 0.1;
	var sig;
	var env = EnvGen.ar(Env.perc(attack, release),doneAction:2);
	sig = Saw.ar((1..9)*1000.23*env*tu);
	sig = RHPF.ar(sig, \hpf.kr(5700), \rq.kr(0.5));
	sig = sig * (1+EnvGen.ar(Env.perc((-0.1),\rel.kr(0.1),-4),t_gate))*tu;
	sig = Ringz.ar(sig,(10..15)*1000.234,1).mean;
	sig = RHPF.ar(sig, \lpf.kr(2000)*env*tu, \rq.kr(0.5));
	OffsetOut.ar(out, Pan2.ar(sig, pan, amp));
}).add;

~ping_mhSynthDef = SynthDef(\ping_mh,{arg out=0, amp=0.2, pan=0, freq=440, dur=0.1, attack=0.001;
    var sig, freq2;
    freq=freq*rrand(1,1.01);
    freq2=freq*rrand(1,1.01);
	e=EnvGen.ar(Env.perc(attack,dur.max(0.01),curve:-4),doneAction:2);
    sig=SinOsc.ar([freq,freq2],0,amp*e);
    sig=Pan2.ar(sig,pan);
    OffsetOut.ar(out,sig)
}).add;

~tabassSynthDef = SynthDef(\tabass, { arg out = 0, amp = 1, pan = 0, t_trig = 1, attack = 0.01, release = 2, freq = 1, doneAction = 2;
	var sig, env;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = LFTri.ar(freq);
	20.do{
		sig = BAllPass.ar(sig,80,1);
		sig = ((sig+0.02)*LFNoise0.kr(1/2)*6).tanh;
		sig = LeakDC.ar(sig,0.995);
	};
	sig = sig * env;
	OffsetOut.ar(out, Pan2.ar(sig, pan, amp));
}).add;

~noise2newSynthDef = SynthDef(\noise2new,{arg out = 0, amp = 1, att = 0.01, rel = 1, div = 0.2, pan = 0, del1 = 10, del2 = 20;
	var env, sig;
	env =  EnvGen.ar(Env.new([0.1, 1, 0.3, 0], [att, rel], [-4, -2, -4]), doneAction:2);
	sig = CuspN.ar(
        SampleRate.ir/div,
        LFNoise2.kr([4,4],1.5,1.5),
        LFNoise2.kr([0.2,0.2],1.5,1.5),
        LFNoise2.kr([2,2],0.5,1.5),
        LFNoise2.kr([2,2],0.5,1.5);
    );
    sig = HPF.ar(sig,1000);
    sig = Limiter.ar(sig,0.4);
    sig = [DelayL.ar(sig,0.1,del1/44100) ,DelayL.ar(sig,0.1,del2/44100)];
    //sig = PitchShift.ar(sig,0.2,1*a);
    sig = Compander.ar(sig,In.ar(0,1),0.01,1,0.01,0.01,0.1);
    sig = sig.tanh;
	sig = Pan2.ar(sig, pan, amp);
    OffsetOut.ar(out, sig * env);
}).add;

~sinBassSynthDef = SynthDef(\sinBass, { arg out = 0, gate = 1, amp = 1, pan = 0, curve = 0, loopNode = nil, attack = 0.2, release = 4, envLevel1 = 0, envLevel2 = 40, envLevel3 = 32, envLevel4 = 50, envLevel5 = 0, envLevel6 = 60, envTime1 = 0.5, envTime2 = 0.3, envTime3 = 0.25, envTime4 = 1, envTime5 = 0.5, doneAction = 2;
	var freqEnv, env, sig;
	freqEnv = EnvGen.kr(Env([envLevel1, envLevel2, envLevel3, envLevel4, envLevel5, envLevel6], [envTime1, envTime2, envTime3, envTime4, envTime5], curve), gate);
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), gate, doneAction: doneAction);
	sig = HPF.ar(SinOsc.ar(freqEnv, mul: env), 20);
	OffsetOut.ar(out, Pan2.ar(sig, pan, Lag.kr(amp, 0.5)));
}).add;

~samplerStereoSynthDef = SynthDef(\samplerStereo,{ arg out = 0, gate = 1, amp = 1, pan = 0, attack = 0.001, release = 1, buffer = 0, rate = 1, startPos = 0, loop = 0, doneAction = 2;
	var sig, env;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), gate, 1, doneAction: doneAction);
	sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate, gate, BufFrames.kr(buffer)*startPos, loop, doneAction) * env;
	sig = Balance2.ar(sig[0], sig[1], pan, amp/*.curvelin(0, 1, 0, 1, log(10))*/);
	OffsetOut.ar(out, sig);
}).add;

// Window

x = Window("SynthDef", Rect(600, 30, 800, 725));
x.layout = VLayout();
x.front;

v = ScrollView(x, x.view.bounds);
v.canvas = View();
v.canvas.layout = VLayout();

//Pattern
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

~song2Pattern2 = Pbind(
	\instrument, \hatnew,
	\dur, Pseq([0.25, Pn(0.125, 3), 0.25, 0.25, 0.125, 0.25, 0.125, 0.25, 0.125], inf),
	                      // 0.25 +  (0.125 *3)+ 0.25 +0.25 +0.125 +0.25 +0.125 +0.25 +0.125 == 2
	\pan, Pwhite(-0.75, 0.75, inf),
	\freq, 0.44,
	\hpf, 8500,
	\rel, 0.15,
	\amp, 2.6,
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
					"lpf", ["knob", ControlSpec(20, 20000, step: 1, default: event.at(\lpf)), true],
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
	\pan, Pwhite(-1, 1, inf),
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
					"rq", ["knob", ControlSpec(0, 1, step: 0.01, default: event.at(\rq)), true],
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
	})
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

// Sequencer

~pdefNumber.do({ // sequencer creation with pdefNumber of units
	arg i;
	var name;
	name = ("unit" ++ (i + 1)).asSymbol;
	~sequencer.put(name,
		Penvir(
			(pdefName: name, pdefPrevInstr: nil, pdefCcStart: 21, pdefMidiChan: i),
			Pdef(name).quant_(~globalQuant);
		)
	);
});

p = Ppar(~listUnits.value(~sequencer), inf); // all units in parallel

// Song
~song2 = {
	t.tempo = 82 / 60;
	~globalQuant = 4;
	loop {
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		~changePattern.value(Pdef(\unit3), ~song2Pattern3);
		~changePattern.value(Pdef(\unit4), ~song2Pattern4);
		~changePattern.value(Pdef(\unit5), ~song2Pattern5);
		~changePattern.value(Pdef(\unit6), ~song2Pattern6);
		~changePattern.value(Pdef(\unit7), ~song2Pattern7);
		~changePattern.value(Pdef(\unit8), ~song2Pattern8);
		16.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern10);
		~changePattern.value(Pdef(\unit2), ~song2Pattern9);
		4.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		Pbindef(\unit1, // change key value (synchro whith changePattern)
			\amp, 0.8,
			\tu, 0.75,
			\envL1, 0.62,
			\envL2, 0.01,
			\envL3, 0.69,
			\envT1, 0.44,
			\envT2, 0.17,
			\envfL1, 245,
			\envfL2, 270,
			\envfL3, 120,
			\envfT1, 0.18,
			\envfT2, 0.29,
			\envfT3, 1,
		).quant_(~globalQuant);
		8.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern10);
		~changePattern.value(Pdef(\unit2), ~song2Pattern9);
		4.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		8.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern10);
		~changePattern.value(Pdef(\unit2), ~song2Pattern9);
		Pbindef(\unit6,
			\amp, 0.065,
			\att, 0.26,
			\rel, 0.01,
			\ffreq, 7948
		).quant_(~globalQuant);
		Pbindef(\unit2,
			\release, Pseq([0.6, 0.3, 0.42, 0.16, 0.5, 0.42, 0.16, 0.7], inf),
			\freq, 0.01,
			\dur, Pseq([0.125, 0.125, 0.5, 0.25], inf) // 0.125+ 0.125+ 0.5+ 0.25 == 1
		).quant_(~globalQuant);
		8.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		~changePattern.value(Pdef(\unit3), ~song2Pattern12);
		~changePattern.value(Pdef(\unit6), ~song2Pattern6);
		28.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern10);
		~changePattern.value(Pdef(\unit2), ~song2Pattern9);
		4.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		~changePattern.value(Pdef(\unit4), ~song2Pattern11);
		Pbindef(\unit6,
			\amp, 0.065,
			\att, 0.26,
			\rel, 0.01,
			\ffreq, 7948
		).quant_(~globalQuant);
		Pbindef(\unit1,
			\amp, 0.8,
			\tu, 0.75,
			\envL1, 0.62,
			\envL2, 0.01,
			\envL3, 0.69,
			\envT1, 0.44,
			\envT2, 0.17,
			\envfL1, 245,
			\envfL2, 270,
			\envfL3, 120,
			\envfT1, 0.18,
			\envfT2, 0.29,
			\envfT3, 1,
		).quant_(~globalQuant);
		12.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern10);
		~changePattern.value(Pdef(\unit2), ~song2Pattern9);
		Pbindef(\unit2,
			\release, Pseq([0.6, 0.3, 0.42, 0.16, 0.5, 0.42, 0.16, 0.7], inf),
			\freq, 0.01,
			\dur, Pseq([0.125, 0.125, 0.5, 0.25], inf) // 0.125+ 0.125+ 0.5+ 0.25 == 1
		).quant_(~globalQuant);
		4.0.wait;
	}
};

)

( // Play
Tdef(\song, ~song2).play(t, true, ~globalQuant);
if (~sequencerTransport.isPlaying.not, { ~sequencerTransport = p.play(t, quant: ~globalQuant); });
)

( // Stop
Tdef(\song).stop;
~sequencerTransport.stop;
)

( // Reset Both
Tdef(\song).reset;
~sequencerTransport.reset;
~resetPdefView.value;
)