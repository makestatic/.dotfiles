####################################################
############## My Generic Makefile #################
######### Copyright (c) 2025 Ali Almalki ###########
############## <makestatic@github> #################
##################### GPL-3 ########################
####################################################
EXE       := program
SRC_DIRS  := source util vendor include
BUILD_DIR := build
BIN_DIR   := $(BUILD_DIR)/out
PREFIX    ?= /usr/bin/

####################################################
CC      := $(shell command -v clang 2>/dev/null || echo cc)
CXX     := $(shell command -v clang++ 2>/dev/null || echo c++)
STD_C   ?= gnu17
STD_CPP ?= gnu++17

####################################################
BASE_FLAGS   := -Wall -Wextra -Wpedantic -MMD -MP
OPT_DBG      := -O0 -ggdb3
OPT_REL      := -O3 -flto -DNDEBUG

CFLAGS_DBG   := $(BASE_FLAGS) $(OPT_DBG) -std=$(STD_C)
CXXFLAGS_DBG := $(BASE_FLAGS) $(OPT_DBG) -std=$(STD_CPP)
CFLAGS_REL   := $(BASE_FLAGS) $(OPT_REL) -std=$(STD_C)
CXXFLAGS_REL := $(BASE_FLAGS) $(OPT_REL) -std=$(STD_CPP)

LDFLAGS_DBG  :=
LDFLAGS_REL  := -flto -s

####################################################
GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
RESET  := \033[0m

####################################################
SRCS     := $(shell find $(SRC_DIRS) -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' \))
INCS     := $(addprefix -I,$(shell find $(SRC_DIRS) -type d))

DBG_OBJS := $(SRCS:%=$(BUILD_DIR)/dbg/%.o)
REL_OBJS := $(SRCS:%=$(BUILD_DIR)/rel/%.o)

DEPS_DBG := $(DBG_OBJS:.o=.d)
DEPS_REL := $(REL_OBJS:.o=.d)

BIN_DBG  := $(BIN_DIR)/$(EXE)_dbg
BIN_REL  := $(BIN_DIR)/$(EXE)

####################################################
.DEFAULT_GOAL := debug
.PHONY: debug release run run-release install uninstall clean

debug: $(BIN_DBG)
release: $(BIN_REL)

run: $(BIN_DBG)
	@./$< $(ARGS)

run-release: $(BIN_REL)
	@./$< $(ARGS)

install: $(BIN_REL)
	@echo "$(GREEN)[INSTALL]$(RESET)"
	install -D -m 755 $(BIN_REL) $(PREFIX)/$(EXE)

uninstall:
	@echo "$(RED)[UNINSTALL]$(RESET)"
	rm -f $(PREFIX)/$(EXE)

clean:
	@echo "$(RED)[CLEAN]$(RESET)"
	rm -rf $(BUILD_DIR)

####################################################
$(BIN_DBG): $(DBG_OBJS)
	@mkdir -p $(@D)
	@echo "$(GREEN)[LD] $@$(RESET)"
	$(CXX) $(LDFLAGS_DBG) $^ -o $@

$(BIN_REL): $(REL_OBJS)
	@mkdir -p $(@D)
	@echo "$(GREEN)[LD] $@$(RESET)"
	$(CXX) $(LDFLAGS_REL) $^ -o $@

####################################################
$(BUILD_DIR)/dbg/%.o: %
	@mkdir -p $(@D)
	@echo "$(YELLOW)[CC] $<$(RESET)"
	$(if $(filter %.c,$<), \
		$(CC) $(CFLAGS_DBG) $(INCS) -c $< -o $@, \
		$(CXX) $(CXXFLAGS_DBG) $(INCS) -c $< -o $@)

$(BUILD_DIR)/rel/%.o: %
	@mkdir -p $(@D)
	@echo "$(YELLOW)[CC] $<$(RESET)"
	$(if $(filter %.c,$<), \
		$(CC) $(CFLAGS_REL) $(INCS) -c $< -o $@, \
		$(CXX) $(CXXFLAGS_REL) $(INCS) -c $< -o $@)

-include $(DEPS_DBG)
-include $(DEPS_REL)

# use all cores if possible
MAKEFLAGS += -j$(shell nproc 2>/dev/null || echo 4)
