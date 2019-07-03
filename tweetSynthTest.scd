{a=LocalIn.ar;LocalOut.ar(Mix.ar(x=SinOsc.ar((Decay.ar(Impulse.ar([4,4.005]),1e3*a.abs)*50), a).distort));x;}.play;//tryingharder_to_noavail
{f=LocalIn.ar(2).tanh;k=Latch.kr(f[0].abs,Impulse.kr(0.5));LocalOut.ar(f+AllpassN.ar(Pulse.ar([2,3],k*0.01+1e-6,0.9),1,k*0.3,100*k));f}.play
play{f=LocalIn.ar(2).tanh;k=Latch.kr(f[0].abs,Impulse.kr(1/4));LocalOut.ar(f+CombC.ar(Blip.ar([4,6],100*k+50,0.9),1,k*0.3,50*f));f}//44.1kHz
Pspawner({|r|f={|t|r.par(Pbindf(Pbind(\note,Pseq([-1,1,6,8,9,1,-1,8,6,1,9,8]+5,319)),\dur,t))};f.(1/6);r.wait(12);f.(0.1672)}).play//s.reich
play{t=Impulse.ar(75);Sweep.ar(t,150).fold(0,1)*PlayBuf.ar(1,Buffer.read(s,"s*/*".pathMatch[2]),1,t,Demand.ar(t,0,Dbrown(0,2e5,2e3,inf)))!2}
play{f={LocalBuf(512)};r={|k,m|RecordBuf.ar(Pulse.ar(8,m,6e3),k)};r.(a=f.(),0.99);r.(b=f.(),0.99001);Out.ar(0,IFFT([a,b]).tanh)};//44.1kHz:)

play{LocalOut.ar(x=DelayC.ar(LPF.ar(LFNoise0.ar(8)**2+LocalIn.ar(2).tanh.round(0.05),6e3),1,LFNoise0.ar(8!2).range(1e-4,0.02)));x.tanh}//#sc


play{t=Impulse.ar(8)*LFNoise1.ar(2);CombL.ar(Saw.ar([3,4],Decay.ar(t,0.1)).tanh,1,TRand.ar(0,0.01,t).round(15e-4),TRand.ar(-30,30,t))};//#sc

play{q=[0,3,5,7,10];t=Impulse.kr(4)*LFNoise0.kr>0;PitchShift.ar(Saw.ar(Demand.kr(t,0,Drand((q+12++q+33).midicps,inf)),Decay.kr(t,3)),7,2)!2}

play{(HPF.ar(LFNoise1.ar(2),[10,10.1])*100).tanh}// #supercollider yay! (be very careful with this one, very loud)

play{
	t = [0,3,5,7,10,12]+30;
	a = Demand.kr(
		Impulse.kr(8),
		0,
		Drand(t+24++t,inf)
	);
	(
		BHiPass.ar(
			LFNoise1.ar(8)**3,
			[a,a+0.2].midicps,
			a/2e3,67-a
		)
	).tanh;
}

(
SynthDef(\mutantFric, { arg out = 0, amp = 1, spec1 = 0.00001, spec2 = 0.03, noiseFreq = 3, gate = 1, attack = 0.01, release = 1, doneAction = 2;
	var friction, sig;
	friction = Array.fill(5, {
		[spec1, spec2].asSpec.map(LFNoise2.kr(noiseFreq))
	});
	sig = Friction.ar(LFTri.ar(50), friction: friction, mass: friction*30000);
	sig = sig * EnvGen.kr(Env.asr(attack, releaseTime: release), gate, doneAction: doneAction);
	OffsetOut.ar(out, Splay.ar(sig * amp));
}).add;

SynthDef(\tweetSynth, { arg out = 0, amp = 1, freq = 25, t_trig = 1, attack = 0.01, release = 1;
	var sig, demand;
	demand = Demand.kr(
		t_trig,
		0,
		Drand(freq,inf)
	);
	sig = (
		BHiPass.ar(
			LFNoise1.ar(8) ** 3,
			[demand, demand + 0.2].midicps,
			demand / 2e3, 67 - demand
		)
	).tanh;
	sig = sig * EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: 2);
	OffsetOut.ar(out, sig * amp);
}).add;
)

Synth(\tweetSynth, [\t_trig, 1]);
Synth(\tweetSynth, [\t_trig, 0]);

Synth(\mutantFric, [\gate, 1]);
Synth(\mutantFric, [\gate, 0]);

Pbind(
	\instrument, \tweetSynth,
	\dur, 4,
	\amp, 1,
	\freq, 25
).play;

play{
	LeakDC.ar(
		BRF.ar(
			Saw.ar(
				8,
				Decay2.kr(
					x = Duty.kr(
						1/8,
						0,
						Drand([0, Drand((0.4, 0.5..1))],inf)
					),
					0.01,
					0.3
				)
			) ** 1.5,
			x * 20 + [45.1, 45],
			0.1
		)
	).tanh;
};//#sc

(

SynthDef(\tweetBassLeak, { arg out = 0, t_trig = 1, amp = 1, attack = 0.01, release = 1, doneAction = 2;
	var sig, demand, env;
	demand = Demand.kr(
		t_trig,
		0,
		Drand([0, Drand((0.4, 0.5..1))],inf)
	);
	env = Decay2.kr(
		demand,
		0.01,
		0.3
	);
	sig = Saw.ar(8, env) ** 1.5;
	sig = BRF.ar(sig, demand * 20 + [45.1, 45], 0.1);
	sig = sig * EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = LeakDC.ar(sig).tanh;
	OffsetOut.ar(out, sig * amp);
}).add;

)

Synth(\tweetBassLeak, [\t_trig, 1]);
Synth(\tweetBassLeak, [\t_trig, 0]);

Pbind(
	\instrument, \tweetBassLeak,
	\dur, 4,
	\amp, 1,
	\sustain, Pseq([4, 1, 2, 4], inf)
).play;

play{
	i = Impulse.ar(_);
	SinOsc.ar(
		i.(2).lagud(0,0.4)*360,
		Integrator.ar(
			Integrator.ar(
				i.(64).lag(LFNoise1.ar(2!2,2,2))*99,
				0.9

			),
			0.99
		).fold2(pi)
	)
};

(
SynthDef(\tweetKickInt, { arg out = 0, t_trig = 1, attack = 0.01, release = 2, amp = 1, doneAction = 2;
	var sig, freq, phase, env, i;
	i = Impulse.ar(_);
	freq = i.(2).lagud(0,0.4)*360;
	phase = Integrator.ar(
		Integrator.ar(
			i.(64).lag(LFNoise1.ar(2!2,2,2))*99,
			0.9
		),
		0.99
	).fold2(pi);
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = SinOsc.ar(freq, phase, env);
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \tweetKickInt,
	\dur, 1,
	\amp, 1,
	\sustain, Pseq([4, 1, 2, 4], inf)
).play;
)

play{
	LocalOut.ar(
		k = LeakDC.ar(
			Integrator.ar(
				Pulse.ar(pi/[1,2.57],[0.54,0.46]),
				(1-LocalIn.ar(2)).fold(0,[0.9,0.85])
			).wrap2(pi).sin
		)
	);
	k.mean!2;
};

(
SynthDef(\tweetFogAttack, { arg out = 0, t_trig = 1, feedBack = 0.2, attack = 0.01, release = 2, amp = 1, doneAction;
	var sig, env, coef;
	sig = Pulse.ar(pi/[1,2.57],[0.54,0.46]);
	coef = (1-LocalIn.ar(2)).fold(0,[0.9,0.85]);
	sig = LeakDC.ar(Integrator.ar(sig, coef).wrap2(pi).sin);
	LocalOut.ar(sig);
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = (sig.mean!2) * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \tweetFogAttack,
	\dur, 1,
	\amp, 1,
	\sustain, Pseq([4, 1, 2, 4], inf)
).play;
)

{
	n = LFNoise0.ar(_);
	f=[60,61];
	tanh(
		BBandPass.ar(
			max(
				max(n.(4),l=n.(6)),
				SinOsc.ar(f*ceil(l*9).lag(0.1))*0.7
			),
			f,
			n.(1).abs/2
		)*700*l.lag(1)
	)
}.play;

(
SynthDef(\tweetAnaBass, { arg out = 0, t_trig = 1, freq = 60, attack = 0.01, release = 2, amp = 1, pan = 0, doneAction = 2;
	var sig, env, bw;
	bw = LFNoise0.ar(_);
	sig = max(
		max(bw.(4),l=bw.(6)),
		SinOsc.ar(freq * ceil(l*9).lag(0.1))*0.7
	);
	sig = tanh(
		BBandPass.ar(sig, freq, bw.(1).abs/2)*700*l.lag(1)
	);
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = sig * env;
	OffsetOut.ar(out, Pan2.ar(sig, pan, amp));
}).add;
)

(
Pbind(
	\instrument, \tweetAnaBass,
	\dur, 1,
	\amp, 1,
	\sustain, Pseq([4, 1, 2, 4], inf),
	\freq, [60, 61]
).play;
)

(
play{
	LocalOut.ar(
		k = tanh(
			500*(
				PinkNoise.ar(1!2)**(8/
					(
						LagUD.ar(
							y=LocalIn.ar(2).range(0,0.9)+0.1,
							0,
							0.2
						)
					)
				)
			)
		)
	);
	Splay.ar(k,1-y);
};
)

// you have to test and copy
(
SynthDef(\tweetErosion, { arg out = 0, t_trig = 1, attack = 0.01, release = 2, feedBack = 1, amp = 1, doneAction = 2;
	var sig, env, input, div;
	input = LocalIn.ar(2).range(0,0.9)+0.1;
	div = LagUD.ar(input, 0, 0.2);
	sig = PinkNoise.ar(1!2);
	sig = tanh(500*(sig**(8/div)));
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	LocalOut.ar(sig * feedBack);
	sig = Splay.ar(sig,1-input);
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \tweetErosion,
	\dur, 4,
	\amp, 2,
	\sustain, Pseq([4, 1, 2, 4], inf)
).play;
)