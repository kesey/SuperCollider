(

///////////////////////////////////////  Song

~song2 = Task.new({
	~changePattern.value(Pdef(\unit1), ~pattern1);
	~changePattern.value(Pdef(\unit2), ~pattern2);
	12.0.wait;
	~changePattern.value(Pdef(\unit1), ~pattern2);
	~changePattern.value(Pdef(\unit2), ~pattern1);
	16.0.wait;
	~changePattern.value(Pdef(\unit1), ~pattern1);
	~changePattern.value(Pdef(\unit2), ~pattern2);
}, TempoClock.default);

)