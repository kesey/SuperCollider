/**************************************************FX*************************************************************************/

(
SynthDef(\SimpleDelay, { arg in = 0, out = 0, delaytime = 0.1;
	var input, effect;
	input = In.ar(in, 2);
	effect = DelayN.ar(input, 1, delaytime);
	//Out.ar(0, effect); // Mix with the data already present on the corresponding bus
	ReplaceOut.ar(out, effect); // overwriting previous data on the corresponding bus
}).add;

SynthDef(\Chorus, { arg in = 0, out = 0, lpfreq = 6000, rq = 1, drywet = 0.5, level = 1;
	var input, effect, density, maxdelaytime;
	input = BPF.ar(In.ar(in, 2), lpfreq, rq);
	density = 10;
	effect = Mix.fill(density, {
		maxdelaytime = rrand(0.01,0.03);
		DelayC.ar(input, maxdelaytime, LFNoise1.kr(Rand(5,10),0.01,0.02));
	});
	XOut.ar(out, drywet, effect * level);
}).add;

SynthDef(\Reverb, {arg in = 0, out = 0, predelaytime = 0.048, decaytimec = 5, decaytimea = 1, drywet = 0.5, level = 0.2;
	var input, numc, numa, temp;
	input = In.ar(in, 2);
	numc = 4; // number of comb delays
	numa = 6; // number of allpass delays
	temp = DelayN.ar(input, 0.1, predelaytime);
	temp = Mix.fill(numc, { CombL.ar(temp, 0.1, rrand(0.01, 0.1), decaytimec) });
	numa.do({ temp = AllpassN.ar(temp, 0.051, [rrand(0.01, 0.05), rrand(0.01, 0.05)], decaytimea) });
	XOut.ar(out, drywet, temp * level);
}).add;

SynthDef(\Phasing, { arg in = 0, out = 0, freq = 0.2, drywet = 0.5, level = 1;
	var input, effect;
	input = In.ar(in, 2);
	effect = AllpassN.ar(input, 0.02, SinOsc.kr(freq, 0, 0.01, 0.01));  // max delay of 20msec
	XOut.ar(out, drywet, effect * level);
}).add;

SynthDef(\Flanging, {arg in = 0, out = 0, flangefreq = 0.1, fdback = 0.1, drywet = 0.5, level = 1;
	var input, effect;
	input = In.ar(0, 2);
	input = input + LocalIn.ar(2); // add some feedback
	effect = DelayN.ar(input, 0.02, SinOsc.kr(flangefreq, 0, 0.005, 0.005)); // max delay of 20msec
	LocalOut.ar(fdback * effect);
	XOut.ar(out, drywet, effect * level);
}).add;

SynthDef(\DistoInsideOut, { arg in = 0, out = 0, drywet = 0.5, level = 1;
	var input, effect;
	input = In.ar(in, 2);
	effect = InsideOut.ar(input);
	XOut.ar(out, drywet, effect * level);
}).add;

SynthDef(\DistoCrossOver, { arg in = 0, out = 0, amp = 0.5, smooth = 0.5, drywet = 0.5, level = 1;
	var input, effect;
	input = In.ar(in, 2);
	effect = CrossoverDistortion.ar(input , amp, smooth);
	XOut.ar(out, drywet, effect * level);
}).add;

SynthDef(\Compression, {arg in = 0, out = 0, gain = 1.5, threshold = 0.5, drywet = 0.5, level = 1;
	var input, effect;
	input = In.ar(in, 2);
	effect = CompanderD.ar(gain * input, threshold, 1, 0.5);
	XOut.ar(out, drywet, effect * level);
}).add;

SynthDef(\Limiter, { arg in = 0, out = 0, gain = 1, level = 0.99, dur = 0.01;
	var input, effect;
	input = In.ar(in, 2);
	effect = Limiter.ar(gain * input, level, dur);
	ReplaceOut.ar(out, effect);
}).add;
)

(
g = Group.basicNew(s, 1); // get the default group
i = Synth.head(g, "IkedaClick");
h = Synth.tail(g, "Chorus");
)

i.set(\t_trig, 1);
h.set(\drywet, 1, \lpfreq, 800);
[i, h].do(_.free);

/**************************************************Ikeda style****************************************************************/

(
SynthDef(\IkedaClick, { arg out = 0, t_trig = 0, centerFreq = 15000, rq = 0.9, amp = 25, pan = 0, level = 1;
	var noise, sig;
	noise = PinkNoise.ar(Decay.kr(t_trig, 0.001 * LFNoise1.kr(4).abs));
	sig = BPF.ar(noise, centerFreq.max(1), rq, amp * LFNoise1.kr(8).range(0, 1)).fold(-1, 1);
	Out.ar(out, Pan2.ar(sig, pan, level));
}).add;

SynthDef(\IkedaBreath, { arg out = 0, t_trig = 0, note1 = 44, note2 = 90, amp1 = 0.5, amp2 = 0.6, lpfFreq = 103.82, hpfFreq = 2400, attack = 0.0001, decay = 0.4, release = 0.01, pan = 0, level = 1;
	var sin, lpf, hpf, sig;
	sin = SinOsc.ar(note1.midicps, 0, amp1) + SinOsc.ar(note2.midicps, 0, amp2);
	lpf = LPF.ar(sin, lpfFreq.max(1));
	hpf = HPF.ar(LPF.ar(WhiteNoise.ar(0.008), 12000), hpfFreq.max(1));
	sig = (lpf + hpf) * EnvGen.kr(Env([0, 1, 0.6, 0], [attack, decay, release]), t_trig);
	Out.ar(out, Pan2.ar(sig, pan, level));
}).add;

SynthDef(\IkedaHiNoise, { arg out = 0, t_trig = 0, attack = 0.02, decay = 0.1, amp = 0.05, rq = 0.9, pan = 0, level = 10;
	var noise, sig;
	noise = WhiteNoise.ar(Decay2.kr(t_trig, attack, decay, amp));
	sig = BPF.ar(noise, TRand.kr(12000, 15000, t_trig), rq);
	Out.ar(out, Pan2.ar(sig, pan, level));
}).add;

SynthDef(\IkedaBass, { arg out = 0, t_trig = 0, pan = 0, level = 1;
	var env, sin, sig;
	env = EnvGen.ar(Env([0, 0.5, 0.4, 0], [0, 0.2, 0.01], -5), t_trig, doneAction: 2);
	sin = SinOsc.ar(0, (Sweep.ar(t_trig, 2pi * [52.8, 740]) + (pi/3)).wrap(-pi, pi), [2, 0.05]).mean.tanh;
	sig = (sin * env)!2;
	Out.ar(out, Pan2.ar(sig, pan, level));
}).add;
)

(
i = Synth(\IkedaBass);

i.set(\t_trig, 1);
)

/*****************************************************************************************************************************/

/**************************************************GUI************************************************************************/

(
var w, knob, button, sound;

sound = Synth(\IkedaBreath);
//sound.set(\decay, 1.5, \release, 0.5);

w = Window("mysound's window",Rect(100,300,300,200));

w.front;

w.view.decorator = FlowLayout(w.view.bounds, 10@10, 20@5);

knob = Knob(w,Rect(10,10,80,80));

button = Button(w,Rect(10,110,80,80)).states_([
            ["Off", Color.black, Color.white],
            ["On", Color.white, Color.black]
        ]);

knob.action = { sound.set(\note1,knob.value*100) };

button.action = { arg butt;
	sound.set(\t_trig,butt.value);
};

/*

// to let any MIDI control message set the knob position, and trigger the corresponding action

MIDIIn.control={ arg src, chan, num, val;

	// defer avoids complaints from the system that the GUI is being updated outside of a safe thread; it pushes the code through to the AppClock (see week 6 of course)

	{knob.value = (val/127.0); knob.action.value;}.defer;
};

// or to globally assign Control Change numbers

MIDIdef.cc(\all, { | val, ccnum, chan, src |
    case
    { ccnum == 0 } { knob.value = (val/127.0); knob.action.value; } // Control Change 0 control the knob
    { ccnum == 1 } {  } // Control Change 1 control what you want
    // {} {} // add more cases here as needed
    ;
    ["ccnum", ccnum, "value", val].postln;
});

*/

w.onClose = {sound.free;};

)

/*****************************************************************************************************************************/

/**************************************************Example of t_<arg name>****************************************************/

SynthDef(\mytriggersynth,{ arg t_trig = 0;
	var env;
	//must have additional starting level in envelope, else no nodes to go back to
	env = EnvGen.ar(Env([2,2,1],[0.0,0.5],'exponential'),t_trig);
	Out.ar(0, Pan2.ar(Resonz.ar(Saw.ar(env*440),1000,0.1),0.0));
}).add;

a = Synth(\mytriggersynth);

a.set(\t_trig, 1);	// if this wasn't an explicit t_<arg name> input, this wouldn't reset the envelope

/*****************************************************************************************************************************/

/**************************************************Sampler********************************************************************/

(

b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");

SynthDef(\sample,{ arg out = 0, bufnum = 0, rate = 1, trigger = 1, startPos = 0, loop = 0, pan = 0, level = 1;
	var sig;
	sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(bufnum)*startPos, loop, doneAction: 2);
	Out.ar(out, Pan2.ar(sig , pan, level));
}).add;

)
Synth(\sample, [\out, 0, \bufnum, b.bufnum]);

Synth(\sample, [\out, 0, \bufnum, b.bufnum, \rate, 0.5]); // play at half rate

/*****************************************************************************************************************************/

(

SynthDef(\kick, { arg out = 0, tu = 1, amp = 1, level = 1;
	var env0, env1, env1m, sig;
	env0 =  EnvGen.ar(Env.new([0.5, 1, 0.3, 0], [0.01, 0.5, 0.26], [-4, -2, -4]), doneAction: 2);
	env1 = EnvGen.ar(Env.new([120, 43, 29], [0.03, 0.29], [-4, -5]));
	env1m = env1.midicps;
	sig = LFPulse.ar(env1m*tu, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1m*1.5, env0);
	sig = sig + SinOsc.ar(env1m*tu, 0.5, env0*4);
	sig = sig * amp;
	sig = sig.clip2(1);
	Out.ar(out, Pan2.ar(sig, 0, level));
}).add;

SynthDef(\sd, { | out = 0, amp = 1 |
	var osc1, osc2, env;
	osc1 = WhiteNoise.ar;
	osc2 = FSinOsc.ar(200);
	env = EnvGen.kr(Env.perc(0, 0.05), doneAction: 2);
	Out.ar(out, Pan2.ar(LPF.ar(Mix([osc1, osc2]), 12000), 0, env*amp));
}).add;

SynthDef(\hat, { | out = 0, amp = 1 |
	var osc1, env;
	osc1 = WhiteNoise.ar;
	env = EnvGen.kr(Env.perc(0, 0.01), doneAction: 2);
	Out.ar(out, Pan2.ar(osc1, 0, env*amp));
}).add;

)

(
n = 180; // Tempo in beat per minutes
TempoClock.default.tempo = n/60; // TempoClock in beat per seconds
t = TempoClock(n*2/60); // Another TempoClock twice as fast as the TempoClock default

~swingify = Prout({ |ev|
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

Pdefn(\dur1, Pseq([1,0.5,2], inf));
Pdefn(\amp1, Pseq([1,0.15], inf));

Pdef(\kix,
	Pchain(
		~swingify,
		Pbind(
			\instrument, \kick,
			\tu, 1,
			\amp, Pdefn(\amp1),
			\dur, Pdefn(\dur1)
		),
		(swingBase: 0, swingAmount: 8, swingThreshold: 0.5)
	)
).play(); // use the TempoClock default, .play(t) use the TempoClock twice as fast as the TempoClock default

Pdef(\snares,
	Pbind(
		\instrument, \sd,
		\amp, 2, //Pseq([1,0.15], inf),
		\dur, 4 //Pseq([4,5], inf)
	)
).play();

Pdef(\hats,
	Pbind(
		\instrument, \hat,
		\amp, Pseq([1,0.15,1], inf),
		\dur, 0.25//,
		//\timingOffset, 2.5
	)
).play();

)

Pdef(\kix).quant_(4);
Pdef(\kix).play(); // use the TempoClock default
Pdef(\kix).stop;
Pdef(\snares).play(t); // use the TempoClock twice as fast as the TempoClock default
Pdef(\snares).quant_(8);
Pdef(\snares).stop;
Pdef(\snares).play;
Pdef(\snares).pause;
Pdef(\snares).resume; // play since where we paused
Pdef(\hats).stop;
Pbindef(\snares,\dur,Pseq([2, 3], inf),\amp,2);

/*********************************************************test******************************************************************/

// Share data between Pdef
(
n = 180;
t = TempoClock(n/60);

~swingify = Prout({ |ev|
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

Pdefn(\dur1, Pseq([1,0.5,2], inf));
Pdefn(\amp1, Pseq([1,0.15], inf));

p = Penvir((), Ptpar([
    0.0, Pdef(\kix,
		Pchain(
			~swingify,
			Pbind(
				\instrument, \kick,
				\amp, Pdefn(\amp1),
				\dur, Pdefn(\dur1),
				\timingOffset, 0,
				\sustain, 0,
				\tu, 1,
			),
			(swingBase: 0.4, swingAmount: 1.4, swingThreshold: 0.2)
		)
	).collect({ |event|
        ~lastKixEvent = event;
    }),
	0.1, Pdef(\snares, // can access data from \kix because of the timingOffset of 0.1: events in \kix (timingOffset 0.0) take place before events in \snares
		Pchain(
			~swingify,
		    Pbind(
				\instrument, \sd,
				\amp, Pdefn(\amp1),
				\dur, Pdefn(\dur1),
				\timingOffset, Pfunc({ ~lastKixEvent[\timingOffset] }),
				\sustain, Pfunc({ ~lastKixEvent[\sustain] })
			),
			(swingBase: 0.4, swingAmount: 0, swingThreshold: 0.2)
		)
	).collect({ |event|
        ~lastSnaresEvent = event;
    }),
	0.1, Pdef(\hats,
		Pchain(
			~swingify,
		    Pbind(
				\instrument, \hat,
				\amp, Pseq([1,0.15,1], inf),
				\dur, 0.25,
				\timingOffset, 0.06,
				\sustain, 0
			),
			(swingBase: 0.4, swingAmount: 0, swingThreshold: 0.2)
		)
	).collect({ |event|
        ~lastHatsEvent = event;
    })
])).play(t);
)

p.stop;