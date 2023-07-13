.DEFAULT_GOAL := db


.SILENT: db
.PHONY: db
db: db.c 
	if [ ! -d "build" ]; then \
		mkdir build; \
	fi 
	gcc db.c -o build/db


.PHONY: test
test: db build/db spec
	bundle exec rspec


.SILENT: run
.PHONY: run
run:
	build/db make.db
	rm make.db


.PHONY: launch
launch: build/db
	build/db mydb.db


.PHONY: clean
clean:
	rm -rf build