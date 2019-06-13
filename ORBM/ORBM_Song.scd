(

///////////////////////////////////////  Song

~defaultSong = {
	~samplerStereo.set(\startPos, 0.07, \rate, 0.21, \release, 2, \attack, 10);
	loop {
		~changePattern.value(Pdef(\unit1), ~defaultPattern1);
		~changePattern.value(Pdef(\unit6), ~defaultPattern6);
		8.0.wait;
		~changePattern.value(Pdef(\unit1), ~initPattern);
		2.0.wait;
		~changePattern.value(Pdef(\unit6), ~initPattern); // mute
		2.0.wait;
		~changePattern.value(Pdef(\unit1), ~defaultPattern1);
		~changePattern.value(Pdef(\unit6), ~defaultPattern6);
		~changePattern.value(Pdef(\unit2), ~defaultPattern2);
		8.0.wait;
		~changePattern.value(Pdef(\unit1), ~initPattern);
		2.0.wait;
		~changePattern.value(Pdef(\unit2), ~initPattern);
		~changePattern.value(Pdef(\unit6), ~initPattern);
		2.0.wait;
		~changePattern.value(Pdef(\unit1), ~defaultPattern1);
		~changePattern.value(Pdef(\unit2), ~defaultPattern2);
		~changePattern.value(Pdef(\unit3), ~defaultPattern3);
		~changePattern.value(Pdef(\unit4), ~defaultPattern4);
		~changePattern.value(Pdef(\unit5), ~defaultPattern5);
		~changePattern.value(Pdef(\unit6), ~defaultPattern6);
		~changePattern.value(Pdef(\unit7), ~defaultPattern7);
		~changePattern.value(Pdef(\unit8), ~defaultPattern8);
		24.0.wait;
		~changePattern.value(Pdef(\unit7), ~initPattern);
		4.0.wait;
		~changePattern.value(Pdef(\unit3), ~initPattern);
		~changePattern.value(Pdef(\unit7), ~defaultPattern7);
		8.0.wait;
		~changePattern.value(Pdef(\unit2), ~initPattern);
		4.0.wait;
		~changePattern.value(Pdef(\unit1), ~initPattern);
		~changePattern.value(Pdef(\unit4), ~initPattern);
		4.0.wait;
		~changePattern.value(Pdef(\unit5), ~initPattern);
		~changePattern.value(Pdef(\unit7), ~initPattern);
		6.0.wait;
		~changePattern.value(Pdef(\unit6), ~initPattern);
		~changePattern.value(Pdef(\unit8), ~initPattern);
		4.0.wait;
		~changePattern.value(Pdef(\unit1), ~defaultPattern1);
		~changePattern.value(Pdef(\unit2), ~defaultPattern2);
		~changePattern.value(Pdef(\unit3), ~defaultPattern3);
		~changePattern.value(Pdef(\unit4), ~defaultPattern4);
		~changePattern.value(Pdef(\unit5), ~defaultPattern5);
		~changePattern.value(Pdef(\unit6), ~defaultPattern6);
		~changePattern.value(Pdef(\unit7), ~defaultPattern7);
		~changePattern.value(Pdef(\unit8), ~defaultPattern8);
		Pbindef(\unit2, \note1, 76.9, \note2, 86.9).quant_(~globalQuant);
		Pbindef(\unit7, \freq, 515.69, \tu, 0.55, \pitch, 1.38).quant_(~globalQuant);
		Pbindef(\unit8, \snd, 17.95, \rel, 3.68, \pitch, 1.38).quant_(~globalQuant);
		36.0.wait;
	}
};

~song2 = {
	~samplerStereo.set(\startPos, 0, \rate, 0.03, \release, 2, \attack, 0.1);
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