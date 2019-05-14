(

///////////////////////////////////////  Noise

~ikedaBreathSynthDef = SynthDef(\IkedaBreath, { arg out = 0, t_trig = 0, note1 = 44, note2 = 90, amp1 = 0.5, amp2 = 0.6, lpfFreq = 103.82, hpfFreq = 2400, attack = 0.0001, decay = 0.4, release = 0.01, pan = 0, level = 1;
	var sin, lpf, hpf, sig;
	sin = SinOsc.ar(note1.midicps, 0, amp1) + SinOsc.ar(note2.midicps, 0, amp2);
	lpf = LPF.ar(sin, lpfFreq.max(1));
	hpf = HPF.ar(LPF.ar(WhiteNoise.ar(0.008), 12000), hpfFreq.max(1));
	sig = (lpf + hpf) * EnvGen.kr(Env(#[0, 1, 0.6, 0], [attack, decay, release]), t_trig, doneAction:2); // # makes a totally fixed (non-dynamic) Array and is slightly cheaper, especially where you're not going to change the Array once you make it
	OffsetOut.ar(out, Pan2.ar(sig, pan, level));
}).add;

SynthDef(\noise2,{arg out = 0,rel  = 0.01,a=4;
var env0 =  EnvGen.ar(Env.new([0.1, 1, 0.3, 0], [0.01, rel], [-4, -2, -4]), doneAction:2);
var sig = CuspN.ar(
		SampleRate.ir/a,
		LFNoise2.kr([4,4],1.5,1.5),
		LFNoise2.kr([2,2],1.5,1.5),
		LFNoise2.kr([2,2],0.5,1.5),
		LFNoise2.kr([2,2],0.5,1.5);
	);
	sig = HPF.ar(sig,1000);
	sig = Limiter.ar(sig,0.4);
	sig =	[sig ,DelayL.ar(sig,0.1,100/44100)];
	//sig = PitchShift.ar(sig,0.2,1*a);
	sig = Compander.ar(sig,In.ar(0,1),0.01,1,0.01,0.01,0.1);
	sig=  sig.tanh;
	OffsetOut.ar(out,sig*env0);
}).add;

SynthDef(\noise2new,{arg out = 0, rel = 1, a = 0.2, pan = 0, del1 = 10, del2 = 20;
	var env, sig;
	env =  EnvGen.ar(Env.new([0.1, 1, 0.3, 0], [0.01, rel], [-4, -2, -4]), doneAction:2);
	sig = CuspN.ar(
        SampleRate.ir/a,
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
    OffsetOut.ar(4, sig * env);
}).add;

SynthDef(\noise,{arg out =0,rel  = 0.25,a=4;
var env0 =  EnvGen.ar(Env.new([0.1, 1, 0.3, 0], [0.01, rel], [-4, -2, -4]), doneAction:2);
var sig = LatoocarfianL.ar(
		SampleRate.ir/a,
		LFNoise2.kr([2,2],1.5,1.5),
		LFNoise2.kr([2,2],1.5,1.5),
		LFNoise2.kr([2,2],0.5,1.5),
		LFNoise2.kr([2,2],0.5,1.5);
	);
	sig = HPF.ar(sig,1000);
	sig = Limiter.ar(sig,0.4);
	sig =	[sig ,DelayL.ar(sig,0.1,100/44100)];
	//sig = PitchShift.ar(sig,0.2,1*a);
	sig = Compander.ar(sig,In.ar(0,1),0.01,1,0.01,0.01,0.1);
	sig=  sig.tanh;
	OffsetOut.ar(out,sig*env0);
}).add;

/*SynthDef(\test,{arg note=16, bufoffset=0,phase=0,gate=1;
    var env = EnvGen.ar(Env.adsr(1,1,1,1),gate,doneAction:2);
    var detune = VarSaw.ar(t.tempo/8,bufoffset,phase,20,20);
    var freq = (note *(432.cpsmidi/69)).midicps;
    var sig =
    SinOsc.ar([freq,freq+0.5]+(detune),phase+0.4)+
    LFTri.ar([freq,freq+0.5]+(detune),phase+0.3)+
    LFTri.ar([freq,freq+0.5]+(detune),phase+0.2)+
    LFTri.ar([freq,freq+0.5]+(detune),phase+0.1);
//    x = MouseX.kr(0,7);
    sig =Compander.ar(sig,In.ar(6,1)+In.ar(7,1),-22.dbamp,1,0.6,0.3,1,1);
    //sig =   VOsc.ar(bufoffset+x, [freq,freq], 0, 1)+sig;
   //  sig = (sig/7);//;
    //sig = FreeVerb.ar(sig,0.5,0.5)+sig;
    sig =  HPF.ar(sig,200)*env;
    sig =     LeakDC.ar(sig*0.5);
    OffsetOut.ar(0,sig);
}).add;*/

SynthDef(\cosc,{arg gate = 1, amp=1, out=0,rel=0.1,pan=0,freq=512;
    var env2 = EnvGen.ar(Env.adsr(0.5,1,1,0),gate,doneAction:2);
    var env = EnvGen.ar(Env.adsr(0.5,1,1,0),gate);
    var sig = COsc.ar(80,[freq,freq+0.5], 1, 0.1);
    sig  = sig + COsc.ar(80,[freq,freq+0.5]*2, 1, 0.1);
    sig = FreeVerb.ar(sig*env,1);
    sig = LeakDC.ar(sig);
    OffsetOut.ar(0,sig*amp);
}).add;

SynthDef(\noiseInjection, { arg in = 0, out = 0, attack = 0.01, release = 0.01, noiseType = 0, amp = 0.5;
	var input, sig, inputAmp;
	input = In.ar(in, 2);
	inputAmp = Amplitude.kr(input, attack, release);
	noiseType = noiseType.max(0).min(4);
	sig = Select.ar(noiseType, [WhiteNoise.ar(inputAmp), BrownNoise.ar(inputAmp), GrayNoise.ar(inputAmp), PinkNoise.ar(inputAmp), ClipNoise.ar(inputAmp)]);
	Out.ar(out, sig * amp);
}).add;

)