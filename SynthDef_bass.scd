(

///////////////////////////////////////  Bass

SynthDef(\bass1,{arg gate = 1, amp=1, out=0,rel=0.1,pan=0,tu=1;
    var env = EnvGen.ar(Env.adsr(0,8,1,4),gate,doneAction:2);
    var freq = EnvGen.ar(\freqenv.kr(Env([50,40],[0.1,0.3,0.3])));
    var sig = SyncSaw.ar(freq*tu,20);
    sig = BRF.ar(sig,432,1);
    sig = HPF.ar(sig,300);
    sig =sig.distort;
    OffsetOut.ar(out,sig*amp*env);
}).add;

SynthDef(\bass3,{arg gate = 1, amp=1, out=0,rel=0.1,pan=0,tu=1.54;
    var env = EnvGen.ar(Env.adsr(0,4,1,0.1),gate,doneAction:2);
    var freq = EnvGen.ar(Env([14000,50,30],[0.001,0.1,0.1]));
    var sig = LFPar.ar([tu,tu+1],SinOsc.kr([2,1]))+LFPar.ar(tu,SinOsc.kr([1,2]));
    sig = Splay.ar(sig,SinOsc.kr(0.1),1,SinOsc.kr(pan));
    OffsetOut.ar(out,sig*amp*env);
}).add;

SynthDef(\bass,{arg out=0, gate = 1 ,dis = 0.5,freq=60,tu = 1,amp=1,atf = 80, rel =1;
    var env = EnvGen.ar(Env.adsr(0.05,0,1,rel),gate,doneAction:2);
    var frequ = EnvGen.ar(Env([freq+1000,freq-100],[0.05,0.1]));
    var sig = LFSaw.ar(LFSaw.ar(frequ-100,0,frequ-200,frequ*tu),0,env);
    sig = CrossoverDistortion.ar(sig,dis,0.05)+sig;
    sig = DelayL.ar(sig,0.05,0.001)+sig;
    sig = DelayL.ar(sig,0.05,0.001)+sig;
    sig = DelayL.ar(sig,0.05,0.01)+sig;
    sig = BPeakEQ.ar(sig,80,1,6);
    sig = sig *0.4*(env);
    //sig = LPF.ar(sig,100);
    sig = Compander.ar(sig,In.ar(0,1),0.05,1,0.1,0.01,0.1);
    OffsetOut.ar(out,sig * amp);
}).add;

~sinBassSynthDef = SynthDef(\sinBass, { arg out = 0, gate = 1, amp = 1, curve = \lin, loopNode = nil, attack = 0.01, release = 4, pan = 0, envFreq1 = 0, envFreq2 = 40, envFreq3 = 32, envFreq4 = 50, envFreq5 = 0, envFreq6 = 60, envTime1 = 0.5, envTime2 = 0.3, envTime3 = 0.25, envTime4 = 1, envTime5 = 0.5, doneAction = 2;
	var freqEnv, env, sig;
	freqEnv = EnvGen.kr(Env.new([envFreq1, envFreq2, envFreq3, envFreq4, envFreq5, envFreq6], [envTime1, envTime2, envTime3, envTime4, envTime5], curve, loopNode: loopNode));
	env = EnvGen.kr(Env.asr(attack, releaseTime: release), gate, gate, doneAction: doneAction);
	sig = LPF.ar(SinOsc.ar(freqEnv, mul: env), 20);
	OffsetOut.ar(out, Pan2.ar(sig, pan, Lag.kr(amp, 0.5)));
}).add;

)