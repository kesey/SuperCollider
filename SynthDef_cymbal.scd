(

///////////////////////////////////////  Cymbal

SynthDef(\cym, { arg out=0,tu=1, amp=0.5, pan=0,rel=1;
	var sig;
	var env = EnvGen.ar(Env.perc(0,rel,1,-8),doneAction:2);
	var
	freqs= geom(100,50,1.3434)*10.234567*tu;
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig,freqs,1).mean;
	sig = Pan2.ar(sig*env, pan, amp);
	OffsetOut.ar(out, sig*amp);
}).add;

SynthDef(\cymnew, { arg out=0,tu=6, amp=0.5, pos=0,rel=4;
    var sig;
    var env = EnvGen.ar(Env.perc(0,rel,1,-8),doneAction:2);
    var
    freqs= geom(99,40,pi/3)*10.234567*tu;
    sig = WhiteNoise.ar;
    sig = Ringz.ar(sig,freqs,1).mean;
    sig = sig *env;

    //sig = Pan2.ar(sig*env, pos, amp);
    OffsetOut.ar(out, sig*amp*0.2);
}).add;

)