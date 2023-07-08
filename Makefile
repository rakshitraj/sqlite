.DEFAULT_GOAL := db

db:
	if [ ! -d "build" ]; then \
		mkdir build; \
	fi 
	gcc db.c -o build/db

run:
	.build/db

clean:
	rm -rf build