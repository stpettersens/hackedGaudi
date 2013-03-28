/*
hackedGaudi
Copyright 2013 Sam Saint-Pettersen.

Port of the original Scala/Java application (Gaudi), which ran on the
Java virtual machine, to Haxe code.

Released under the MIT/X11 License.
*/
typedef All = {
	preamble : Dynamic
};

typedef Preamble = {
	source : String,
	target : String,
	cc: String,
	win_includes : String,
	nix_includes : String
};

class HGaudiForeman {
	var buildConf : String;
	var buildJson : Dynamic;
	var action : String;
	var preamble : Hash<String>;
	var commands : Hash<String>;
	var target : String;

	// Constructor for HGaudiForeman.
	public function new(buildConf : String, action : String) {
		this.buildConf = buildConf;
		this.action = action;
		parseBuildJSON();
	}

	// Parse build configurations into hashes.
	function parseBuildJSON() : Void {
		preamble = new Hash<String>();
		var json : All = haxe.Json.parse(buildConf);
		for(key in Reflect.fields(json.preamble)) {
			var p : Preamble = Reflect.field(json.preamble, key);
			preamble.set(Std.string(key), Std.string(p));
		}	
	}

	// Get target from parsed preamble.
	public function getTarget() : String {
		return preamble.get("target");
	}
}
