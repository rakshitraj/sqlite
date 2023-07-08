.DEFAULT_GOAL := db

db:
	mkdir build 
	gcc db.c -o build/db

run:
	.build/db

clean:
	rm -rf build