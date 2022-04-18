.PHONY: build clean tools
all: build

SHELL := /bin/bash

build: tools
	cargo build

tools: target/arduino-bin/arduino-cli target/arduino-bin/cli.yaml
	target/arduino-bin/arduino-cli --config-file target/arduino-bin/cli.yaml core install arduino:megaavr

target/arduino-bin/cli.yaml: target/arduino-bin/arduino-cli
	target/arduino-bin/arduino-cli config init --dest-file target/arduino-bin/cli.yaml
	sed -i 's|data: .*|data: target/arduino|' target/arduino-bin/cli.yaml
	sed -i 's|downloads: .*|downloads: target/arduino/staging|' target/arduino-bin/cli.yaml
	sed -i 's|user: .*|user: target/arduino/user|' target/arduino-bin/cli.yaml

target/arduino-bin/avrdude: 
	mkdir -p target/arduino-bin
	cp $$(find target/arduino/packages/arduino/tools/avrdude -type f -name avrdude | head -n 1) target/arduino-bin/avrdude
	cp $$(find target/arduino/packages/arduino/tools/avrdude -type f -name avrdude.conf | head -n 1) target/arduino-bin/avrdude.conf 

target/arduino-bin/arduino-cli: target/arduino-cli
	mkdir -p target/arduino-bin

	cp target/arduino-cli/arduino-cli target/arduino-bin/arduino-cli

target/arduino-cli: target/arduino-cli.tar.gz
	mkdir -p target/arduino-cli
	tar -xf target/arduino-cli.tar.gz -C target/arduino-cli/

ARDUINO_CLI = "https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_64bit.tar.gz"
target/arduino-cli.tar.gz:
	mkdir -p target
	wget ${ARDUINO_CLI} -O target/arduino-cli.tar.gz

clean:
	rm -rf target/