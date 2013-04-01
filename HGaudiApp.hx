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
		Sys.exit(cleanCode);
	}

	public static function displayError(error : String) : Void {
		HGaudiPlatform.println("\nError: " + error + ".");
		displayUsage(errorCode);
	}

	static function displayUsage(exitCode: Int) : Void {
		var usage : String = "\nhackedGaudi platform agnostic build tool"
		+ "\nCopyright (c) 2013 Sam Saint-Pettersen"
		+ "\n\nReleased under the MIT/X11 License."
		+ "\n\nUsage: hgaudi [-l][-i][-v][-n][-m][-q]";
		HGaudiPlatform.println(usage);
		Sys.exit(exitCode);
	}

	// Load and delegate parse and execution of build file.
	static function loadBuild(action : String) : Void {
		var buildConf : String = null;
		//#if !java
		if(sys.FileSystem.exists(buildFile))
			buildConf = sys.io.File.getContent(buildFile); 
		else 
			displayError("Build file (" + buildFile + ") cannot be found/opened");

		// Shrink string by replacing tabs (ASCII 9) with null space;
		// Gaudi build files should be written using tabs.
		buildConf = StringTools.replace(buildConf, String.fromCharCode(9), "");

		// Delegate to the foreman and builder.
		var foreman = new HGaudiForeman(buildConf, action);
		var builder = new HGaudiBuilder(action);
		builder.setTarget(foreman.getTarget());
		builder.setAction(foreman.getAction());
		builder.doAction();
		Sys.exit(cleanCode);
	}

	public static function main() : Void {
		var action : String = "build";

		/* Default behavior is to build a project following
		the build file in the current working directory. */
		if(Sys.args()[0] == null) loadBuild(action);
		
		// Handle command line arguments.
		else if(Sys.args()[0] == "-i") displayUsage(cleanCode);

		else if(Sys.args()[0] == "-v") displayVersion();

		for(i in 0 ... Sys.args().length) {
			if(Sys.args()[i].charAt(0) == "-") {
				//...
			}
			else {
				action = Sys.args()[i];
				loadBuild(action);
			}
		}
	}
}
