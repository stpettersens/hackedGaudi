/*
hackedGaudi
Copyright 2013 Sam Saint-Pettersen.

Port of the original Scala/Java application (Gaudi), which ran on the
Java virtual machine, to Haxe code.

Released under the MIT/X11 License.
*/
#if neko
import neko.Lib;
import neko.FileSystem;
#elseif cpp
import cpp.Lib;
import cpp.FileSystem;
#elseif php
import php.Lib;
import php.FileSystem;
#end

class HGaudiBuilder {
	var target : String;
	var action_name : String;
	var action : Hash<String>;
	var verbose: Bool;
	var passed : Bool;

	// Constructor for HGaudiBuilder.
	public function new(action_name : String) {
		this.action_name = action_name;
		this.passed = false;
		this.verbose = true;
	}

	// Print executed command.
	function printCommand(command : String, param : String) : Void {
		if(verbose && command != "echo" && command != "null")
			Lib.println("\t:" + command + " " + param);
		else if(command == "echo")
			Lib.println("\t#" + param);
	}

	// Execute an external program or process.
	function execExtern(app : String) : Int {
		var app = app.split(" ");
		var params = app.slice(2, app.length - 1);
		var process : sys.io.Process = new sys.io.Process(app[1], params);
		var exitCode : Int = process.exitCode();
		Lib.println(process.stderr.readAll().toString());
		#if !php
		process.close();
		#end
		return exitCode;
	}

	// Set target for the action.
	public function setTarget(target : String) : Void {
		this.target = target;
	}

	// Set action.
	public function setAction(a : Hash<String>) : Void {
		//action = a;
		action = new Hash<String>();
		for(key in a.keys()) {
			action.set(key, a.get(key));
		}
		trace(a);
		trace("Setting action as " + action);
	}

	// Execute a command in the action.
	function doCommand(command : String, param : String) : Int {
		printCommand(command, param);
		var exitCode : Int = 0;
		switch(command) {
			case "null":
				// Do nothing.
			case "exec":
				exitCode = execExtern(param);
			case "erase":
				if(FileSystem.exists(param))
					FileSystem.deleteFile(param);
		}
		return exitCode;
	}

	// Execute an action.
	public function doAction() : Void {
		Lib.println("[ " + target + " => " + action_name + " ]");
		#if(neko || cs || java)
		for(command in this.action.keys()) {
			var exitCode : Int = doCommand(command, action.get(command));
			if(exitCode == 0) passed = true;
			else passed = false;
		}
		#end
		var status : String = "failed";
		if(passed) status = "completed successfully";
		Lib.println("\nAction " + status + ".");
	}
}
