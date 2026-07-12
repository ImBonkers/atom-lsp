CC ?= cc
# _DEFAULT_SOURCE exposes the POSIX socket API (getaddrinfo/socket/...) that
# Atom's net library needs under a strict -std=c99; without it the server
# fails to compile. Must be a compile flag — the macro has to precede the
# first system header, so a header can't set it.
CFLAGS := -std=c99 -Wall -Wextra -Wno-unused-function -O2 -D_DEFAULT_SOURCE
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
	rm -rf atom bin
	$(MAKE) all

clean:
	rm -rf bin
