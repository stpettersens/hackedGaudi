CC = haxe
SOURCE = HGaudiApp
TARGET = hgaudi

make:
	$(CC) -cp src -main $(SOURCE) -neko $(TARGET).n
cpp:
	$(CC) -cp src -main $(SOURCE) -cpp $(TARGET)
jvm:
	$(CC) -cp src -main $(SOURCE) -java jvm
php:
	$(CC) -cp src -main $(SOURCE) -php php
js:
	$(CC) -cp src -lib jQueryExtern -main HGaudiApp -js $(TARGET).js
	yuicompressor --nomunge $(TARGET).js -o ../hgaudi-online/public/js/$(TARGET).min.js


