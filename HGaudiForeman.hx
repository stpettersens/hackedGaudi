/*
hackedGaudi
Copyright 2013 Sam Saint-Pettersen.

Port of the original Scala/Java application (Gaudi), which ran on the
Java virtual machine, to Haxe code.

Released under the MIT/X11 License.
*/
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

class HGaudiForeman {
	var buildConf : String;
	var buildJson : Dynamic;
	var preamble : Hash<String>;
	var action : Hash<String>;
	var action_name : String;
	var target : String;

	// Constructor for HGaudiForeman.
	public function new(buildConf : String, action_name : String) {
		this.buildConf = buildConf;
		this.action_name = action_name;
		parseBuildJSON();
	}

	// Parse build configurations into hashes.
	function parseBuildJSON() : Void {
		preamble = new Hash<String>();
		var json : PreambleObject = null;
		try {
			json = haxe.Json.parse(buildConf);
		}
		catch(msg : String) {
			HGaudiApp.displayError("Badly formatted JSON in build file");
		}

		for(key in Reflect.fields(json.preamble)) {
			var p : Preamble = Reflect.field(json.preamble, key);
			preamble.set(Std.string(key), Std.string(p));
		}
		var json_b : ActionObject = haxe.Json.parse(buildConf);
		var x = new Hash<String>();
		for(key in Reflect.fields(json_b.build)) {
			var a : Action = Reflect.field(json_b.build, key);
			x.set(Std.string(key), Std.string(a));
		}
		var y = x.get("__a");
		y = y.toString();
		var z = y.split(",");
		action = new Hash<String>();
		for(i in 0 ... z.length) {
			z[i] = StringTools.replace(z[i], "[", "");
			z[i] = StringTools.replace(z[i], "{", "");
			z[i] = StringTools.replace(z[i], "}", "");
			z[i] = StringTools.replace(z[i], "]", "");
			var x = z[i].split("=>");
			x[0] = StringTools.replace(x[0], " ", "");
			//x[1] = StringTools.replace(x[1], " ", "");
			action.set(x[0], x[1]);
		}
	}

	// Get target from parsed build file preamble.
	public function getTarget() : String {
		return preamble.get("target");
	}

	// Get action from parsed build file.
	public function getAction() : Hash<String> {
		return action;
	}
}
