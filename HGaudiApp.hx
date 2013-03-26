/*
hackedGaudi
Gaudi ported to Haxe.
Copyright 2013 Sam Saint-Pettersen.

See LICENSE for license details.
*/
#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

class HGaudiApp {

	static function displayUsage() : Void {
		Lib.println("hackedGaudi platform agnostic build tool");
		Lib.println("Copyright (c) 2013 Sam Saint-Pettersen");
		Lib.println("\nUsage: hgaudi [-l][-i][-v][-n][-m][-q]");
	}

	public static function main() {
		displayUsage();
	}
}

