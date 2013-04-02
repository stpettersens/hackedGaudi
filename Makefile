make:
	haxe -cp src -main HGaudiApp -neko hgaudi.n
cpp:
	haxe -cp src -main HGaudiApp -cpp hgaudi
jvm:
	haxe -cp src -main HGaudiApp -java jvm
php:
	haxe -cp src -main HGaudiApp -php php
js:
	haxe -cp src -lib jQueryExtern -main HGaudiApp -js hgaudi-online/scripts/hgaudi.js
