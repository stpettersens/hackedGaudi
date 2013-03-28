/*
hackedGaudi
Copyright 2013 Sam Saint-Pettersen.

Port of the original Scala/Java application (Gaudi), which ran on the
Java virtual machine, to Haxe code.

Released under the MIT/X11 License.
*/
#if neko
import neko.Lib;
import neko.io.File;
import neko.FileSystem;
#elseif cpp
import cpp.Lib;
import cpp.io.File;
import cpp.FileSystem;
#elseif php
import php.Lib;
import php.io.File;
import php.FileSystem;
#end

class HGaudiApp {
	static var buildFile : String = "build.json";
	static var errorCode : Int = -1;

	static function displayError(error : String) : Void {
		Lib.println("\nError with: " + error + ".");
		displayUsage(errorCode);
	}

	static function displayUsage(exitCode: Int) : Void {
		var usage : String = "\nhackedGaudi platform agnostic build tool"
		+ "\nCopyright (c) 2013 Sam Saint-Pettersen"
		+ "\n\nReleased under the MIT/X11 License."
		+ "\n\nUsage: hgaudi [-l][-i][-v][-n][-m][-q]";
		Lib.println(usage);
		Sys.exit(exitCode);
	}

	// Load and delegate parse and execution of build file.
	static function loadBuild(action : String) : Void {
		var buildConf : String = null;
		if(FileSystem.exists(buildFile)) {
			buildConf = File.read(buildFile, false).readAll().toString();
		}
		else 
			displayError("Build file (" + buildFile + "). Cannot be found/opened"); 

		// Shrink string by replacing tabs (ASCII 9) with null space;
		// Gaudi build files should be written using tabs.
		buildConf = StringTools.replace(buildConf, String.fromCharCode(9), "");

		var _hash = new Hash<String>();

		// Delegate to the foreman and builder.
		var foreman = new HGaudiForeman(buildConf, action);
		var builder = new HGaudiBuilder(_hash, action);
		builder.setTarget(foreman.getTarget());
		builder.doCommand("exec", "g++");
		Sys.exit(0);
	}

	public static function main() : Void {
		var action : String = "build";

		/* Default behavior is to build a project following
		the build file in the current working directory. */
		if(Sys.args()[0] == null) loadBuild(action);

		// Handle command line arguments.
		if(Sys.args()[0] == "-i") displayUsage(0);

	}
}
