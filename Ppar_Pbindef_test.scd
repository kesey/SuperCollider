(
SynthDef(\bass, { arg out = 0, t_trig = 0, pan = 0, amp = 1;
	var env, sin, sig;
	env = EnvGen.ar(Env(#[0, 0.5, 0.4, 0], #[0, 0.2, 0.01], -5), t_trig, doneAction: 2);
	sin = SinOsc.ar(0, (Sweep.ar(t_trig, 2pi * [52.8, 740]) + (pi/3)).wrap(-pi, pi), #[2, 0.05]).mean.tanh;
	sig = (sin * env)!2;
	OffsetOut.ar(out, Pan2.ar(sig, pan, amp));
}).add;

SynthDef(\hiNoise, { arg out = 0, t_trig = 0, attack = 0.02, decay = 0.1, amp = 0.05, rq = 0.9, pan = 0, level = 10;
	var noise, sig;
	noise = WhiteNoise.ar(Decay2.kr(t_trig, attack, decay, amp));
	sig = BPF.ar(noise, TRand.kr(12000, 15000, t_trig), rq);
	DetectSilence.ar(sig, 0.001, doneAction:2);
	OffsetOut.ar(out, Pan2.ar(sig, pan, level));
}).add;
)

// in the example above no problem when change trig value
(

Pdef(\unit1,
	Pbind(
		\instrument, \hiNoise,
		\dur, 0.5,
		\amp, 0.06
	)
).play;

Pdef(\unit2,
	Pbind(
	\instrument, \bass,
	\dur, Pseq([1, 0.5], inf),
	\amp, 0.8
)
).play;

)

Pbindef(\unit2, \trig, 0);
Pbindef(\unit2, \trig, 1);


// in the example above changing trig value create an offset on \bass
(

//p = Ppar([

Penvir((pdefName: \unit3, prevInstr: nil), Pdef(\unit3,
	Pbind(
		\instrument, \bass,
		\dur, Pseq([1, 0.5], inf),
		\amp, 0.8,
		\function, Pfunc({
			~pdefName.debug("pdefName");
			~prevInstr.debug("prevInstr");
			0;
		})
	)
)).play;

Penvir((pdefName: \unit4, prevInstr: nil), Pdef(\unit4,
	Pbind(
		\instrument, \hiNoise,
		\dur, 0.5,
		\amp, 0.06,
		\decay, 10,
		\function, Pfunc({
			~pdefName.debug("pdefName");
			~prevInstr.debug("prevInstr");
			0;
		})
	)
)).play;

//]);
)

Pbindef(\unit3, \amp, 0);
Pbindef(\unit3, \amp, 1);
Pbindef(\unit4, \amp, 0);
Pbindef(\unit4, \amp, 1);
