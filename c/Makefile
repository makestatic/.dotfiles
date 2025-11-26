# program - example
# See COPYING for license details

.POSIX:

EXE       := program
SRC       := 01.c 02.c 03.c
OBJ       := $(SRC:.c=.o)
CC        ?= gcc
CFLAGS    ?= -Wall -Wextra -O2 -std=gnu11
LDFLAGS   ?=
VERSION   := $(shell cat VERSION)
CFLAGS    += -DVERSION="\"$(VERSION)\""
DEPS      := $(OBJ:.o=.d)

all: options $(EXE)

options:
	@echo "CFLAGS  = $(CFLAGS)"
	@echo "LDFLAGS = $(LDFLAGS)"
	@echo "CC      = $(CC)"

%.o: %.c
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

-include $(DEPS)

$(EXE): $(OBJ)
	$(CC) -o $@ $(OBJ) $(LDFLAGS)

clean:
	rm -f $(EXE) $(OBJ) $(DEPS) *.tar.gz

dist:
	rm -rf $(EXE)-$(VERSION)
	mkdir -p $(EXE)-$(VERSION)
	cp -R *.c Makefile COPYING $$EXE_TMP
	tar -czf $(EXE)-$(VERSION).tar.gz -C $(EXE)-$(VERSION) .
	rm -rf $(EXE)-$(VERSION)

install: $(EXE)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(EXE) $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/$(EXE)

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(EXE)

.PHONY: all options clean dist install uninstall
