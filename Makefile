# git-prompt.sh's Makefile
# ========================

.PHONY: test clean

BUILD_DIR=dist

$(BUILD_DIR):
	mkdir "$(BUILD_DIR)"

clean:
	rm -rf "$(BUILD_DIR)"

test:
	./run-tests.sh
