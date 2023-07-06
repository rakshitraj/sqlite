.DEFAULT_GOAL := db

db:
	gcc db.c -o db

run:
	./db

clean:
	rm db