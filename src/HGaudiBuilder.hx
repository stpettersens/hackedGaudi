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
	var action : Map<String,String>;
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
		var params = app.slice(2, app.length);
		#if !js
		var process : sys.io.Process = new sys.io.Process(app[1], params);
		var exitCode : Int = process.exitCode();
		HGaudiPlatform.println(process.stderr.readAll().toString());
		#elseif js 
		var request = new js.html.XMLHttpRequest();
		request.open("GET", "/api/execute/output/" + app[1] + "/" + params[0] + " " + params[1]
		+ " " + params[2], false); //" " + params[3], false);
		request.send();
		#end
		#if(!js && !php)
		process.close();
		return exitCode;
		#else
		return 0;
		#end
	}

	// Set target for the action.
	public function setTarget(target : String) : Void {
		this.target = target;
	}

	// Set action.
	public function setAction(action : Map<String,String>) : Void {
		this.action = action;
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
				#if (!java && !js)
				if(sys.FileSystem.exists(param))
					sys.FileSystem.deleteFile(param);
				#elseif (java && !js)
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
		#if js
		appendOutput();
		#end
	}

	#if js
	// JavaScript build: Append produced files to output file list.
	function appendOutput() : Void {
		JQuery._static.getJSON("/api/output/get/", function(data) {
			new JQuery("#o-file-list").empty();
			JQuery._static.each(data, function(key, val) {
				new JQuery("#o-file-list").append('<p>' + val.filename + '</p>');
			});
		});
	}
	#end
}
