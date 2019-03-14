( // general set up

////////////////////////////////// 1. server config

// Server.supernova; // Switches the server program to supernova. Check ParGroup how to make use of multicore hardware with the supernova server.
Server.scsynth; // This is the default server
Server.default = s = Server.new(\orbm, NetAddr.new("127.0.0.1", 57110));
/********Multi-Client Setups***********/
// s.addr = NetAddr("168.192.1.20", 57110); // in case of distant server, args are IP and port number
// s.options.maxLogins = 2; // 2 users on the same server
/**************************************/
// ServerOptions.devices; // list avalaible audio devices MacOS only
// o = ServerOptions.new;
// o.device; // get devices on Windows
s.options.inDevice_("Fireface UCX (23732051)");
s.options.outDevice_("Fireface UCX (23732051)");
// s.options.device_("name your sound card");
s.options.numInputBusChannels_(3);
s.options.numOutputBusChannels_(4);

// o.memSize_(2.pow(20)); // real time memory size (used by delay like CombN)

// rec options
s.options.recChannels = 2;
s.options.recSampleFormat = "int24"; // 24 bit
s.options.recHeaderFormat = "aiff";

////////////////////////////////// 2. OSC config

//NetAddr.localAddr; // retrieve the current IP and port
//OSCFunc.trace(true); // Turn posting on
//OSCFunc.trace(false); // Turn posting off

////////////////////////////////// 3. midi config

// MIDIClient.init; // post a list of available devices
// MIDIClient.sources; // list avalaible midi sources
// MIDIIn.connect(0, MIDIClient.sources[0]); // connect on first port with first device equivalent to MIDIIn.connect
MIDIIn.connectAll; // connect to all attached input sources
// MIDIClient.destinations; // list avalaible midi destinations
~midiOut = MIDIOut.new(2); // 2 for MIDIClient.destinations[2]
~midiOut.latency_(s.latency);

////////////////////////////////// 4. boot

s.serverRunning.not.if({ s.boot });
s.newBusAllocators;
s.plotTree; // node tree

s.options.dump; // visualise server options
// GUI.current; // Test which GUI library you are using by default

////////////////////////////////// 5. initialize global variables

~path = PathName(thisProcess.nowExecutingPath).parentPath;

////////////////////////////////// 6. define specific functions

~makeBuffers = {
	b = Dictionary.new;
	PathName(~path ++ "Audio").entries.do{
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
// b[\Bowed_Empty_Sweep_Slow][0].play; // use it in a SynthDef like this: s.bind { Synth(\sampler, [\out, 0, \buffer, b[\Bowed_Empty_Sweep_Slow][0].bufnum]) };

~cleanup = {
	s.newBusAllocators;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

////////////////////////////////// 7. register functions with ServerBoot/Quit/Tree

ServerBoot.add({
	~makeBuffers.value;
});
ServerQuit.add({
	~cleanup.value;
});
)