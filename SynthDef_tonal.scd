(

///////////////////////////////////////  Tonal

SynthDef(\cow, { arg out=0,tu=1, amp=0.5, pan=0,gate=1,rel=1;
	var sig;
	var env = EnvGen.ar(Env.adsr(0.001,0.01,0.1,rel),gate,doneAction:2);
	sig = LFPulse.ar(550*tu)+LFPulse.ar(tu*400*(env+250));
	sig = Ringz.ar(sig,(30..35)*10.234*tu,1).mean;
	//sig = Pan2.ar(sig*env, pan, amp);
	OffsetOut.ar(out, sig*amp*env);
}).add;

SynthDef(\notes,{arg out=0,freq = 69,gate = 1,tu = 1,amp=0.5;
	var env = EnvGen.ar(Env.perc(0.01,0.1),gate,doneAction:2);
	var sig = WhiteNoise.ar(env);
	sig = CombL.ar(sig,0.2,(freq+(432.cpsmidi-69)).midicps/SampleRate.ir,1)+sig;
	sig = CombL.ar(sig,0.2,(freq+(432.cpsmidi-69)).midicps/SampleRate.ir,0.2)+sig;
	sig = sig *env *0.5;
	sig = CompanderD.ar(sig*2,0.5,1,0.5);
	OffsetOut.ar(out,sig*amp);
}).add;

SynthDef(\notes2,{arg out=0,gate =1,notes=68,at = 0.01,sus=0.4,snd=18;
	var env = EnvGen.ar(Env.adsr(at,1,sus,1.4),gate,doneAction:2);
	//var env = EnvGen.ar(Env.perc(0.01,1),gate,doneAction:2);
	var note = (notes+(432.cpsmidi-69)).midicps;
	var sig = Mix.ar(SinOsc.ar([note,note*2,note/2]));
	sig = Splay.ar(sig*0.1);
	OffsetOut.ar(out,sig*env*0.5);
	//Out.ar(snd,sig*env);
}).add;

SynthDef(\sinus,{arg out=0, freq=100,gate =1,release=0.1,lfo=1,amp=0.5;
	var env  = EnvGen.ar(Env.perc(0,release),gate,doneAction:2);
	var sig = SinOsc.ar(freq.midicps+(432-69.midicps)*SinOsc.kr(lfo),0,env);
	sig = HPF.ar(sig,100);
	sig = CompanderD.ar(sig,0.3,0.3,1.5,0.0001,0.01);
	OffsetOut.ar(out,sig*amp);
}).add;

SynthDef(\conga, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3, sig4, sig5;
	sig1 = LFTri.ar(111);
	sig1 = FreqShift.ar(sig1, 175);
	sig1 = sig1 + FreqShift.ar(sig1, [224 * \harm2.kr(1),224 * \harm1.kr(1)]);
	sig1 = sig1 * EnvGen.ar(Env.perc(0.0001,0.22), gate);

	sig2 = SinOsc.ar(330) + SinOsc.ar(180);
	sig2 = sig2 * EnvGen.ar(Env.perc(0.0001,0.151), gate);

	sig3 = PinkNoise.ar(1);
	sig3 = BRF.ar(sig3, [100,800,300,400]*2).sum;
	sig3 = LPF.ar(sig3, [5000,6000,100,10000]*1);
	sig3 = sig3 * EnvGen.ar(Env.perc(0.0001,0.201, 1, \sqr), gate);

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,900,300,400]*4).sum;
	sig4 = LPF.ar(sig4, [500,4000,100,1000]*2*XLine.kr(1,0.100,0.01));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.251, 1, \cub), gate);

	sig5 = PinkNoise.ar(1) * sig2;
	//sig5 = BRF.ar(sig5, [100,800,300,400]*2).sum;
	sig5 = LPF.ar(sig5, [500,600,100,1000]*0.21);
	sig5 = sig5 * EnvGen.ar(Env.perc(0.0001,0.111, 1, \sqr), gate) * 4;

	sig = sig1 + sig3 + sig4 + sig5;
	//sig = (HPF.ar(sig,100)*14).distort + LPF.ar(sig, 100);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,2.4)),gate,doneAction:doneAction);
	//sig = DetectSilence.ar(sig, doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)