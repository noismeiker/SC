s.boot

//Declara dispositivos MIDI disponibles
MIDIClient.init;
MIDIIn.connectAll;


//Note On = se crea un mididef que indique que al bajar la tecla, se genere sonido
(
MIDIdef.noteOn(\noteOntest, {
	arg vel, note,chan, src;
	[vel, note].postln;

	{
		var saw, env;
		saw = VarSaw.ar(note.midicps,0,MouseX.kr(0,1),0.1);
		env = EnvGen.kr(Env.perc, doneAction:2);
		saw = saw * env;
	}.play;


});
)



//Note Off
(
MIDIdef.noteOn(\noteOntest, {
	arg vel, note, chan, src;
	[vel, note].postln;
	~notes[note] = Synth.new(
		\dist,
		[
			\freq, note.midicps,
			\amp, vel.linexp(1,127,0.01,0.3),
			\gate, 1,

		]
	);
});

MIDIdef.noteOff(\noteOfftest, {
	arg vel, note;
	[vel, note].postln;
	~notes[note].set(\gate, 0);
	~notes[note] = nil;
})
)

(
SynthDef.new(\dist, {arg freq=440, amp=0.3, gate=0, pan=0, at=0.1, rel=0.5, out=0;
	var sen, paneo, env;

	sen=Pulse.ar(freq, 0.5, MouseX.kr(0.1,80,1)).wrap2(4) * 0.2;
	paneo=Pan2.ar(sen, pan);
	env=EnvGen.kr(Env.adsr, gate, doneAction:2);
	Out.ar(out, paneo*env);
}).add
)

 ~notes = Array.newClear(128);

