(

///////////////////////////////////////  Song

~defaultSong = {
	{
		t.tempo = 60 / 60;
		~globalQuant = 1; // multiple of 5 for 5/4 signature
		~autoGuiControl.at("samplerStereo1019startPos").valueAction_(0.07);
		~autoGuiControl.at("samplerStereo1019rate").valueAction_(0.21);
		~autoGuiControl.at("samplerStereo1019attack").valueAction_(10);
		~autoGuiControl.at("samplerStereo1019release").valueAction_(2);
		~autoGuiControl.at("inputSig1018attack").valueAction_(6);
		~autoGuiControl.at("inputSig1018release").valueAction_(3);
	}.defer;
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
		20.0.wait;
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
		Pbindef(\unit7, \dur, Pseq([0.25, 0.75, Rest(1)], inf)).quant_(~globalQuant);
		2.0.wait;
		{
			~mute.at("unit1").valueAction_(1);
			~mute.at("unit3").valueAction_(1);
			~mute.at("unit5").valueAction_(1);
			~mute.at("unit6").valueAction_(1);
			~mute.at("unit8").valueAction_(1);
		}.defer;
		// t.sched(5, { t.tempo = 118 / 60 });
		Pbindef(\unit7, \dur, Pseq([0.125, 4.875], inf)).quant_(~globalQuant);
		~changePattern.value(Pdef(\unit2), ~defaultPattern9);
		~changePattern.value(Pdef(\unit4), ~defaultPattern10);
		{ ~mute.at("unit2").valueAction_(0); }.defer;
		20.0.wait;
		{
			~channel[\aux10].valueAction_(0.01);
			~channel[\aux21].valueAction_(0.45);
			~channel[\aux22].valueAction_(0.06);
			~channel[\aux13].valueAction_(0.05);
		}.defer;
		// Pbindef(\unit7, \dur, Pn(Pseq([Pn(0.125, 13), 0.1875, 0.0625, 0.25, 0.21875, 0.15625], 2))).quant_(~globalQuant);
		Pbindef(\unit7, \dur, Pseq([Pn(0.125, 32), 0.3125, 0.0625, 0.25, 0.21875, 0.15625], inf)).quant_(~globalQuant);
		// Pbindef(\unit7, \dur, Pseq([Pn(0.125, 30), 0.3125, 0.0625, 0.5, 0.21875, 0.15625], inf)).quant_(~globalQuant);
		38.0.wait;
		{ ~mute.at("unit7").valueAction_(1); }.defer;
		2.0.wait;
		{
			~mute.at("unit3").valueAction_(0);
			~mute.at("unit7").valueAction_(0);
			~channel[\aux13].valueAction_(0.01);
		}.defer;
		Pbindef(\unit3, \dur, 0.125, \amp, 0.015).quant_(~globalQuant);
		Pbindef(\unit7, \dur, Pn(Pconst(5, Pseq([2/6, 0.0625, 0.125, 0.25, 2/3, 1], inf)))).quant_(~globalQuant);
		20.0.wait;
		{
			~autoGuiControl.at("prayerBellunit2freq").valueAction_(838);
			~autoGuiControl.at("samplerStereounit4startPos").valueAction_(0.05);
			~autoGuiControl.at("t1kick2unit8pitch").valueAction_(0.5);
			~autoGuiControl.at("t1kick2unit8rel").valueAction_(6.71);
			~mute.at("unit8").valueAction_(0);
		}.defer;
		Pbindef(\unit8, \dur, 2.5, /*\timingOffset, 0.5*/).quant_(~globalQuant);
		20.0.wait;
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
			//~mute.at("unit3").valueAction_(0);
			~mute.at("unit5").valueAction_(0);
			~mute.at("unit6").valueAction_(0);
			//~mute.at("unit8").valueAction_(0);
			~channel[\aux10].valueAction_(0);
			~channel[\aux13].valueAction_(0);
			~channel[\aux21].valueAction_(0);
			~channel[\aux22].valueAction_(0);
		}.defer;
		2.0.wait;
	}
};

~song2 = {
	{
		t.tempo = 62 / 60;
		~globalQuant = 3; // multiple of 3 for 3/4 signature
		~autoGuiControl.at("samplerStereo1019buffer").valueAction_(38);
		~autoGuiControl.at("samplerStereo1019startPos").valueAction_(0);
		~autoGuiControl.at("samplerStereo1019rate").valueAction_(0.17);
		~autoGuiControl.at("samplerStereo1019release").valueAction_(2);
		~autoGuiControl.at("samplerStereo1019attack").valueAction_(0.1);
		~autoGuiControl.at("samplerStereo1019amp").valueAction_(0.7);

		~autoGuiControl.at("noiseInjection1016drywet").valueAction_(-0.84);
		~autoGuiControl.at("noiseInjection1016attack").valueAction_(0.01);
		~autoGuiControl.at("noiseInjection1016release").valueAction_(2.17);
		~autoGuiControl.at("noiseInjection1016noiseType").valueAction_(0);

		/*~mute.at("unit1").valueAction_(1);
		~mute.at("unit2").valueAction_(1);
		~mute.at("unit3").valueAction_(1);
		~mute.at("unit4").valueAction_(1);
		~mute.at("unit5").valueAction_(1);
		~mute.at("unit6").valueAction_(1);
		// ~mute.at("unit7").valueAction_(0);
		~mute.at("unit8").valueAction_(1);*/
	}.defer;
	loop {
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		~changePattern.value(Pdef(\unit3), ~song2Pattern3);
		~changePattern.value(Pdef(\unit4), ~song2Pattern9);
		~changePattern.value(Pdef(\unit5), ~song2Pattern5);
		~changePattern.value(Pdef(\unit6), ~song2Pattern6);
		~changePattern.value(Pdef(\unit7), ~song2Pattern7);
		~changePattern.value(Pdef(\unit8), ~song2Pattern11); // ~song2Pattern8
		12.0.wait;
		Pbindef(\unit5, \dur, Pseq([Rest(0.5), 0.125, 0.25, 0.5, 1.5, 0.125], inf)).quant_(~globalQuant);
		~changePattern.value(Pdef(\unit6), ~song2Pattern14); // 0.5 + 0.125 + 0.25 + 0.5 + 1.625 == 3
		12.0.wait;
		Pbindef(\unit1, \dur, Pseq([0.5, 0.25, Rest(0.75), 0.5, 0.75, 1, 0.75, 0.25, 0.5, 0.75], inf));
		~changePattern.value(Pdef(\unit8), ~song2Pattern13); // 0.5 + 0.25 + 0.75 + 0.5 + 0.75 + 1 + 0.75 + 0.25 + 0.5 + 0.75 == 6
		12.0.wait;
		~changePattern.value(Pdef(\unit2), ~song2Pattern15);
		6.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		6.0.wait;
		~changePattern.value(Pdef(\unit5), ~song2Pattern5);
		24.0.wait;
	}
};

)