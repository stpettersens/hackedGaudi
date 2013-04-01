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
//import cpp.FileSystem;
#elseif php
import php.Lib;
import php.FileSystem;
#end

class HGaudiPlatform {

	public static function println(line : String) : Void {
		#if !java
			Lib.println(line);
		#else 
			java.lang.System.out.println(line);
		#end
	}

	public static function getPlatform() : String {
		var platform : String = null;
		#if neko
		platform = "Neko VM";
		#elseif cpp
		platform = "Native code";
		#elseif java
		platform = "JVM";
		#elseif php
		platform = "PHP";
		#end
		return " (" + platform + ").";
	}
}
