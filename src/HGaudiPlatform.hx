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
			new JQuery("#console").append(line + "<br/>");
		});		
		#end
	}

	#if js
	public static function instruct(line : String) : Void {
		new JQuery(function() : Void {
			new JQuery("#console").append("<strong>" + line + "</strong><br/>");
		});
	}
	#end

	#if js
	public static function cls() : Void {
		new JQuery(function() : Void {
			new JQuery("#console").empty();
		});
	} 
	#end

	#if js
	public static function clear() : Void {
		new JQuery(function() : Void {
			new JQuery("#command").val("");
			new JQuery("#command").val("hgaudi ");
			new JQuery("#command").focus();
		});
	}
	#end

	public static function getPlatform() : String {
		var platform : String = null;
		#if neko
		platform = "Neko VM";
		#elseif cpp
		platform = "C++";
		#elseif java
		platform = "JVM";
		#elseif php
		platform = "PHP";
		#elseif js
		platform = "JavaScript [";
		if(JQuery._static.browser.webkit) 
			platform += "WebKit-based/" + JQuery._static.browser.version;
		else if(JQuery._static.browser.opera) {
			platform += "Opera/" + JQuery._static.browser.version;
		}
		else if(JQuery._static.browser.msie) {
			platform += "MSIE/" + JQuery._static.browser.version;
		}
		else if(JQuery._static.browser.mozilla) {
			platform += "Firefox/" + JQuery._static.browser.version;
		}
		platform += "]";
		#end
		return " (" + platform + ")";
	}
}
