.DEFAULT_GOAL := db


.SILENT: db
.PHONY: db
db: src/main.c 
	echo "build: Creating target db..."
	if [ ! -d "build" ]; then \
		mkdir build; \
	fi 
	gcc src/main.c -o build/db


.SILENT: test
.PHONY: test
test: build/db spec
	echo "build: Creating target test..."
	bundle exec rspec


.SILENT: run
.PHONY: run
run: build/db
	echo "build: Creating target run..."
	build/db build/make.db
	rm build/make.db


.PHONY: launch
launch: build/db
	build/db res/mydb.db


.PHONY: clean
clean:
	rm -rf build