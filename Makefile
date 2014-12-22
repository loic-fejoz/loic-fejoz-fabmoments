all: README.html

%.html:%.md
	markdown $< > $@

validate:
	jsonlint thingtracker.json */thingtracker.json

clean:
	rm -f README.html *~
