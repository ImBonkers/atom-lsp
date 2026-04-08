CC ?= cc
CFLAGS := -std=c99 -Wall -Wextra -Wno-unused-function -O2
REPO := https://github.com/ImBonkers/Atom.git
SRC := atom/src/lsp_main.c

.PHONY: all clean update

all: bin/atom-lsp

bin/atom-lsp: $(SRC) | bin
	$(CC) $(CFLAGS) $(SRC) -o $@ -lm

$(SRC):
	git clone --depth 1 $(REPO) atom

bin:
	mkdir -p bin

update:
	cd atom && git pull
	$(MAKE) clean all

clean:
	rm -rf bin
