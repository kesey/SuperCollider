this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Start.scd"); // Execute Me First

( // Execute Me After

///////////////////////////////////////  Sequencer

s.serverRunning.if({

	n = 60; // Tempo in beat per minutes
	TempoClock.default.tempo = n / 60; // TempoClock by default in beat per seconds
	t = TempoClock((n * 2) / 60); // Another TempoClock twice as fast as the TempoClock default

	~unit1 = Penvir((pdefName: \unit1, prevInstr: nil), Pdef(\unit1,
		~defaultPattern1
	).quant_(~globalQant));

	~unit2 = Penvir((pdefName: \unit2, prevInstr: nil), Pdef(\unit2,
		/*Pchain(
		~swingify,*/
		~defaultPattern2
		/*,
		(swingBase: 0.8, swingAmount: 0, swingThreshold: 0.2)
		)*/
	).quant_(~globalQant));

	~unit3 = Penvir((pdefName: \unit3, prevInstr: nil), Pdef(\unit3,
		~defaultPattern3
	).quant_(~globalQant));

	~unit4 = Penvir((pdefName: \unit4, prevInstr: nil), Pdef(\unit4,
		~defaultPattern4
	).quant_(~globalQant));

	~unit5 = Penvir((pdefName: \unit5, prevInstr: nil), Pdef(\unit5,
		~defaultPattern5
	).quant_(~globalQant));

	~unit6 = Penvir((pdefName: \unit6, prevInstr: nil), Pdef(\unit6,
		~defaultPattern6
	).quant_(~globalQant));

	~unit7 = Penvir((pdefName: \unit7, prevInstr: nil), Pdef(\unit7,
		~defaultPattern7
	).quant_(~globalQant));

	~unit8 = Penvir((pdefName: \unit8, prevInstr: nil), Pdef(\unit8,
		~defaultPattern8
	).quant_(~globalQant));

	this.executeFile(PathName(thisProcess.nowExecutingPath).parentPath ++ "ORBM_Gui.scd"); // Pdef need to exist before executing ORBM_Gui.scd

});

)

p = Ppar([~unit1, ~unit2, ~unit3, ~unit4, ~unit5, ~unit6, ~unit7, ~unit8], inf).play;
p.stop;

~song2.play;
~song2.pause;
~song2.resume;
~song2.stop;
~song2.reset;

///////////////////////////////////////  Playground



(



)