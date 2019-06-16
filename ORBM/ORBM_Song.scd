(

///////////////////////////////////////  Song

~defaultSong = {
	~samplerStereo.set(\startPos, 0.07, \rate, 0.21, \release, 2, \attack, 10);
	loop {
		~changePattern.value(Pdef(\unit1), ~defaultPattern1);
		~changePattern.value(Pdef(\unit6), ~defaultPattern6);
		10.0.wait;
		{ ~mute.at("unit1").valueAction_(1); }.defer; // mute unit1 & update gui
		2.0.wait;
		{ ~mute.at("unit6").valueAction_(1); }.defer;
		2.0.wait;
		{
			~mute.at("unit1").valueAction_(0);
			~mute.at("unit6").valueAction_(0);
		}.defer;
		~changePattern.value(Pdef(\unit2), ~defaultPattern2);
		10.0.wait;
		{ ~mute.at("unit1").valueAction_(1); }.defer;
		2.0.wait;
		{
			~mute.at("unit2").valueAction_(1);
			~mute.at("unit6").valueAction_(1);
		}.defer;
		2.0.wait;
		{
			~mute.at("unit1").valueAction_(0);
			~mute.at("unit2").valueAction_(0);
			~mute.at("unit6").valueAction_(0);
		}.defer;
		~changePattern.value(Pdef(\unit1), ~defaultPattern1);
		~changePattern.value(Pdef(\unit2), ~defaultPattern2);
		~changePattern.value(Pdef(\unit3), ~defaultPattern3);
		~changePattern.value(Pdef(\unit4), ~defaultPattern4);
		~changePattern.value(Pdef(\unit5), ~defaultPattern5);
		~changePattern.value(Pdef(\unit6), ~defaultPattern6);
		~changePattern.value(Pdef(\unit7), ~defaultPattern7);
		~changePattern.value(Pdef(\unit8), ~defaultPattern8);
		25.0.wait;
		{ ~mute.at("unit1").valueAction_(1); }.defer;
		1.0.wait;
		{ ~mute.at("unit7").valueAction_(1); }.defer;
		1.0.wait;
		{ ~mute.at("unit3").valueAction_(1); }.defer;
		1.0.wait;
		{ ~mute.at("unit5").valueAction_(1); }.defer;
		1.0.wait;
		{
			~mute.at("unit2").valueAction_(1);
			~mute.at("unit4").valueAction_(1);
			~mute.at("unit6").valueAction_(1);
			~mute.at("unit8").valueAction_(1);

		}.defer;
		1.0.wait;
		{
			~channel[\aux10].valueAction_(0.02); // set SynthDef & update gui
			~channel[\aux11].valueAction_(0.25);
			~mute.at("unit1").valueAction_(0);
			~mute.at("unit3").valueAction_(0);
			~mute.at("unit4").valueAction_(0);
			~mute.at("unit5").valueAction_(0);
			~mute.at("unit6").valueAction_(0);
			~mute.at("unit7").valueAction_(0);
			~mute.at("unit8").valueAction_(0);

		}.defer;
		5.0.wait;
		{
			~channel[\aux21].valueAction_(0.5);
			~channel[\aux13].valueAction_(0.2);
		}.defer;
		15.0.wait;
		{ ~mute.at("unit7").valueAction_(1); }.defer;
		5.0.wait;
		{
			~mute.at("unit3").valueAction_(1);
			~mute.at("unit7").valueAction_(0);
		}.defer;
		10.0.wait;
		{
			~mute.at("unit1").valueAction_(1);
			~mute.at("unit4").valueAction_(1);
			~channel[\aux10].valueAction_(0);
			~channel[\aux11].valueAction_(0);
			~channel[\aux22].valueAction_(0.04);
		}.defer;
		2.5.wait;
		{
			~mute.at("unit5").valueAction_(1);
			~mute.at("unit7").valueAction_(1);
			~channel[\aux13].valueAction_(0);
		}.defer;
		5.0.wait;
		{
			~mute.at("unit6").valueAction_(1);
			~mute.at("unit8").valueAction_(1);
		}.defer;
		2.5.wait;
		{
			~channel[\aux21].valueAction_(0);
			~channel[\aux22].valueAction_(0);
			~mute.at("unit1").valueAction_(0);
			~mute.at("unit2").valueAction_(0);
			~mute.at("unit3").valueAction_(0);
			~mute.at("unit4").valueAction_(0);
			~mute.at("unit5").valueAction_(0);
			~mute.at("unit6").valueAction_(0);
			~mute.at("unit7").valueAction_(0);
			~mute.at("unit8").valueAction_(0);
		}.defer;
		/*~changePattern.value(Pdef(\unit1), ~defaultPattern1);
		~changePattern.value(Pdef(\unit2), ~defaultPattern2);
		~changePattern.value(Pdef(\unit3), ~defaultPattern3);
		~changePattern.value(Pdef(\unit4), ~defaultPattern4);
		~changePattern.value(Pdef(\unit5), ~defaultPattern5);
		~changePattern.value(Pdef(\unit6), ~defaultPattern6);
		~changePattern.value(Pdef(\unit7), ~defaultPattern7);
		~changePattern.value(Pdef(\unit8), ~defaultPattern8);*/
		{
			~autoGuiControl.at("IkedaBreathunit2note1").valueAction_(76.9);
			~autoGuiControl.at("IkedaBreathunit2note2").valueAction_(86.9);
			~autoGuiControl.at("kick2unit7freq").valueAction_(515.69);
			~autoGuiControl.at("kick2unit7tu").valueAction_(0.55);
			~autoGuiControl.at("t1kick2unit8snd").valueAction_(17.95);
			~autoGuiControl.at("t1kick2unit8rel").valueAction_(3.68);
			~autoGuiControl.at("t1kick2unit8pitch").valueAction_(1.38);
		}.defer;
		40.0.wait;
		Pbindef(\unit7, \dur, 0.125).quant_(~globalQuant);
		8.0.wait;
		{ ~mute.at("unit7").valueAction_(1); }.defer;
		2.0.wait;
		{
			~mute.at("unit7").valueAction_(0);
			~mute.at("unit2").valueAction_(1);
		}.defer;
		8.0.wait;
		Pbindef(\unit7, \dur, Pseq([1, 1.125, 0.5], inf)).quant_(~globalQuant);
		2.0.wait;
		{
			~mute.at("unit1").valueAction_(1);
			~mute.at("unit3").valueAction_(1);
			~mute.at("unit5").valueAction_(1);
			~mute.at("unit6").valueAction_(1);
			~mute.at("unit8").valueAction_(1);
		}.defer;
		Pbindef(\unit7, \dur, 0.125).quant_(~globalQuant);
		~changePattern.value(Pdef(\unit2), ~defaultPattern9);
		~changePattern.value(Pdef(\unit4), ~defaultPattern10);
		{ ~mute.at("unit2").valueAction_(0); }.defer;
		18.0.wait;
		{ ~mute.at("unit7").valueAction_(1); }.defer;
		2.0.wait;
		{
			~channel[\aux10].valueAction_(0.01);
			~channel[\aux21].valueAction_(0.45);
			~channel[\aux22].valueAction_(0.14);
			~channel[\aux13].valueAction_(0.05);
		}.defer;
		{ ~mute.at("unit7").valueAction_(0); }.defer;
		10.do({
			Pbindef(\unit7, \dur, 0.125).quant_(~globalQuant);
			4.0.wait;
			Pbindef(\unit7, \dur, Pseq([0.0625, 0.125, 0.125, 0.25, 2/3], inf)).quant_(~globalQuant);
			1.0.wait;
		});
		~changePattern.value(Pdef(\unit1), ~initPattern);
		~changePattern.value(Pdef(\unit2), ~initPattern);
		~changePattern.value(Pdef(\unit3), ~initPattern);
		~changePattern.value(Pdef(\unit4), ~initPattern);
		~changePattern.value(Pdef(\unit5), ~initPattern);
		~changePattern.value(Pdef(\unit6), ~initPattern);
		~changePattern.value(Pdef(\unit7), ~initPattern);
		~changePattern.value(Pdef(\unit8), ~initPattern);
		{
			~mute.at("unit1").valueAction_(0);
			~mute.at("unit3").valueAction_(0);
			~mute.at("unit5").valueAction_(0);
			~mute.at("unit6").valueAction_(0);
			~mute.at("unit8").valueAction_(0);
			~channel[\aux10].valueAction_(0);
			~channel[\aux21].valueAction_(0);
			~channel[\aux22].valueAction_(0);
			~channel[\aux13].valueAction_(0);
		}.defer;
	}
};

~song2 = {
	{
		~autoGuiControl.at("samplerStereostartPos").valueAction_(0);
		~autoGuiControl.at("samplerStereorate").valueAction_(0.03);
		~autoGuiControl.at("samplerStereorelease").valueAction_(2);
		~autoGuiControl.at("samplerStereoattack").valueAction_(0.1);
	}.defer;
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