(

///////////////////////////////////////  Song

~defaultSong = {
	loop {
		"~defaultSong says hello world".postln;
		~changePattern.value(Pdef(\unit1), ~defaultPattern1);
		~changePattern.value(Pdef(\unit2), ~defaultPattern2);
		~changePattern.value(Pdef(\unit3), ~defaultPattern3);
		~changePattern.value(Pdef(\unit4), ~defaultPattern4);
		~changePattern.value(Pdef(\unit5), ~defaultPattern5);
		~changePattern.value(Pdef(\unit6), ~defaultPattern6);
		~changePattern.value(Pdef(\unit7), ~defaultPattern7);
		~changePattern.value(Pdef(\unit8), ~defaultPattern8);
		16.0.wait;
		"~defaultSong says unit4 change dur".postln;
		Pbindef(\unit4, \dur, Pseq([1, 1.25, Rest(1), 1.5, Rest(2)]/2, inf)).quant_(~globalQuant);
		8.0.wait;
	}
};

~song2 = {
	loop {
		~changePattern.value(Pdef(\unit1), ~pattern1);
		~changePattern.value(Pdef(\unit2), ~pattern2);
		12.0.wait;
		~changePattern.value(Pdef(\unit1), ~pattern2);
		~changePattern.value(Pdef(\unit2), ~pattern1);
		16.0.wait;
		//TempoClock.default.sched(4, { TempoClock.default.tempo = 118 / 60 });
		~changePattern.value(Pdef(\unit1), ~pattern1);
		~changePattern.value(Pdef(\unit2), ~pattern2);
		8.0.wait;
	}
};

)