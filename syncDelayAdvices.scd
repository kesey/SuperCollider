(

SynthDef(\quadDelay, { arg in = 0, out = 0, delayamp1 = 0.5, delaypan1 = 0, sync1 = 0, delayamp2 = 0.5,  delaypan2 = 0, sync2 = 0, delayamp3 = 0.5, delaypan3 = 0, sync3 = 0, delayamp4 = 0.5, delaypan4 = 0, sync4 = 0, feedBack = 0.2, dryWet = 0.4, amp = 0.5;
	var input, delay, delay1, delay2, delay3, delay4, time1, time2, time3, time4, sig, tempoClock;
	input = In.ar(in, 2);
	delay = Mix.ar([input, LocalIn.ar(2)]);
	tempoClock = \tempoClock.kr(TempoClock.default.tempo);

	// delay 1
	time1 = Select.kr(sync1, [\delaytime1.kr(0.1), \division1.kr(1/8) / tempoClock]);
	delay1 = CombC.ar(delay, time1, Lag3.kr(time1));
	delay1 = Balance2.ar(delay1[0], delay1[1], delaypan1, delayamp1);

	// delay 2
	time2 = Select.kr(sync2, [\delaytime2.kr(0.4), \division2.kr(1/16) / tempoClock]);
	delay2 = CombC.ar(delay, time2, Lag3.kr(time2));
	delay2 = Balance2.ar(delay2[0], delay2[1], delaypan2, delayamp2);

	// delay 3
	time3 = Select.kr(sync3, [\delaytime3.kr(1.1), \division3.kr(1/6) / tempoClock]);
	delay3 = CombC.ar(delay, time3, Lag3.kr(time3));
	delay3 = Balance2.ar(delay3[0], delay3[1], delaypan3, delayamp3);

	// delay 4
	time4 = Select.kr(sync4, [\delaytime4.kr(2.3), \division4.kr(1/2) / tempoClock]);
	delay4 = CombC.ar(delay, time4, Lag3.kr(time4));
	delay4 = Balance2.ar(delay4[0], delay4[1], delaypan4, delayamp4);

	sig =  Mix.ar([delay1, delay2, delay3, delay4]);

	LocalOut.ar(sig * feedBack);
	sig = XFade2.ar(input, sig, dryWet, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\SimpleDelayNew, { arg in = 0, out = 0, sync = 0/*false*/, feedBack = 0.2, dryWet = 0.4, amp = 0.5;
    var input, delay, sig, time;
    input = In.ar(in, 2);
	delay = Mix.ar([input, LocalIn.ar(2)]);

	time = Select.kr(sync, [\delaytime.kr(1), \division.kr(1/8) / \tempoClock.kr(TempoClock.default.tempo)]);
	delay = CombC.ar(delay, time, Lag3.kr(time));

    LocalOut.ar(delay * feedBack);
	sig = XFade2.ar(input, delay, dryWet, amp);
	Out.ar(out, sig);
}).add;

)

(
var bus, updater;
bus = Bus.audio(s, 2);

~synth = Pbind(
	\instrument, \default,
	\dur, 0.01,
	\delta, 1,
	\amp, 0.7,
	\out, bus
).play;

~updateTempo = { arg synth, tempoClock;
	var updater;
	updater = SimpleController(tempoClock).put(\tempo, {
		synth.set(\tempoClock, tempoClock.tempo);
	})
	// clean up garbage when the clock is stopped
	.put(\stop, { updater.remove; });
};

//~fx = Synth(\SimpleDelayNew, [\in, bus], addAction: \addToTail);
~fx = Synth(\quadDelay, [\in, bus], addAction: \addToTail);
~updateTempo.value(~fx, TempoClock.default);

)
// \SimpleDelayNew
/*~fx.set(\sync, 1, \division1, 1/2, \dryWet, 0, \feedBack, 0.45, \amp, 1);
~fx.set(\sync, 0, \delaytime, 1/4, \division, 1/9, \dryWet, 0, \feedBack, 0.7, \amp, 1);*/
// \quadDelay
~fx.set(\sync1, 1, \sync2, 1, \sync3, 1, \sync4, 1, \division1, 1/2, \dryWet, 0, \feedBack, 0.2, \amp, 1);
~fx.set(\sync1, 0, \sync2, 0, \sync3, 0, \sync4, 0, \delaytime1, 1/4, \division1, 1/9, \dryWet, 0, \feedBack, 0.2, \amp, 1);
TempoClock.default.tempo = 2;
TempoClock.default.tempo = 1;
~synth.stop;
~synth.play;
TempoClock.default.stop;

//TempoClock.all.at(4).tempo;