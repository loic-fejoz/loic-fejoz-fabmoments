all: README.html

%.html:%.md
	markdown $< > $@

clean:
	rm -f README.html *~
