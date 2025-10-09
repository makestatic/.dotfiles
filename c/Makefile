####################################################
############## My Generic Makefile #################
######### Copyright (c) 2025 Ali Almalki ###########
############## <makestatic@github> #################
##################### GPL-3 ########################
####################################################
EXE       := program
SRC_DIRS  := source util vendor include
BUILD_DIR := build
PREFIX    ?= /usr

CC  := $(shell command -v clang 2>/dev/null || echo gcc)
CXX := $(shell command -v clang++ 2>/dev/null || echo g++)
STD_C   ?= gnu17
STD_CPP ?= gnu++17

CFLAGS   := -Wall -Wextra -Wpedantic -ggdb -O2 -MMD -MP -std=$(STD_C)
CXXFLAGS := -Wall -Wextra -Wpedantic -ggdb -O2 -MMD -MP -std=$(STD_CPP)
LDFLAGS  := 

GREEN    := \033[0;32m
YELLOW   := \033[1;33m
RED      := \033[0;31m
RESET    := \033[0m

SRCS     := $(shell find $(SRC_DIRS) -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' \))
OBJS     := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS     := $(OBJS:.o=.d)
BIN      := $(BUILD_DIR)/$(EXE)

.PHONY: all run install uninstall clean
.DEFAULT_GOAL := all

all: $(BIN)

run: $(BIN)
	@./$< $(ARGS)

install: $(BIN)
	@echo "$(GREEN)[INSTALL]$(RESET)"
	install -D -m755 $(BIN) $(PREFIX)/bin/$(EXE)

uninstall:
	@echo "$(RED)[UNINSTALL]$(RESET)"
	rm -f $(PREFIX)/bin/$(EXE)

clean:
	@echo "$(RED)[CLEAN]$(RESET)"
	rm -rf $(BUILD_DIR)

$(BIN): $(OBJS)
	@mkdir -p $(@D)
	@echo "$(GREEN)[LD] $@$(RESET)"
	$(CXX) $(LDFLAGS) $^ -o $@

$(BUILD_DIR)/%.o: %
	@mkdir -p $(@D)
	@echo "$(YELLOW)[CC] $<$(RESET)"
	$(if $(filter %.c,$<), \
		$(CC) $(CFLAGS) -I$(SRC_DIRS) -c $< -o $@, \
		$(CXX) $(CXXFLAGS) -I$(SRC_DIRS) -c $< -o $@)

-include $(DEPS)

MAKEFLAGS += -j$(shell nproc 2>/dev/null || echo 4)
