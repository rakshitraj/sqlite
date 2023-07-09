.DEFAULT_GOAL := db

.SILENT: db
db:
	if [ ! -d "build" ]; then \
		mkdir build; \
	fi 
	gcc db.c -o build/db

.SILENT: run
run:
	build/db

clean:
	rm -rf build