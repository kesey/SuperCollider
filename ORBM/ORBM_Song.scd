(

///////////////////////////////////////  Song

~defaultSong = { // ~globalQuant = 1; // !!! change globalQuant before song !!!
	t.tempo = 60 / 60;
	{
		~autoGuiControl.at("samplerStereo1020startPos").valueAction_(0.07);
		~autoGuiControl.at("samplerStereo1020rate").valueAction_(0.21);
		~autoGuiControl.at("samplerStereo1020attack").valueAction_(10);
		~autoGuiControl.at("samplerStereo1020release").valueAction_(2);

		~autoGuiControl.at("inputSig1019attack").valueAction_(6);
		~autoGuiControl.at("inputSig1019release").valueAction_(3);
	}.defer;
	~songInit.value;
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
		~songInit.value;
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

~song2 = { // ~globalQuant = 4; // !!! change globalQuant before song !!!
	t.tempo = 82 / 60;
	{
		~autoGuiControl.at("samplerStereo1020buffer").valueAction_(22);
		~autoGuiControl.at("samplerStereo1020startPos").valueAction_(0.3);
		~autoGuiControl.at("samplerStereo1020rate").valueAction_(0.27);
		~autoGuiControl.at("samplerStereo1020release").valueAction_(1.47);
		~autoGuiControl.at("samplerStereo1020attack").valueAction_(2.11);
		~autoGuiControl.at("samplerStereo1020amp").valueAction_(0.8);

		~autoGuiControl.at("noiseInjection1017drywet").valueAction_(-0.84);
		~autoGuiControl.at("noiseInjection1017attack").valueAction_(0.01);
		~autoGuiControl.at("noiseInjection1017release").valueAction_(2.17);
		~autoGuiControl.at("noiseInjection1017noiseType").valueAction_(0);
		~mute.at("unit7").valueAction_(1);
	}.defer;
	~songInit.value;
	loop {
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		~changePattern.value(Pdef(\unit3), ~song2Pattern3);
		~changePattern.value(Pdef(\unit4), ~song2Pattern4);
		~changePattern.value(Pdef(\unit5), ~song2Pattern5);
		~changePattern.value(Pdef(\unit6), ~song2Pattern6);
		~changePattern.value(Pdef(\unit7), ~song2Pattern7);
		~changePattern.value(Pdef(\unit8), ~song2Pattern8);
		16.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern10);
		~changePattern.value(Pdef(\unit2), ~song2Pattern9);
		4.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		Pbindef(\unit1, // change key value (synchro whith changePattern)
			\amp, 0.8,
			\tu, 0.75,
			\envL1, 0.62,
			\envL2, 0.01,
			\envL3, 0.69,
			\envT1, 0.44,
			\envT2, 0.17,
			\envfL1, 245,
			\envfL2, 270,
			\envfL3, 120,
			\envfT1, 0.18,
			\envfT2, 0.29,
			\envfT3, 1,
		).quant_(~globalQuant);
		8.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern10);
		~changePattern.value(Pdef(\unit2), ~song2Pattern9);
		4.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		8.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern10);
		~changePattern.value(Pdef(\unit2), ~song2Pattern9);
		Pbindef(\unit6,
			\amp, 0.065,
			\att, 0.26,
			\rel, 0.01,
			\ffreq, 7948
		).quant_(~globalQuant);
		Pbindef(\unit2,
			\release, Pseq([0.6, 0.3, 0.42, 0.16, 0.5, 0.42, 0.16, 0.7], inf),
			\freq, 0.01,
			\dur, Pseq([0.125, 0.125, 0.5, 0.25], inf) // 0.125+ 0.125+ 0.5+ 0.25 == 1
		).quant_(~globalQuant);
		8.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		~changePattern.value(Pdef(\unit3), ~song2Pattern12);
		~changePattern.value(Pdef(\unit6), ~song2Pattern6);
		28.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern10);
		~changePattern.value(Pdef(\unit2), ~song2Pattern9);
		4.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern1);
		~changePattern.value(Pdef(\unit2), ~song2Pattern2);
		~changePattern.value(Pdef(\unit4), ~song2Pattern11);
		Pbindef(\unit6,
			\amp, 0.065,
			\att, 0.26,
			\rel, 0.01,
			\ffreq, 7948
		).quant_(~globalQuant);
		Pbindef(\unit1,
			\amp, 0.8,
			\tu, 0.75,
			\envL1, 0.62,
			\envL2, 0.01,
			\envL3, 0.69,
			\envT1, 0.44,
			\envT2, 0.17,
			\envfL1, 245,
			\envfL2, 270,
			\envfL3, 120,
			\envfT1, 0.18,
			\envfT2, 0.29,
			\envfT3, 1,
		).quant_(~globalQuant);
		12.0.wait;
		~changePattern.value(Pdef(\unit1), ~song2Pattern10);
		~changePattern.value(Pdef(\unit2), ~song2Pattern9);
		Pbindef(\unit2,
			\release, Pseq([0.6, 0.3, 0.42, 0.16, 0.5, 0.42, 0.16, 0.7], inf),
			\freq, 0.01,
			\dur, Pseq([0.125, 0.125, 0.5, 0.25], inf) // 0.125+ 0.125+ 0.5+ 0.25 == 1
		).quant_(~globalQuant);
		4.0.wait;
	}
};

~song3 = {// ~globalQuant = 7; // !!! change globalQuant before song !!!
	t.tempo = 142 / 60;
	{
		~autoGuiControl.at("samplerStereo1020amp").valueAction_(1);
		~autoGuiControl.at("samplerStereo1020attack").valueAction_(2.11);
		~autoGuiControl.at("samplerStereo1020release").valueAction_(1);
		~autoGuiControl.at("samplerStereo1020buffer").valueAction_(2);
		~autoGuiControl.at("samplerStereo1020rate").valueAction_(0.2);
		~autoGuiControl.at("samplerStereo1020startPos").valueAction_(0.08);

		~autoGuiControl.at("sinBass1021amp").valueAction_(0.4);
		~autoGuiControl.at("sinBass1021attack").valueAction_(0.2);
		~autoGuiControl.at("sinBass1021release").valueAction_(4);
		~autoGuiControl.at("sinBass1021envLevel1").valueAction_(0);
		~autoGuiControl.at("sinBass1021envLevel2").valueAction_(28);
		~autoGuiControl.at("sinBass1021envLevel3").valueAction_(64);
		~autoGuiControl.at("sinBass1021envLevel4").valueAction_(16);
		~autoGuiControl.at("sinBass1021envLevel5").valueAction_(48.3);
		~autoGuiControl.at("sinBass1021envLevel6").valueAction_(37.5);
		~autoGuiControl.at("sinBass1021envTime1").valueAction_(0.1);
		~autoGuiControl.at("sinBass1021envTime2").valueAction_(0.3);
		~autoGuiControl.at("sinBass1021envTime3").valueAction_(0.5);
		~autoGuiControl.at("sinBass1021envTime4").valueAction_(0.39);
		~autoGuiControl.at("sinBass1021envTime5").valueAction_(0.14);

		~autoGuiControl.at("quadDelay1013drywet").valueAction_(0.4);
		~autoGuiControl.at("quadDelay1013feedBack").valueAction_(0.2);
		~autoGuiControl.at("quadDelay1013sync1").valueAction_(1);
		~autoGuiControl.at("quadDelay1013sync2").valueAction_(1);
		~autoGuiControl.at("quadDelay1013sync3").valueAction_(1);
		~autoGuiControl.at("quadDelay1013sync4").valueAction_(1);
		~autoGuiControl.at("quadDelay1013amp4").valueAction_(0);

		~autoGuiControl.at("pitchShifter1012drywet").valueAction_(0.7);
		~autoGuiControl.at("pitchShifter1012pitchRatio").valueAction_(0.11);
		~autoGuiControl.at("pitchShifter1012pitchDisper").valueAction_(0);
		~autoGuiControl.at("pitchShifter1012timeDisper").valueAction_(0.02);

		~autoGuiControl.at("flanging1011drywet").valueAction_(-0.02);
		~autoGuiControl.at("flanging1011fgfreq").valueAction_(2);
		~autoGuiControl.at("flanging1011fdback").valueAction_(0.12);

		~autoGuiControl.at("verb1010drywet").valueAction_(0);

		~channel.at(\level2).valueAction_(0.08);
	}.defer;
	Pdefn(\kickNoisePatt, Pseq([1.375, Rest(1.75), 1.75, 0.875, 1.25/**/, 1.375, Rest(0.875), 0.875, 1.75, Rest(0.875), 1.25], inf));
	~songInit.value;
	loop {
		~changePattern.value(Pdef(\unit1), ~song3Pattern1);
		~changePattern.value(Pdef(\unit2), ~song3Pattern2);
		~changePattern.value(Pdef(\unit3), ~song3Pattern3);
		~changePattern.value(Pdef(\unit4), ~song3Pattern4);
		~changePattern.value(Pdef(\unit5), ~song3Pattern5);
		~changePattern.value(Pdef(\unit6), ~song3Pattern6);
		~changePattern.value(Pdef(\unit7), ~song3Pattern7);
		~changePattern.value(Pdef(\unit8), ~song3Pattern8);
		56.0.wait;
		Pbindef(\unit1,
			\dur, Pseq([Rest(0.875), 2.625, Rest(1.75), 1.75/**/, Rest(0.875), 0.875, 1.75, 2.625, Rest(0.875)], inf)
		).quant_(~globalQuant);
		Pbindef(\unit2,
			\dur, Pseq([Rest(1.75), 0.875, 3.5, Rest(0.875)], inf)
		).quant_(~globalQuant);
		Pbindef(\unit3,
			\dur, Pseq([Rest(1.75), 1.75, Rest(1.25), 0.4375, Rest(1.375), 0.4375], inf), // 1.75+ 1.75+ 1.25+ 0.4375+ 1.375+ 0.4375 == 7
			\att, 0.17
		).quant_(~globalQuant);
		~resetControlBus.value("unit3att");
		~changePattern.value(Pdef(\unit6), ~song3Pattern9);
		Pbindef(\unit6,
			\attack, 0,
			\amp, 0.27,
			\sustain, 0.14,
			\release, 0,
			\curve, 4.76,
			\clipLevel, 0,
			\impFreq, Pseq([15, 8, 12], inf),
			\impPhase, 0,
			\impLevel, 3.99,
			\noiseLevel, 0.3,
			\eqfreq, Pseg([765, 2242, 12875], [0.2, 0.55], \exp, inf),
			\eqrq, 0.74,
			\eqdb, -60
		).quant_(~globalQuant);
		~resetControlBus.value("unit6");
		Pbindef(\unit7,
			\dur, Pseq([0.875, Rest(0.21875), 1.75, 0.21875, 0.4375], inf), // 0.875+ 0.4375+ 0.21875+ 0.21875+ 1.75
			\release, Pseq([0.01, 0.02, 0.01, 0.02, 0.03], inf),
		).quant_(~globalQuant);
		~resetControlBus.value("unit7release");
		28.0.wait;
		~changePattern.value(Pdef(\unit1), ~song3Pattern1);
		~changePattern.value(Pdef(\unit3), ~song3Pattern3);
		~changePattern.value(Pdef(\unit6), ~song3Pattern6);
		~changePattern.value(Pdef(\unit7), ~song3Pattern7);
		28.0.wait;
		Pbindef(\unit1,
			\dur, Pseq([2.625, 1.75, Rest(0.875), 0.875, Rest(0.875)/**/, Rest(0.875), 2.625, 1.75, 0.875, Rest(0.875)], inf) // 0.875+ 0.4375+ 0.21875+ 0.21875+ 1.75
		).quant_(~globalQuant);
		Pbindef(\unit2,
			\dur, Pseq([1.75, 3.5, Rest(0.875), Rest(0.875)], inf)
		).quant_(~globalQuant);
		Pbindef(\unit3,
			\dur, Pseq([Rest(0.875), 1.75, 0.875, 1.25, Rest(0.875), 1.375/**/, Rest(0.875), 1.75, 1.25, Rest(1.75), 1.375]/2, inf), // 0.875+ 0.875+ 1.75+ 1.25+ 1.375+ 0.875 == 7
			\att, 0.17
		).quant_(~globalQuant);
		~resetControlBus.value("unit3att");
		~changePattern.value(Pdef(\unit4), ~song3Pattern9);
		Pbindef(\unit4,
			\dur, Pwrand([1.75, Rest(1.75), 3.5, Rest(3.5)], [0.3, 0.3, 0.3, 0.1].normalizeSum, inf),
			\amp, 0.3,
			\attack, 1.6,
			\sustain, 0,
			\release, 0,
			\curve, 3.31,
			\clipLevel, 0.02,
			\impFreq, Pseq([8000, 34, 8000], inf),
			\impPhase, 0,
			\impLevel, Pseq([0.15, 0.75, 0.15], inf),
			\noiseLevel, 0,
			\eqfreq, 163150,
			\eqrq, 0.73,
			\eqdb, 30.99
		).quant_(~globalQuant);
		~resetControlBus.value("unit4");
		Pbindef(\unit6, \dur, Pseq([1.75, 0.875], inf)).quant_(~globalQuant);
		Pbindef(\unit7,
			\dur, Pseq([0.875, Rest(0.21875), 0.4375, 0.21875, 1.75/**/, 1.75, 0.875, Rest(0.21875), 0.21875, 0.4375], inf) // 0.875+ 0.4375+ 0.21875+ 0.21875+ 1.75
		).quant_(~globalQuant);
		28.0.wait;
		Pbindef(\unit3,
			\dur, Pseq([Rest(0.875), 0.875, Rest(0.875), 1.375, 0.875, 1.25, 0.875], inf) // 0.875+ 0.875+ 0.875+ 1.375+ 0.875+ 1.25+ 0.875 == 7
		).quant_(~globalQuant);
		Pbindef(\unit4,
			\attack, 0,
			\amp, 0.3,
			\sustain, 0.14,
			\release, 0,
			\curve, 4.76,
			\clipLevel, 0,
			\impFreq, Pseq([15, 8, 12], inf),
			\impPhase, 0,
			\impLevel, 3.99,
			\noiseLevel, 0.3,
			\eqfreq, Pseg([765, 2242, 12875], [0.2, 0.55], \exp, inf),
			\eqrq, 0.74,
			\eqdb, -60
		).quant_(~globalQuant);
		~resetControlBus.value("unit4");
		Pbindef(\unit7,
			\dur, Pseq([1.75, 0.875, Rest(0.21875), 0.21875, 0.4375], inf) // 0.875+ 0.4375+ 0.21875+ 0.21875+ 1.75
		).quant_(~globalQuant);
		14.0.wait;
		Pbindef(\unit3,
			\dur, Pseq([Rest(0.875), 1.75, Rest(0.875), 1.25, Rest(0.875), 1.375]/2, inf), // 0.875+ 1.75+ 0.875+ 1.25+ 0.875+ 1.375 == 7
		).quant_(~globalQuant);
		~changePattern.value(Pdef(\unit4), ~song3Pattern9);
		Pbindef(\unit4,
			\dur, Pwrand([3.5, 7], [0.7, 0.3].normalizeSum, inf),
			\attack, 1.32,
			\sustain, 0.01,
			\release, 0.09,
			[\impFreq, \impLevel], Pseq([[15, 1.7], [8000, 0.25], [8, 1.7], [8000, 0.25], [12, 1.7], [8, 1.7]], inf),
			\impPhase, 0,
			\noiseLevel, 0.2,
			\eqfreq, 367
		).quant_(~globalQuant);
		~resetControlBus.value("unit4");
		~changePattern.value(Pdef(\unit5), ~song3Pattern11);
		Pbindef(\unit5,
			\dur, 14,
			\amp, 0.03,
			\att, 5.8,
			\revMix, 0,
			\freq, 37,
			\rel, 0
		).quant_(~globalQuant);
		~resetControlBus.value("unit5");
		14.0.wait;
		~changePattern.value(Pdef(\unit1), ~song3Pattern1);
		~changePattern.value(Pdef(\unit2), ~song3Pattern2);
		~changePattern.value(Pdef(\unit3), ~song3Pattern3);
		~changePattern.value(Pdef(\unit5), ~song3Pattern11);
		~changePattern.value(Pdef(\unit6), ~song3Pattern6);
		~changePattern.value(Pdef(\unit7), ~song3Pattern7);
		56.0.wait;
		Pbindef(\unit1,
			\dur, Pseq([Rest(0.875), 2.625, 0.875, Rest(0.875), 1.75], inf) // 0.875+ 0.4375+ 0.21875+ 0.21875+ 1.75
		).quant_(~globalQuant);
		Pbindef(\unit2,
			\dur, Pseq([Rest(1.75), 3.5, 0.875, Rest(0.875)], inf)
		).quant_(~globalQuant);
		Pbindef(\unit3,
			\dur, Pseq([Rest(0.875), 0.875, 1.75, 1.25, 1.375, 0.875], inf), // 0.875+ 0.875+ 1.75+ 1.25+ 1.375+ 0.875 == 7
			\att, 0.17
		).quant_(~globalQuant);
		~resetControlBus.value("unit3att");
		~changePattern.value(Pdef(\unit6), ~song3Pattern9);
		Pbindef(\unit6,
			\dur, Pwrand([1.75, Rest(1.75), 3.5, Rest(3.5)], [0.2, 0.4, 0.3, 0.1].normalizeSum, inf),
			\attack, 0,
			\amp, 0.3,
			\sustain, 0.14,
			\release, 0,
			\curve, 4.76,
			\clipLevel, 0,
			\impFreq, Pseq([15, 8, 12], inf),
			\impPhase, 0,
			\impLevel, 3.99,
			\noiseLevel, 0.3,
			\eqfreq, Pseg([765, 2242, 12875], [0.2, 0.55], \exp, inf),
			\eqrq, 0.74,
			\eqdb, -60
		).quant_(~globalQuant);
		~resetControlBus.value("unit6");
		Pbindef(\unit7,
			\dur, Pseq([0.875, Rest(0.21875), 1.75, 0.21875, 0.4375], inf), // 0.875+ 0.4375+ 0.21875+ 0.21875+ 1.75
			\release, Pseq([0.01, 0.02, 0.01, 0.02, 0.03], inf),
		).quant_(~globalQuant);
		~resetControlBus.value("unit7release");
		28.0.wait;
		~changePattern.value(Pdef(\unit2), ~song3Pattern2);
		Pbindef(\unit3,
			\dur, Pseq([1.375, Rest(0.875), 0.875, 1.75, 0.875, 1.25], inf),
			\amp, 0.005
		).quant_(~globalQuant);
		~resetControlBus.value("unit3amp");
		~changePattern.value(Pdef(\unit6), ~song3Pattern6);
		28.0.wait;
		~changePattern.value(Pdef(\unit1), ~initPattern);
		~changePattern.value(Pdef(\unit3), ~initPattern);
		~changePattern.value(Pdef(\unit4), ~initPattern);
		~changePattern.value(Pdef(\unit5), ~initPattern);
		~changePattern.value(Pdef(\unit6), ~initPattern);
		~changePattern.value(Pdef(\unit8), ~initPattern);
		28.0.wait;
		~changePattern.value(Pdef(\unit1), ~song3Pattern1);
		Pbindef(\unit1,
			\dur, Pseq([Rest(0.875), 2.625, 0.875, Rest(0.875), 1.75], inf) // 0.875+ 2.625+ 0.875+ 0.875+ 1.75
		).quant_(~globalQuant);
		~changePattern.value(Pdef(\unit3), ~song3Pattern3);
		Pbindef(\unit3,
			\dur, Pdefn(\kickNoisePatt),
			\att, 0.17,
			\amp, 0.005
		).quant_(~globalQuant);
		~resetControlBus.value("unit3amp");
		~changePattern.value(Pdef(\unit4), ~song3Pattern10);
		~changePattern.value(Pdef(\unit5), ~song3Pattern11);
		~changePattern.value(Pdef(\unit6), ~song3Pattern9);
		Pbindef(\unit6,
			\dur, Pdefn(\kickNoisePatt),
			\amp, 0.3,
			\attack, Pseq([1.32, 0.2, 1.65, 0.03], inf),
			\sustain, 0.01,
			\release, 0.09,
			\impFreq, Pseq([8000, 34, 8000], inf),
			\eqfreq, 367,
			\impLevel, Pseq([0.15, 0.75, 0.15]*1.2, inf),
			\noiseLevel, 0.2,
		).quant_(~globalQuant);
		~resetControlBus.value("unit6");
		~changePattern.value(Pdef(\unit8), ~song3Pattern8);
		56.0.wait;
		~changePattern.value(Pdef(\unit1), ~initPattern);
		~changePattern.value(Pdef(\unit2), ~initPattern);
		~changePattern.value(Pdef(\unit4), ~initPattern);
		~changePattern.value(Pdef(\unit5), ~initPattern);
		~changePattern.value(Pdef(\unit7), ~initPattern);
		~changePattern.value(Pdef(\unit8), ~initPattern);
		28.0.wait;
		~changePattern.value(Pdef(\unit3), ~initPattern);
		~changePattern.value(Pdef(\unit5), ~song3Pattern13);
		~changePattern.value(Pdef(\unit6), ~initPattern);
		28.0.wait;
		~changePattern.value(Pdef(\unit6), ~song3Pattern9);
		Pbindef(\unit6,
			\attack, 0,
			\amp, 0.3,
			\sustain, 0.14,
			\release, 0,
			\curve, 4.76,
			\clipLevel, 0,
			\impFreq, Pseq([15, 8, 12], inf),
			\impPhase, 0,
			\impLevel, 3.99,
			\noiseLevel, 0.3,
			\eqfreq, Pseg([765, 2242, 12875], [0.2, 0.55], \exp, inf),
			\eqrq, 0.74,
			\eqdb, -60
		).quant_(~globalQuant);
		14.0.wait;
		~changePattern.value(Pdef(\unit1), ~song3Pattern1);
		~changePattern.value(Pdef(\unit2), ~song3Pattern2);
		~changePattern.value(Pdef(\unit3), ~song3Pattern3);
		~changePattern.value(Pdef(\unit4), ~song3Pattern4);
		~changePattern.value(Pdef(\unit6), ~song3Pattern6);
		~changePattern.value(Pdef(\unit7), ~song3Pattern7);
		~changePattern.value(Pdef(\unit8), ~song3Pattern12);
		56.0.wait;
		Pbindef(\unit3,
			\dur, Pseq([Rest(0.875), 1.75, 0.875, 1.25, Rest(0.875), 1.375]/2, inf), // 0.875+ 0.875+ 1.75+ 1.25+ 1.375+ 0.875 == 7
			\att, 0.17
		).quant_(~globalQuant);
		~changePattern.value(Pdef(\unit4), ~song3Pattern9);
		Pbindef(\unit4,
			\dur, Pwrand([1.75, Rest(1.75), 3.5, Rest(3.5)], [0.2, 0.4, 0.3, 0.1].normalizeSum, inf),
			\attack, 0,
			\amp, 0.3,
			\sustain, 0.14,
			\release, 0,
			\curve, 4.76,
			\clipLevel, 0,
			\impFreq, Pseq([15, 8, 12], inf),
			\impPhase, 0,
			\impLevel, 3.99,
			\noiseLevel, 0.3,
			\eqfreq, Pseg([765, 2242, 12875], [0.2, 0.55], \exp, inf),
			\eqrq, 0.74,
			\eqdb, -60
		).quant_(~globalQuant);
		Pbindef(\unit6, \dur, Pseq([1.75, 3.5], inf)).quant_(~globalQuant);
		Pbindef(\unit7,
			\dur, Pseq([0.875, Rest(0.21875), 1.75, 0.21875, 0.4375], inf), // 0.875+ 0.4375+ 0.21875+ 0.21875+ 1.75
			\release, Pseq([0.01, 0.02, 0.01, 0.02, 0.03], inf),
		).quant_(~globalQuant);
		~resetControlBus.value("unit7release");
		28.0.wait;
		Pbindef(\unit3,
			\dur, Pseq([1.375, Rest(0.875), 0.875, 1.75, 0.875, 1.25], inf),
			\amp, 0.005
		).quant_(~globalQuant);
		~resetControlBus.value("unit3amp");
		~changePattern.value(Pdef(\unit6), ~song3Pattern6);
		~changePattern.value(Pdef(\unit7), ~song3Pattern7);
		28.0.wait;
		~changePattern.value(Pdef(\unit1), ~initPattern);
		~changePattern.value(Pdef(\unit3), ~initPattern);
		~changePattern.value(Pdef(\unit4), ~initPattern);
		~changePattern.value(Pdef(\unit6), ~initPattern);
		~changePattern.value(Pdef(\unit8), ~initPattern);
		28.0.wait;
		~changePattern.value(Pdef(\unit1), ~song3Pattern1);
		Pbindef(\unit1,
			\dur, Pseq([Rest(0.875), 2.625, 0.875, Rest(0.875), 1.75], inf) // 0.875+ 2.625+ 0.875+ 0.875+ 1.75
		).quant_(~globalQuant);
		~changePattern.value(Pdef(\unit3), ~song3Pattern3);
		Pbindef(\unit3,
			\dur, Pdefn(\kickNoisePatt),
			\att, 0.17,
			\amp, 0.005
		).quant_(~globalQuant);
		~resetControlBus.value("unit3amp");
		~changePattern.value(Pdef(\unit4), ~song3Pattern10);
		~changePattern.value(Pdef(\unit6), ~song3Pattern9);
		Pbindef(\unit6,
			\dur, Pdefn(\kickNoisePatt),
			\amp, 0.3,
			\attack, Pseq([1.32, 0.2, 1.65, 0.03], inf),
			\sustain, 0.01,
			\release, 0.09,
			\impFreq, Pseq([8000, 34, 8000], inf),
			\eqfreq, 367,
			\impLevel, Pseq([0.15, 0.75, 0.15]*1.2, inf),
			\noiseLevel, 0.2,
		).quant_(~globalQuant);
		~resetControlBus.value("unit6");
		~changePattern.value(Pdef(\unit8), ~song3Pattern12);
		56.0.wait;
	}
};

~song4 = {// ~globalQuant = 5; // !!! change globalQuant before song !!!
	t.tempo = 320 / 60;
	t.beatsPerBar = 5.0;
	{
		~autoGuiControl.at("samplerStereo1020amp").valueAction_(0.12);
		~autoGuiControl.at("samplerStereo1020attack").valueAction_(0.58);
		~autoGuiControl.at("samplerStereo1020release").valueAction_(1);
		~autoGuiControl.at("samplerStereo1020buffer").valueAction_(8); // for 09
		~autoGuiControl.at("samplerStereo1020rate").valueAction_(0.24);
		~autoGuiControl.at("samplerStereo1020startPos").valueAction_(0.03);

		~autoGuiControl.at("sinBass1021amp").valueAction_(0.66);
		~autoGuiControl.at("sinBass1021curve").valueAction_(0);
		~autoGuiControl.at("sinBass1021attack").valueAction_(0.2);
		~autoGuiControl.at("sinBass1021release").valueAction_(4);
		~autoGuiControl.at("sinBass1021envLevel1").valueAction_(8.5);
		~autoGuiControl.at("sinBass1021envLevel2").valueAction_(45.8);
		~autoGuiControl.at("sinBass1021envLevel3").valueAction_(25);
		~autoGuiControl.at("sinBass1021envLevel4").valueAction_(47);
		~autoGuiControl.at("sinBass1021envLevel5").valueAction_(17.5);
		~autoGuiControl.at("sinBass1021envLevel6").valueAction_(0);
		~autoGuiControl.at("sinBass1021envTime1").valueAction_(0.39);
		~autoGuiControl.at("sinBass1021envTime2").valueAction_(0.64);
		~autoGuiControl.at("sinBass1021envTime3").valueAction_(0.73);
		~autoGuiControl.at("sinBass1021envTime4").valueAction_(0.35);
		~autoGuiControl.at("sinBass1021envTime5").valueAction_(0);

		~autoGuiControl.at("noiseInjection1017drywet").valueAction_(-0.58);
		~autoGuiControl.at("noiseInjection1017attack").valueAction_(1.02);
		~autoGuiControl.at("noiseInjection1017release").valueAction_(0.01);
		~autoGuiControl.at("noiseInjection1017noiseType").valueAction_(1);
		~autoGuiControl.at("noiseInjection1017noiseLevel").valueAction_(1);
		~autoGuiControl.at("noiseInjection1017impFreq").valueAction_(55);
		~autoGuiControl.at("noiseInjection1017impPhase").valueAction_(0);
		~autoGuiControl.at("noiseInjection1017impLevel").valueAction_(10.11);

		~autoGuiControl.at("distoCrossOver1016drywet").valueAction_(-0.5);
		~autoGuiControl.at("distoCrossOver1016amp").valueAction_(0.14);
		~autoGuiControl.at("distoCrossOver1016smooth").valueAction_(0.1);
		~autoGuiControl.at("distoCrossOver1016level").valueAction_(0.44);

		~autoGuiControl.at("distoInsideOut1015drywet").valueAction_(-0.87);
		~autoGuiControl.at("distoInsideOut1015level").valueAction_(0.02);

		~autoGuiControl.at("waveShape1014mix").valueAction_(0.08);
		~autoGuiControl.at("waveShape1014gain").valueAction_(29.9);

		~channel.at(\level2).valueAction_(0.17);
	}.defer;
	~songInit.value;
	loop {
		~changePattern.value(Pdef(\unit1), ~song4Pattern1);
		~changePattern.value(Pdef(\unit2), ~song4Pattern2);
		~changePattern.value(Pdef(\unit3), ~song4Pattern3);
		~changePattern.value(Pdef(\unit4), ~song4Pattern4);
		~changePattern.value(Pdef(\unit5), ~song4Pattern5);
		~changePattern.value(Pdef(\unit6), ~song4Pattern6);
		~changePattern.value(Pdef(\unit7), ~song4Pattern7);
		~changePattern.value(Pdef(\unit8), ~song4Pattern8);
		20.0.wait; //30.0.wait;
		/*Pbindef(\unit4, \dur, Pseq([2.5, Rest(0.625), 1.25, Rest(0.625), 1.25, 2.5, 1.25], inf)).quant_(~globalQuant);
		Pbindef(\unit6, \dur, Pseq([Rest(1.25), 2.5, Rest(1.25), 5], inf)).quant_(~globalQuant);
		Pbindef(\unit8, \dur, Pseq([1.25, Rest(0.625), 0.625], inf)).quant_(~globalQuant);
		10.0.wait;*/
	}
};

)