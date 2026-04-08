CC ?= cc
CFLAGS := -std=c99 -Wall -Wextra -Wno-unused-function -O2
SRC := atom/src/lsp_main.c

.PHONY: all clean

all: bin/atom-lsp

bin/atom-lsp: $(SRC) | bin
	$(CC) $(CFLAGS) $(SRC) -o $@ -lm

$(SRC):
	git -C "$(CURDIR)" submodule update --init --recursive

bin:
	mkdir -p bin

clean:
	rm -rf bin
