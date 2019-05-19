(

///////////////////////////////////////  Song

n = 60; // Tempo in beat per minutes
TempoClock.default.tempo = n / 60; // TempoClock by default in beat per seconds
t = TempoClock((n * 2) / 60); // Another TempoClock twice as fast as the TempoClock default

~song2 = Task.new({
	~changePattern.value(Pdef(\unit1), ~pattern1);
	~changePattern.value(Pdef(\unit2), ~pattern2);
	12.0.wait;
	~changePattern.value(Pdef(\unit1), ~pattern2);
	~changePattern.value(Pdef(\unit2), ~pattern1);
	16.0.wait;
	//TempoClock.default.sched(4, { TempoClock.default.tempo = 118 / 60 });
	~changePattern.value(Pdef(\unit1), ~pattern1);
	~changePattern.value(Pdef(\unit2), ~pattern2);
}, TempoClock.default);

)