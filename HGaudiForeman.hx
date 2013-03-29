/*
hackedGaudi
Copyright 2013 Sam Saint-Pettersen.

Port of the original Scala/Java application (Gaudi), which ran on the
Java virtual machine, to Haxe code.

Released under the MIT/X11 License.
*/
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
		var json : HGaudiTypes.PreambleObject = null;
		try {
			// Try to parse build file JSON for first time.
			json = haxe.Json.parse(buildConf);
		}
		catch(msg : String) {
			// Display an error if the JSON is badly formatted.
			HGaudiApp.displayError("Badly formatted JSON in build file");
		}

		for(key in Reflect.fields(json.preamble)) {
			var p : HGaudiTypes.Preamble = Reflect.field(json.preamble, key);
			preamble.set(Std.string(key), Std.string(p));
		}
		var json_b : HGaudiTypes.ActionObject = haxe.Json.parse(buildConf);
		var x = new Hash<String>();
		var a : HGaudiTypes.Action = null;
		switch(action_name) {
			case "build": // Reflect default "build" action into hash.
				for(key in Reflect.fields(json_b.build)) {
					a = Reflect.field(json_b.build, key);
					x.set(Std.string(key), Std.string(a));
				}
			case "clean": // Reflect "clean" action into hash.
				for(key in Reflect.fields(json_b.clean)) {
					a = Reflect.field(json_b.clean, key);
					x.set(Std.string(key), Std.string(a));
				}
		}
		var y = x.get("__a"); // Get array member from hash.
		var z = y.split(","); // Split into true array, z, at ",".
		action = new Hash<String>();
		for(i in 0 ... z.length) {
			// Remove unwanted characters from action array.
			z[i] = StringTools.replace(z[i], "[", "");
			z[i] = StringTools.replace(z[i], "{", "");
			z[i] = StringTools.replace(z[i], "}", "");
			z[i] = StringTools.replace(z[i], "]", "");
			var x = z[i].split("=>");
			x[0] = StringTools.replace(x[0], " ", "");
			if(x[0] != "exec" && x[0] != "echo") 
				// There are never spaces in parameters for commands other than exec and echo.
				x[1] = StringTools.replace(x[1], " ", "");
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
