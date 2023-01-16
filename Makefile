DC := dmd
BUILD := build
.PHONY: kib
kib:
	$(DC) src/*.d -of=$(BUILD)/kib
run: | kib
	echo
	./build/kib
.PHONY: clean
clean: 
	rm -rf build/*
