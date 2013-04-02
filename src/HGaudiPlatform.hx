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
#elseif js
import js.Lib;
#elseif php
import php.Lib;
import php.FileSystem;
#end

class HGaudiPlatform {

	public static function println(line : String) : Void {
		#if(!java && !js)
			Lib.println(line);
		#elseif java
			java.lang.System.out.println(line);
		#elseif js
		new JQuery(function() : Void {
			new JQuery("#console").append(line + "<br/>").fadeIn('slow', function() {
  			});
		});		
		#end
	}

	public static function instruct(line : String) : Void {
		#if js
		new JQuery(function() : Void {
			new JQuery("#console").append("<strong>" + line + "</strong><br/>");
		});
		#end
	}

	public static function cls() : Void {
		#if js
		new JQuery(function() : Void {
			new JQuery("#console").empty();
		});
		#end
	} 

	public static function clear() : Void {
		#if js
		new JQuery(function() : Void {
			new JQuery("#command").val("");
			new JQuery("#command").val("hgaudi ");
			new JQuery("#command").focus();
		});
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
		#elseif js
		platform = "JavaScript";
		#end
		return " (" + platform + ").";
	}
}
