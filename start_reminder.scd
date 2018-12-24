(
// visualize stream
var a;
a = Pseries(4, Prand(#[-1, 1], inf), 10);
a = a.asStream;
a.nextN(20);
)

( // general set up
// 0. OSC config
//NetAddr.localAddr; // retrieve the current IP and port
//OSCFunc.trace(true); // Turn posting on
//OSCFunc.trace(false); // Turn posting off
// 1. midi config
MIDIClient.init; // post a list of available devices
// MIDIClient.sources; // list avalaible midi sources
// MIDIIn.connect(0, MIDIClient.sources[0]); // connect on first port with first device equivalent to MIDIIn.connect
MIDIIn.connectAll; // connect to all attached input sources
// MIDIClient.destinations; // list avalaible midi destinations
// ~midiOut = MIDIOut(0).latency_(Server.default.latency); //quick way to access device 0, port 0

// 2. server config
Server.default = s = Server.local;
// s.options.devices; // list avalaible audio devices MacOS only
s.options.inDevice_("Built-in Microph");
s.options.outDevice_("Built-in Output");
// s.options.device_("name your sound card");
s.options.numInputBusChannels_(8);
s.options.numOutputBusChannels_(8);

// s.options.memSize_(2.pow(20));
s.newBusAllocators;
s.serverRunning.not.if({ s.boot });
s.meter; // level meter
s.plotTree; // node tree
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;

// GUI.current; // Test which GUI library you are using by default
)

(
// 3. initialize global variables
~out = 0;
~path = PathName(thisProcess.nowExecutingPath).parentPath;

// 4. define specific functions
~makeBuffers = {
	b = Dictionary.new;
	PathName(~path).entries.do{
		arg subfolder;
		b.add(
			subfolder.folderName.asSymbol ->
			Array.fill(
				subfolder.entries.size,
				{
					arg i;
					Buffer.read(s, subfolder.entries[i].fullPath);
				}
			)
		);
	};
};

~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

~startRec = {
	s.recChannels = 2;
	s.recSampleFormat = "int24"; // 24 bit
	s.recHeaderFormat = "wav";
	s.prepareForRecord("~/path/name/session.wav"); // ~path ++ "session.wav"
	// thisProcess.platform.recordingsDir; // verify your recording dir
	s.record;
};

~stopRec = {
	s.stopRecording;
};

// 5. register functions with ServerBoot/Quit/Tree
ServerBoot.add(~makeBuffers, ~startRec);
ServerQuit.add(~cleanup, ~stopRec);
)

