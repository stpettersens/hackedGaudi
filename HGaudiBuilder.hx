/*
hackedGaudi
Copyright 2013 Sam Saint-Pettersen.

Port of the original Scala/Java application (Gaudi), which ran on the
Java virtual machine, to Haxe code.

Released under the MIT/X11 License.
*/
#if neko
import neko.Lib;
#elseif cpp
import cpp.Lib;
#elseif php
import php.Lib;
#end

class HGaudiBuilder {
	var commands : Hash<String>;
	var target : String;
	var action_name : String;
	var action : Array<String>;
	var verbose: Bool;

	// Constructor for HGaudiBuilder.
	public function new(commands : Hash<String>, action : String) {
		this.commands = commands;
		action_name = action;
	}

	// Print executed command.
	function printCommand(command : String, param : String) : Void {
		if(verbose && command != "echo")
			Lib.println("\t: " + command + " " + param + "\n");
		else if(command == "echo")
			Lib.println("\t# " + param);
	}

	function execExtern(app : String) : Int {
		var process : sys.io.Process = new sys.io.Process(app, []);
		var exitCode : Int = process.exitCode();
		Lib.println(process.stderr.readAll().toString());
		Lib.println(process.stdout.readAll().toString());
		#if !php
		process.close();
		#end
		return exitCode;
	}

	public function setTarget(target : String) : Void {
		this.target = target;
		trace(this.target);
	}

	public function setAction(action : Array<String>) : Void {
		this.action = action;
		trace(this.action);
	}

	// Execute a command in the action.
	public function doCommand(command : String, param : String) : Void {
		printCommand(command, param);
		var exitCode : Int = 0;
		if(command == "exec")
			exitCode = execExtern(param);
	}
}
