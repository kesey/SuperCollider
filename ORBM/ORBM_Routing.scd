(

///////////////////////////////////////  Routing

var masterBus, limiterBus;

masterBus = Bus.audio(s, 2);
~master = Synth(\MasterStrip, [\in, masterBus], addAction: 'addToTail');

~channelNumber = 4; // number of channels

~channelBus = Array.newClear(~channelNumber);

~channelNumber.do {
	arg i;
	~channelBus[i] = Bus.audio(s, 2);
	currentEnvironment.put((\channel ++ i).asSymbol, Synth(\ChannelStrip, [\in, ~channelBus[i], \out, masterBus]));
};

/*s.bind { Synth(\InputSig, [\in, 0, \out, ~channelBus[1], \amp, 4, \attack, 6, \release, 3]) };
s.bind { Synth(\InputSig, [\in, 2, \out, ~channelBus[1], \amp, 0.5, \attack, 6, \release, 3]) };*/
~sampler = s.bind { Synth(\sampler, [\out, ~channelBus[1], \buffer, b[\Bowed_Empty_Sweep_Slow][0].bufnum, \gate, 0]) };
s.bind { Synth(\Reverb, [\in, ~aux1, \out, ~channelBus[2]], ~master, 'addBefore') }; // s.bind consider server latency
s.bind { Synth(\SimpleDelay, [\in, ~aux2, \out, ~channelBus[3]], ~master, 'addBefore') };

s.meter; // level meter

)