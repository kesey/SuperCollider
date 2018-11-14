(
// visualize stream
var a;
a = Pseries(4, Prand(#[-1, 1], inf), 10);
a = a.asStream;
a.nextN(20);
)

( // general set up
// 1. midi config
MIDIClient.init;
//MIDIClient.sources; // list avalaible midi sources
MIDIIn.connectAll;
//MIDIClient.destinations; // list avalaible midi destinations
//~midiOut = MIDIOut.newByName("deviceName", "portName").latency_(Server.default.latency);

// 2. server config
Server.default = s = Server.local;
//s.options.devices; // list avalaible audio devices MacOS only
s.options.inDevice_("Built-in Microph");
s.options.outDevice_("Built-in Output");
//s.options.device_("name your sound card");
s.options.numInputBusChannels_(8);
s.options.numOutputBusChannels_(8);

//s.options.blockSize = 1; // sample and control rate are equals (control rate = sample rate = 44100) to make feedback more accurate
//s.options.memSize_(2.pow(20));
s.newBusAllocators;
s.serverRunning.not.if({ s.boot });
s.meter; // level meter
s.plotTree; // node tree
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;

//GUI.current; // Test which GUI library you are using by default
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

// 5. register functions with ServerBoot/Quit/Tree
ServerBoot.add(~makeBuffers);
ServerQuit.add(~cleanup);
)

