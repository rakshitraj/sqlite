.DEFAULT_GOAL := db


.SILENT: db
.PHONY: db
db: db.c 
	echo "build: Creating target db..."
	if [ ! -d "build" ]; then \
		mkdir build; \
	fi 
	gcc db.c -o build/db


.SILENT: test
.PHONY: test
test: db build/db spec
	echo "build: Creating target test..."
	bundle exec rspec


.SILENT: run
.PHONY: run
run: db
	echo "build: Creating target run..."
	build/db make.db
	rm make.db


.PHONY: launch
launch: db build/db
	build/db mydb.db


.PHONY: clean
clean:
	rm -rf build