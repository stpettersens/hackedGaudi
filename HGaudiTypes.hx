/*
hackedGaudi
Copyright 2013 Sam Saint-Pettersen.

Port of the original Scala/Java application (Gaudi), which ran on the
Java virtual machine, to Haxe code.

Released under the MIT/X11 License.
*/
// Define custom types for JSON parsing.
typedef PreambleObject = {
	preamble : Dynamic
};

typedef ActionObject = {
	build : Dynamic,
	clean : Dynamic
};

typedef Preamble = {
	source : String,
	target : String,
	cc: String,
	win_includes : String,
	nix_includes : String
};

typedef Action = {
	command : Array<String>
};
