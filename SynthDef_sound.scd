(

///////////////////////////////////////  Sound

SynthDef(\starlet, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	var fspread;
	env1 = EnvGen.kr(Env([1,20,1],[1.7,0.8]), 1);
	fspread = 0.0007 + Rand(0,0.007)* env1;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) );
	sig1 = sig * ( sig/(sig+1.1)*50 * env1 ).clip(0.5);
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = sig /10;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\crackle, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Crackle.ar(\chaos.kr(1));
	sig = Formlet.ar(sig, freq,\format.kr(0.21),\formdec.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, 50);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\crackle2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Crackle.ar(\chaos.kr(1));
	sig = LFSaw.ar(freq * ( sig* 10.1 + 1 ));
	//sig = Formlet.ar(sig, freq,\format.kr(0.21),\formdec.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, 50);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\tredrone, { arg lagf=0, freq=200, pan=0, amp=0.1, out=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(lagf);
	freq = freq * [1, 5/3];
	sig = LFPulse.ar(freq * ( 1 + ( CuspL.ar(\cusfreq.kr(10) + [1,2,3],\cus2.kr(1.1),\cus3.kr(1)).lag(0.1) * ( CuspL.ar(0.1)/3 + 0.1+[ [0,0.01] ] ) * \fma.kr(1) ))).mean;
	sig.debug("kjkj");
	sig = sig /13;
	sig1 = sig;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq.lag(1) * SinOsc.kr(1*~t * [1,3/5]).range(0,1), \rq.kr(0.5));
	sig = sig + BPF.ar(sig1, freq.lag(1) * 8);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\corde, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01;
	var sig;
	var spread =1;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*1.2) * 1 + 1 )) * ( SinOsc.ar(freq * 0.2) * 1 + 1 );
	sig = sig * 0.9;
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\taule, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3, sig4, sig5;
	var osig, asig;
	sig1 = LFTri.ar(291);
	sig1 = FreqShift.ar(sig1, 75);
	sig1 = sig1 + FreqShift.ar(sig1, 24);
	sig1 = sig1 * EnvGen.ar(Env.perc(0.0001,0.01), gate) * 1;

	sig2 = SinOsc.ar(330) + SinOsc.ar(210);
	sig2 = sig2 * EnvGen.ar(Env.perc(0.0001,0.03), gate) * 1;

	sig3 = SinOsc.ar(100, SinOsc.ar(10, SinOsc.ar(40)) * 122);
	sig3 = SinOsc.ar(615.00,
		LFSaw.ar(410.87) +
			WhiteNoise.ar(2) +
		SinOsc.ar(487,
			WhiteNoise.ar(4) +
			SinOsc.ar(4390,
				WhiteNoise.ar(1) +
				SinOsc.ar(497) * 10.43)
			* 1.250)
		* 1.31);
	//sig3 = WhiteNoise.ar(1);
	sig3 = BRF.ar(sig3, [100,800,300,400]*2).sum;
	sig3 = BPF.ar(sig3, [100,100,100,200]*1);
	sig3 = FreqShift.ar(sig3, -400)+sig3/2;
	sig3 = FreqShift.ar(sig3, 300)+sig3/2;
	sig3 = sig3 * EnvGen.ar(Env.perc(0.1001,0.151, 1, -1), gate);

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,800,1900,400,900]*2).sum;
	sig4 = BPF.ar(sig4, [500,3000,740,1000]*1*XLine.kr(1,4.7100,[0.13,0.1,0.3]));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.151, 1, \cub), gate);
	asig = sig4;

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,800,1900,400,900]*2).sum;
	sig4 = LPF.ar(sig4, [500,3000,740,1000]*1*XLine.kr(1,2.7100,[0.13,0.1,0.3]));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.1001,0.051, 1/2, 4), gate);

	sig =
		0
		+ sig1
		+ sig2
		+ sig3
		+ sig4
		+ asig
		;
	sig = (HPF.ar(sig,4000 * XLine.kr(1,0.51,0.02))*4).tanh + LPF.ar(sig, 1200);


	osig = sig;
	sig = AllpassL.ar(sig,0.1,[0.012,0.02,0.014,0.0132] *2,0) + sig;
	sig = AllpassL.ar(sig,0.1,0.001,0) + sig;
	sig = LPF.ar(sig, 3000);
	//sig = BRF.ar(sig, [100,940,1700,4000,9000]*1) / 2;
	sig = sig + osig;
	//sig = osig;
	sig.postln;
	sig = sig * 0.51;


	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.00001,0.1,0.1,0.2,1,\sqr)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	sig = Pan2.ar(sig, pan, amp).mean*2;
	DetectSilence.ar(sig, 0.001,0.1,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\cling, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1/8,1,1/2,1/4],[0.01,1.7,4],-3), 1);
	sig1 = ( 1 + ( SinOsc.ar(rrand(0.01,1000!4)) * rrand(0.1,10!4) ));
	sig = SinOsc.ar(exprand(50.0,1000!4) * env1 * ( 1 + ( SinOsc.ar(rrand(0.01,1000!4) * sig1) * rrand(0.01,10!4))));
	sig = sig * ( 1 + ( SinOsc.ar(rrand(100.0,1000!4)) * 1 ));
	sig = CombL.ar(sig, 0.01,1/rrand(100.0,1000!14)) + sig;
	sig = CombL.ar(sig, 0.01,1/rrand(100.0,1000!14)) + sig;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean * 4;
	Out.ar(out, sig);
}).add;

SynthDef(\chh, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([12000,182,61],[4.1,2.8],[1,1]),1);
	env2 = EnvGen.kr(Env([1000,152,91],[4.1,2.8],[1,1]), 1);
	env3 = EnvGen.kr(Env([7100,1000,100],[4.5,0.8],[1,1]), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.4),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\fmcowbell, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	// cpu light
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * \fmr.kr(4) * ((0..7)/7 - 0.5 * \diff.kr(1) + 1)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1/70,0.1,0.8,0.2)),gate,doneAction:2);
	sig = sig.fold(\fold.kr(0.23));
	sig = sig * \gain.kr(1);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\prayer_bell, { |outbus, t_trig = 1, sing_switch = 0, freq = 2434, amp = 0.5, decayscale = 1, lag = 10, i_doneAction = 0|
  var sig, input, first, freqscale, mallet, sing;
  freqscale = freq / 2434;
  freqscale = Lag3.kr(freqscale, lag);
  decayscale = Lag3.kr(decayscale, lag);

  mallet = LPF.ar(Trig.ar(t_trig, SampleDur.ir)!2, 10000 * freqscale);
  sing = LPF.ar(
    LPF.ar(
      {
        PinkNoise.ar * Integrator.kr(sing_switch * 0.001, 0.999).linexp(0, 1, 0.01, 1) * amp
      } ! 2,
      2434 * freqscale
    ) + Dust.ar(0.1), 10000 * freqscale
  ) * LFNoise1.kr(0.5).range(-45, -30).dbamp;
  input = mallet + (sing_switch.clip(0, 1) * sing);


  sig = DynKlank.ar(`[
    [
      (first = LFNoise1.kr(0.5).range(2424, 2444)) + Line.kr(20, 0, 0.5),
      first + LFNoise1.kr(0.5).range(1,3),
      LFNoise1.kr(1.5).range(5435, 5440) - Line.kr(35, 0, 1),
      LFNoise1.kr(1.5).range(5480, 5485) - Line.kr(10, 0, 0.5),
      LFNoise1.kr(2).range(8435, 8445) + Line.kr(15, 0, 0.05),
      LFNoise1.kr(2).range(8665, 8670),
      LFNoise1.kr(2).range(8704, 8709),
      LFNoise1.kr(2).range(8807, 8817),
      LFNoise1.kr(2).range(9570, 9607),
      LFNoise1.kr(2).range(10567, 10572) - Line.kr(20, 0, 0.05),
      LFNoise1.kr(2).range(10627, 10636) + Line.kr(35, 0, 0.05),
      LFNoise1.kr(2).range(14689, 14697) - Line.kr(10, 0, 0.05)
    ],
    [
      LFNoise1.kr(1).range(-10, -5).dbamp,
      LFNoise1.kr(1).range(-20, -10).dbamp,
      LFNoise1.kr(1).range(-12, -6).dbamp,
      LFNoise1.kr(1).range(-12, -6).dbamp,
      -20.dbamp,
      -20.dbamp,
      -20.dbamp,
      -25.dbamp,
      -10.dbamp,
      -20.dbamp,
      -20.dbamp,
      -25.dbamp
    ],
    [
      20 * freqscale.pow(0.2),
      20 * freqscale.pow(0.2),
      5,
      5,
      0.6,
      0.5,
      0.3,
      0.25,
      0.4,
      0.5,
      0.4,
      0.6
    ] * freqscale.reciprocal.pow(0.5)
  ], input, freqscale, 0, decayscale);
  DetectSilence.ar(sig, doneAction: i_doneAction);
  Out.ar(outbus, sig);

// Tibetan prayer bells acoustically modeled
//by wondersluyter
//http://sccode.org/wondersluyter
}).add;

)