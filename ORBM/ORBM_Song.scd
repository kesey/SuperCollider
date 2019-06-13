(

///////////////////////////////////////  Song

~defaultSong = {
	loop {
		~changePattern.value(Pdef(\unit1), ~defaultPattern1);
		~changePattern.value(Pdef(\unit2), ~defaultPattern2);
		~changePattern.value(Pdef(\unit3), ~defaultPattern3);
		~changePattern.value(Pdef(\unit4), ~defaultPattern4);
		~changePattern.value(Pdef(\unit5), ~defaultPattern5);
		~changePattern.value(Pdef(\unit6), ~defaultPattern6);
		~changePattern.value(Pdef(\unit7), ~defaultPattern7);
		~changePattern.value(Pdef(\unit8), ~defaultPattern8);
		16.0.wait;
		Pbindef(\unit2, \note1, 76.9, \note2, 86.9).quant_(~globalQuant);
		Pbindef(\unit7, \freq, 515.69, \tu, 0.55, \pitch, 1.38).quant_(~globalQuant);
		Pbindef(\unit8, \snd, 17.95, \rel, 3.68, \pitch, 1.38).quant_(~globalQuant);
		24.0.wait;
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