(

///////////////////////////////////////  Song

n = 60; // Tempo in beat per minutes
t = TempoClock.default;
t.tempo = n / 60; // TempoClock by default in beat per seconds

~defaultSong = Task.new({
	~changePattern.value(Pdef(\unit1), ~defaultPattern1);
	~changePattern.value(Pdef(\unit2), ~defaultPattern2);
	~changePattern.value(Pdef(\unit3), ~defaultPattern3);
	~changePattern.value(Pdef(\unit4), ~defaultPattern4);
	~changePattern.value(Pdef(\unit5), ~defaultPattern5);
	~changePattern.value(Pdef(\unit6), ~defaultPattern6);
	~changePattern.value(Pdef(\unit7), ~defaultPattern7);
	~changePattern.value(Pdef(\unit8), ~defaultPattern8);
	16.0.wait;
	"Change in \unit4".debug("~defaultSong says");
	Pbindef(\unit4, \dur, Pseq([1, 1.25, Rest(1), 1.5, Rest(2)]/2, inf)).quant_(~globalQuant);
}, t);

~song2 = Task.new({
	"sequence 1".debug("~song2 says");
	~changePattern.value(Pdef(\unit1), ~pattern1);
	~changePattern.value(Pdef(\unit2), ~pattern2);
	12.0.wait;
	"sequence 2".debug("~song2 says");
	~changePattern.value(Pdef(\unit1), ~pattern2);
	~changePattern.value(Pdef(\unit2), ~pattern1);
	16.0.wait;
	"sequence 3".debug("~song2 says");
	//TempoClock.default.sched(4, { t.tempo = 118 / 60 });
	~changePattern.value(Pdef(\unit1), ~pattern1);
	~changePattern.value(Pdef(\unit2), ~pattern2);
}, t);

)