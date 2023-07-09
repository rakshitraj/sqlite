.DEFAULT_GOAL := db

.SILENT: db
.PHONY: db
db:
	if [ ! -d "build" ]; then \
		mkdir build; \
	fi 
	gcc db.c -o build/db

.SILENT: run
.PHONY: run
run:
	build/db

.PHON: clean
clean:
	rm -rf build