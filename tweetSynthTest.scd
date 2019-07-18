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
play{LocalOut.ar(k = tanh(500*(PinkNoise.ar(1!2)**(8/(LagUD.ar(
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



play{
	i = Impulse.ar(8).lag(0.3)!2;
	10.do {
		i = LeakDC.ar(
			AllpassC.ar(
				i,
				1,
				LFNoise0.ar(8).range(1e-5,0.2),
				-0.15,
				LFNoise0.ar(8).range(1,3)
			)
		).tanh;
	};
	i;
};

(
SynthDef(\harshTexture, { arg out = 0, amp = 1, t_trig = 1, attack = 0.01, release = 2, doneAction = 2;
	var sig, env;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = Impulse.ar(8).lag(0.3)!2;
	10.do {
		sig = LeakDC.ar(
			AllpassC.ar(
				sig,
				1,
				LFNoise0.ar(8).range(1e-5,0.2),
				-0.15,
				LFNoise0.ar(8).range(1,3)
			)
		).tanh;
	};
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \harshTexture,
	\dur, 4,
	\amp, 2,
	\sustain, Pseq([4, 1, 2, 4], inf)
).play;
)

play{
	Blip.ar(
		[16e3,16150],
		2,
		LFTri.ar(
			Duty.ar(
				LFNoise0.ar(
					0.2,
					4,
					6

				),
				0,
				Dseq([70,30,0],inf))).clip(0,1)
	);
};//#supercollider_summer


(
SynthDef(\ultraHiSummer, { arg out = 0, amp = 1, t_trig = 1, attack = 0.01, release = 2, doneAction = 2;
	var sig, env;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = Blip.ar(
		[16e3,16150],
		2,
		LFTri.ar(
			Duty.ar(
				LFNoise0.ar(0.2,4,6),
				0,
				Dseq([70,30,0],inf)
			)
		).clip(0,1)
	);
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \ultraHiSummer,
	\dur, 4,
	\amp, 2,
	\sustain, Pseq([4, 1, 2, 4], inf)
).play;
)


{SinOsc.ar(65.41,0,(SinOsc.kr(0.5, 0,0.5)))+SinOsc.ar(130.81,0,(SinOsc.kr(10,0,0.5)))+SinOsc.ar(523.25,0,(SinOsc.kr(0.05,0,0.05)))}.play;//b


play{a=LFNoise0;b=FBSineC.ar(a.kr(4,2e4,2e4),a.kr(10,16,17),1,1.005,0.7)!2;Latch.ar(b,Impulse.ar(a.kr(0.5,5e3,4e3)))*a.kr(5,0.4,0.5)}// #sc
play{RLPF.ar(Latch.ar(SinOsc.ar([100,100.5])!2,Impulse.ar(Duty.kr(Dseq([2,1]/4,inf),0,Drand((67,67.2..70),inf)))),800)} // #sc _dubsteppy_
play{CombN.ar(Splay.ar(Pulse.ar(Gendy3.kr([1,2,4,6])+LFNoise0.ar(4,6,Gendy3.kr(5,freq:[10,99])))*Gendy2.ar([0,1],maxfreq:[55,99])),3,0.4,2)}
play{x=LFDNoise3;Blip.ar(x.kr(1,[400,100],500),x.kr([1,2],6,5))*Gendy3.ar(1,1,1,1,x.kr(1,99,91),1,0.1)*x.ar(0.5,0.5,0.5)}// #sc
t=("come out to show them "!999).join;Speech.init(2);[98,99].do{|r,i|Speech.setSpeechVoice(i,3).setSpeechRate(i,r).channels[i].speak(t)};
t=("it's gonna rain "!999).join;Speech.init(2);[98,99].do{|r,i|Speech.setSpeechVoice(i,3).setSpeechRate(i,r).channels[i].speak(t)};// #sc sr
a=UGen.subclasses;fork{loop{u=a.choose;try{play{u.ar*EnvGen.ar(Env.perc(0.1,1),doneAction:2)!2}};1.wait}}//#sc #supercollider !!!NOT SAFE!!!
f=_.speak;fork{loop{f.("hi scott");2.wait;Speech.channels[0].voice_(20.rand)}} // #sc #supercollider // now with tag
f={|i,o,d|play{Saw.ar(XLine.kr(i,o,d,1,0,2))!2*EnvGen.kr(Env.sine(d))}};fork{loop{t=rrand(1e3,9e3);f.(t,t/4,rrand(0.1,1));9.rand.wait}}//#sc
play{a=[1,1.01,2,2.02,3.5,4.01,5.501];SinOsc.ar(Duty.kr(0.2,0,Dseq([10,11,0,12.2,0,0,10,0]+39,inf).midicps)*(a++(a*2))).sum!2/2}//DAF #sc
play{SinOsc.ar(Duty.kr(0.2,0,Dseq([0,5,0,15,0,12,0,0,12,0,12,0,12,10,0,12]+47,inf).midicps)*[1,1.01,2,2.02,3.5,4.01,5.501]).sum!2}// DAF #sc
b=Buffer.read(s,"*/*v".pathMatch@0);play{x=SinOsc;ring4(ar(TGrains,2,kr(Impulse,ar(x,[1,3],0,10,[9,20])),b,1,ar(x,1/9),0.01),ar(x,1e3))*9}
b=Buffer.read(s,"*/*v".pathMatch[0]);play{TGrains.ar(2,Impulse.kr([9,19]*LFNoise0.kr(2,1,1)),b,LFNoise0.kr(1,(1..4),2),0,1/10).sum*10}//#sc
play{var cpm=60;SinOsc.ar(700)!2*ToggleFF.ar(TDuty.ar(Dseq([1,1,1,1,1,2, 2,1,2,1,2,2, 1,1,1,1,1,3]/1e3*(6e3/cpm),inf)))} // S.O.S @ #sc
play{SinOsc.ar(Latch.ar(SinOsc.ar(1.75,0,1e2,2e2),Impulse.ar((1,1.1..2)*2)).lag(0.1)/2*(1,1.25..8)).sum**3!2}// #supercollider (last one)
play{ SinOsc.ar(Latch.ar(SinOsc.ar(1.75,0,1e2,2e2),Impulse.ar([1,1.0001])).lag(0.1)*(1,1.25..8)).sum**3!2 } // #supercollider
play{Splay.ar(SinOsc.ar(Latch.ar(SinOsc.ar(1.3,0,4e2,5e2),Impulse.ar([1,1.0001])*[1,2,3,4]).lag(0.05)))} // #supercollider (nicer)

play{SinOsc.ar(Latch.ar(SinOsc.ar(1.3,0,4e2,5e2),Impulse.ar([1,1.0001])).lag(0.05))} // #supercollider /* simple but hypnotizing */

play{
	x = LFNoise2.kr(22,5,9);
	CombC.ar(
		Splay.ar(
			Gendy3.ar(
				[4,2],
				[0.5,1],
				[1/9,1/4]*x,
				[1/2,1/8]*x,
				(9,49..199)
			)
		),
		5,
		[0.13,0.1],
		[x/2,x/2.1]
	)
}; // #sc

(
SynthDef(\ambiantPic, { arg out = 0, amp = 1, t_trig = 1, attack = 0.01, release = 2, doneAction = 2;
	var sig, env;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = LFNoise2.kr(22,5,9);
	sig = CombC.ar(
		Splay.ar(
			Gendy3.ar(
				[4,2],
				[0.5,1],
				[1/9,1/4]*sig,
				[1/2,1/8]*sig,
				(9,49..199)
			)
		),
		5,
		[0.13,0.1],
		[sig/2,sig/2.1]
	);
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \ambiantPic,
	\dur, 4,
	\amp, 2,
	\release, 10
).play;
)

{x=TRand.kr(30,XLine.kr(2e4,30,99,1,1,2),Impulse.kr((1..9))).cpsmidi.round.midicps;Splay.ar(SinOsc.ar(x))*AmpComp.kr(x,10)}.play // #sc
fork{loop{d=rrand(1,9);play{f=200.rand+60;Splay.ar(SinOsc.ar(XLine.kr(f,(f,f+1..f+f),d,1,0,2),0,0.1))};d.wait}}//cpu expense #supercollider
play{RLPF.ar(Demand.ar(Impulse.ar(20000),0,Dxrand([Dseq((1,0.005..0)),Dseq([1]++(0!555)),Dseq((0!999))],inf)),Line.kr(100,3000,80),0.1)!2}
play{SinOsc.ar(Latch.ar(LFSaw.ar(0.3,1,100,300).cpsmidi.round.midicps*[1,2],Impulse.ar(4)))} // tonal scales #supercollider
play{a=(1,0.97..0.005);GVerb.ar(Decay2.ar(TDuty.ar(Dseq(a++(a/2)++(a/4)++(a/8))),XLine.kr(0.05,0.001,15),0.1,0.05)*9,4,1)}//#supercollider

play{
	t = TDuty.kr(Dseq([1,1,4,2,2]/8,inf));
	Resonz.ar(
		Crackle.ar!2,
		Demand.kr(t,0,Dseq([250,8e3],inf)),
		Demand.kr(t,0,Dwhite(0.01,0.5,inf))
	)
};

(
SynthDef(\attBreath, { arg out = 0, amp = 1, t_trig = 1, attack = 0.01, release = 2, doneAction = 2;
	var sig, env;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = TDuty.kr(Dseq([1,1,4,2,2]/8,inf));
	sig = Resonz.ar(
		Crackle.ar!2,
		Demand.kr(sig,0,Dseq([250,8e3],inf)),
		Demand.kr(sig,0,Dwhite(0.01,0.5,inf))
	);
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \attBreath,
	\dur, 4,
	\amp, 2,
	\release, 10
).play;
)

play{
	t = TDuty.kr(Dseq([1,1,4,2,2]/8,inf));
	Resonz.ar(
		WhiteNoise.ar!2,
		Demand.kr(t,0,Dseq([250,8e3],inf)),
		Demand.kr(t,0,Dwhite(0.01,0.5,inf))
	)
}

(
SynthDef(\attWind, { arg out = 0, amp = 1, t_trig = 1, attack = 0.01, release = 2, doneAction = 2;
	var sig, env;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = TDuty.kr(Dseq([1,1,4,2,2]/8,inf));
	sig = Resonz.ar(
		WhiteNoise.ar!2,
		Demand.kr(sig,0,Dseq([250,8e3],inf)),
		Demand.kr(sig,0,Dwhite(0.01,0.5,inf))
	);
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \attWind,
	\dur, 4,
	\amp, 2,
	\release, 10
).play;
)

play{t=Impulse.ar((1,1.3..4)/2).sum;Decay2.ar(t,0.05,0.2,Splay.ar(SinOsc.ar(Demand.ar(t,0,Drand((120,180..800),inf)))*ToggleFF.ar(t)))}
play{t=Impulse.ar((1,1.3..4)/2).sum;Decay2.ar(t,0.001,0.2,Splay.ar(SinOsc.ar(Demand.ar(t,0,Drand((120,145..400),inf)))*ToggleFF.ar(t)+t))}
play{BPF.ar(SoundIn.ar(0),Array.geom(16,120,1.5),0.005,2).sum.dup} // kind of EZ resonator / vocoder for the mic #supercollider
play{FreeVerb.ar(CombC.ar(SoundIn.ar(0).softclip,1,1/120,1),0.4,1,1).dup}//easy hall/resonator fx for my lap steel guitar #supercollider
play{SinOsc.ar(Latch.ar(SinOsc.kr(0.75).range(0,12).round.midiratio*[200,400*SinOsc.kr(0.01).range(1,4)],TDuty.kr(Dseq([1,2]/8,inf))))} //ye
play{t=TDuty.kr(Drand(([1,2,3]/8),inf));SinOsc.ar(Demand.kr(t,0,Drand((50,53..71).midicps,inf))*[1,1.5]*LFPulse.kr(0.5).range(1,2)).dup}

{
	Splay.ar(
		SinOsc.ar(
			Array.fill(100,{\freq.asSpec.map(LFNoise2.kr(0.001))})
		)
	)
}.play;

(
SynthDef(\glauk, { arg out = 0, amp = 1, t_trig = 1, attack = 0.01, release = 2, doneAction = 2;
	var sig, env;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = Splay.ar(
		SinOsc.ar(
			Array.fill(100,{\freq.asSpec.map(LFNoise2.kr(0.001))})
		)
	);
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \glauk,
	\dur, 4,
	\amp, 2,
	\release, 10
).play;
)

{
	x = Array.fill(3,{Array.fill(50,{[40,150].asSpec.map(LFNoise2.kr(0.01))})});
	Splay.ar(SinOsc.ar(x[0]+SinOsc.ar(x[1],0,x[2]-39)));
}.play;

(
SynthDef(\lust, { arg out = 0, amp = 1, t_trig = 1, attack = 0.01, release = 2, doneAction = 2;
	var sig, env, ctrl;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	ctrl = Array.fill(3,{Array.fill(50,{[40,150].asSpec.map(LFNoise2.kr(0.01))})});
	sig = Splay.ar(SinOsc.ar(ctrl[0]+SinOsc.ar(ctrl[1],0,ctrl[2]-39)));
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \lust,
	\dur, 4,
	\amp, 2,
	\release, 10
).play;
)

{Out.ar([0,1],e=Trig.ar(Dust.ar(10));e=TRand.kr(100,10000,e);e=SinOsc.ar(e).round(SinOsc.ar(Line.kr(0,100,30))))}.play; // #supercollider :D

play{
	Splay.ar(
		Array.fill(15,{Ringz.ar(Dust.ar(Rand(1,10)), Rand(50,9000).round(100), 2)},
			1,
			0.5,
			0
		)
	)
} // #supercollider tweets = good idea!!!

(
SynthDef(\scinty, { arg out = 0, amp = 1, t_trig = 1, attack = 0.01, release = 2, doneAction = 2;
	var sig, env;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	sig = Splay.ar(
		Array.fill(15,{Ringz.ar(Dust.ar(Rand(1,10)), Rand(50,9000).round(100), 2)},
			1,
			0.5,
			0
		)
	);
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \scinty,
	\dur, 4,
	\amp, 0.2,
	\release, 10
).play;
)

{120.do{z=1e3;x={rrand(0.1,5)}!8;{{Klank.ar(`[x*z,x/60,2],LFNoise2.ar)*EnvGen.kr(Env.sine(2),doneAction:2)}!2}.play;1.wait;}}.fork

play{
	x = 165;
	b = SinOsc;
	p = Trig.ar(Saw.ar(x),1);
	y = b.ar(p * x);
	z = b.ar(p);
	(GVerb.ar(GrainIn.ar(2,y,y/2,z,p*z,-1),9))/9;
}//basso gettato #SuperCollider

(
SynthDef(\bublybub, { arg out = 0, amp = 1, t_trig = 1, attack = 0.01, release = 2, x = 165, doneAction = 2;
	var sig, env, waveForm, freq, dur, input;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	waveForm = SinOsc;
	freq = Trig.ar(Saw.ar(x),1);
	dur = waveForm.ar(freq * x);
	input = waveForm.ar(freq);
	sig = GVerb.ar(GrainIn.ar(2,dur,dur/2,input,freq*input,-1),9);
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \bublybub,
	\dur, 4,
	\amp, 0.2,
	\release, 10,
	\x, 165
).play;
)

{
	var r = SinOsc.ar(1/2,[0,1],3,1),
	s = Impulse.ar([r+0.2,r]);
	FreeVerb.ar(Decay.ar(s,r,MoogFF.ar(SinOsc.ar(([r.asin])*50),400)).softclip/2)
}.play;

(
SynthDef(\scratchi, { arg out = 0, amp = 1, t_trig = 1, attack = 0.01, release = 2, doneAction = 2;
	var sig, env, waveForm, trig;
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), t_trig, doneAction: doneAction);
	waveForm = SinOsc.ar(1/2,[0,1],3,1);
	trig = Impulse.ar([waveForm+0.2,waveForm]);
	sig = FreeVerb.ar(Decay.ar(trig,waveForm,MoogFF.ar(SinOsc.ar(([waveForm.asin])*50),400)).softclip/2);
	sig = sig * env;
	OffsetOut.ar(out, sig * amp);
}).add;
)

(
Pbind(
	\instrument, \scratchi,
	\dur, 4,
	\amp, 1,
	\release, 10
).play;
)

{var d=Demand.kr(Impulse.kr(2),0,LFTri.kr(1,0,2,1));(Ringz.ar(Dust.ar([d,d+1]),d**d,1)+Decay.ar(Impulse.ar(4),0.5,SinOsc.ar(50!2)));}.play;