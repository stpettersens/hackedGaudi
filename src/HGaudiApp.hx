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
import php.io.File;
import php.FileSystem;
#end

class HGaudiApp {
	static var appVersion : String = "0.1";
	static var buildFile : String = "build.json";
	static var errorCode : Int = -1;
	static var cleanCode : Int = 0;

	static function displayVersion() : Void {
		HGaudiPlatform.println("hackedGaudi v. " + appVersion 
		+ HGaudiPlatform.getPlatform());
		#if !js
		Sys.exit(cleanCode);
		#end
	}

	public static function displayError(error : String) : Void {
		HGaudiPlatform.println("Error: " + error + ".");
		displayUsage(errorCode);
	}

	static function displayUsage(exitCode: Int) : Void {
		var usage : String = "\nhackedGaudi platform agnostic build tool"
		+ "\nCopyright (c) 2013 Sam Saint-Pettersen"
		+ "\n\nReleased under the MIT/X11 License."
		+ "\n\nUsage: hgaudi [-l][-u][-i][-v][-b][-m][-q]"
		+ "\n[-f &lt;build file&gt;][-u &lt;build file URL&gt;][&lt;action&gt;|\"&lt;command&gt;\"]\n"
		+ "\n-l: Enable logging of certain events."
		+ "\n-i: Display usage information and quit."
		+ "\n-v: Display version information and quit."
		+ "\n-b: Generate a Gaudi build file (build.json)."
		+ "\n-q: Mute console output, except for :echo and errors &lt;Quiet mode&gt;."
		+ "\n-f: Use &lt;build file&gt; instead of build.json."
		+ "\n-u: Use &lt;build file URL&gt; instead of local file.";
		#if !js
		usage = StringTools.replace(usage, "&lt;", "<");
		usage = StringTools.replace(usage, "&gt;", ">");
		#end
		HGaudiPlatform.println(usage);
		#if !js
		Sys.exit(exitCode);
		#end
	}

	// Load and delegate parse and execution of build file.
	static function loadBuild(action : String) : Void {
		var buildConf : String = null;
		#if !js
		if(sys.FileSystem.exists(buildFile))
			buildConf = sys.io.File.getContent(buildFile); 
		#elseif js
		var request = new js.html.XMLHttpRequest();
		request.open("GET", buildFile, false);
		request.send();
		if(request.status == 200) {
			buildConf = request.responseText;
		}
		#end
		else
			displayError("Build file (" + buildFile + ") cannot be loaded");

		// Shrink string by replacing tabs (ASCII 9) with null space;
		// Gaudi build files should be written using tabs.
		buildConf = StringTools.replace(buildConf, String.fromCharCode(9), "");

		// Delegate to the foreman and builder.
		var foreman = new HGaudiForeman(buildConf, action);
		var builder = new HGaudiBuilder(action);
		builder.setTarget(foreman.getTarget());
		builder.setAction(foreman.getAction());
		builder.doAction();
		#if !js
		Sys.exit(cleanCode);
		#end
	}

	public static function main() : Void {
		buildFile = "build.json";
		var action : String = "build";

		/* Default behavior is to build a project following
		the build file in the current working directory. */
		#if !js
		if(Sys.args()[0] == null) loadBuild(action);
		
		// Handle command line arguments.
		else if(Sys.args()[0] == "-i") displayUsage(cleanCode);

		else if(Sys.args()[0] == "-v") displayVersion();

		for(i in 0 ... Sys.args().length) {
			if(Sys.args()[i].charAt(0) == "-") {
				if(Sys.args()[i] == "-f") {
					buildFile = Sys.args()[i + 1];
					if(Sys.args()[i + 2] != null) action = Sys.args()[i + 2];
					loadBuild(action);
				}
			}
			else {
				action = Sys.args()[i];
				loadBuild(action);
			}
		}
		/* In JavaScript target, the default build file is the uploaded or url refered file. */
		#elseif js 
		function prompt() : Void {
			HGaudiPlatform.instruct("To begin, upload your source files to build");
			HGaudiPlatform.instruct("and your build file (e.g. build.json) in the Files tab.");
			displayUsage(cleanCode);
		}
		new JQuery(function() : Void {
			var loaded: Bool = false;
			prompt();
			new JQuery("#enterCommand").click(function(ev) {
				HGaudiPlatform.cls();
				var commandParam = new JQuery("#command").val();
				var command = commandParam.split(" ");
				HGaudiPlatform.clear();
				trace(command);
				if(command[1] == "-f") { 
					buildFile = command[2];	
					loaded = true;
					if(command[3] != null) action = command[3];
					HGaudiPlatform.cls();
					loadBuild(action);
				}
				else if(command[1].charAt(0) == "-") {
					if(command[1] == "-v") displayVersion();
					else if(command[1] == "-i") displayUsage(cleanCode);
				}
				else if(loaded && command[1] != "") {
					loadBuild(command[1]);
				}
				else if(command[1] == "") displayError("No build file or action provided");
			});
		});
		#end
	}
}
