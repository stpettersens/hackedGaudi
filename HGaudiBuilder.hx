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
#elseif java 
import java.Lib;
import java.io.File;
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
			HGaudiPlatform.println("\t:" + command  + " " + param);
		else if(command == "echo")
			HGaudiPlatform.println("\t#" + param);
	}

	// Execute an external program or process.
	function execExtern(app : String) : Int {
		var app = app.split(" ");
		var params = app.slice(2, app.length - 1);
		var process : sys.io.Process = new sys.io.Process(app[1], params);
		var exitCode : Int = process.exitCode();
		HGaudiPlatform.println(process.stderr.readAll().toString());
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
	public function setAction(action : Hash<String>) : Void {
		this.action = action;
		//trace(this.action);
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
				#if !java
				if(FileSystem.exists(param))
					FileSystem.deleteFile(param);
				#else
				var file = new File(param);
				if(file.exists() && file.isFile())
					file.delete();
				#end
		}
		return exitCode;
	}

	// Execute an action.
	public function doAction() : Void {
		HGaudiPlatform.println("[ " + target + " => " + action_name + " ]");
		for(command in action.keys()) {
			var exitCode : Int = doCommand(command, action.get(command));
			if(exitCode == 0) passed = true;
			else passed = false;
		}
		var status : String = "failed";
		if(passed) status = "completed successfully";
		HGaudiPlatform.println("\nAction " + status + ".");
	}
}
