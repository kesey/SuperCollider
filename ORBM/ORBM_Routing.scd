(

///////////////////////////////////////  Routing

var masterBus, limiterBus;

masterBus = Bus.audio(s, 2);
~master = Synth(\MasterStrip, [\in, masterBus], addAction: 'addToTail');

~channelNumber = 4; // number of channels
~channelNumber = ~channelNumber.max(1).min(16); // limit number of channels

~channelBus = Array.newClear(~channelNumber);

~channelNumber.do {
	arg i;
	~channelBus[i] = Bus.audio(s, 2);
	currentEnvironment.put((\channel ++ i).asSymbol, Synth(\ChannelStrip, [\in, ~channelBus[i], \out, masterBus]));
};

/*~inputMic = Synth(\InputSig, [\in, 0, \out, ~channelBus[1], \amp, 4, \attack, 6, \release, 3, \gate, 0, \doneAction, 0]);
~inputSoftPop = Synth(\InputSig, [\in, 2, \out, ~channelBus[1], \amp, 0.5, \attack, 6, \release, 3, \gate, 0, \doneAction, 0]);*/
s.bind { ~samplerStereo = Synth(\samplerStereo, [\out, ~channelBus[1], \gate, 0, \buffer, b[\Bowed_Empty_Sweep_Slow][15].bufnum, \startPos, 0.07, \rate, 0.04, \doneAction, 0]) };
s.bind { ~sinBass = Synth(\sinBass, [\out, ~channelBus[0], \gate, 0, \amp, 3.95, \doneAction, 0]) };
s.bind { ~reverb = Synth(\Reverb, [\in, ~aux1, \out, ~channelBus[2], \drywet, 1, \level, 0.75, \decaytimea, 5.79, \decaytimec, 0, \predelaytime, 7.63], ~master, 'addBefore') }; // s.bind consider server latency
s.bind { ~simpleDelay = Synth(\SimpleDelay, [\in, ~aux2, \out, ~channelBus[3], \delaytime, 1.36], ~master, 'addBefore') };

// s.meter; // level meter

)