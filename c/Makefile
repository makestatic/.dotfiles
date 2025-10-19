####################################################
######### Copyright (c) 2025 Ali Almalki ###########
############## <makestatic@github> #################
##################### BSD-3 ########################
####################################################

EXE       := program
# src dirs including 'include dirs'
SRC_DIRS  := source util vendor
BUILD_DIR := build
PREFIX    ?= /usr

CC  ?= gcc
CXX ?= g++
STD_C   ?= gnu17
STD_CPP ?= gnu++17:

COMMON_FLAGS := -Wall -Wextra -Wpedantic -ggdb -O3 -MMD -MP
CFLAGS       := $(COMMON_FLAGS) -std=$(STD_C)
CXXFLAGS     := $(COMMON_FLAGS) -std=$(STD_CPP)
LDFLAGS      := 

# Pretty output colors
GREEN    := \033[0;32m
YELLOW   := \033[1;33m
RED      := \033[0;31m
BLUE     := \033[0;34m
RESET    := \033[0m

# Source and object files
SRCS := $(shell find $(SRC_DIRS) -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' \))
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)
BIN  := $(BUILD_DIR)/$(EXE)

.PHONY: all run install uninstall clean
.DEFAULT_GOAL := all

# Build the executable
all: $(BIN)

# Run target
run: $(BIN)
	@echo "$(GREEN)[run]$(RESET) $(EXE)"
	@echo "./$(BIN) $(ARGS)"
	@./$(BIN) $(ARGS)

# Install
install: $(BIN)
	@echo "$(GREEN)[install]$(RESET) $(BIN) => $(PREFIX)/bin/$(EXE)"
	@echo "install -D -m755 $(BIN) $(PREFIX)/bin/$(EXE)"
	@install -D -m755 $(BIN) $(PREFIX)/bin/$(EXE)

# Uninstall
uninstall:
	@echo "$(RED)[uninstall]$(RESET) $(PREFIX)/bin/$(EXE)"
	@echo "rm -f $(PREFIX)/bin/$(EXE)"
	@rm -f $(PREFIX)/bin/$(EXE)

# Clean
clean:
	@echo "$(RED)[clean]$(RESET) deleting $(BUILD_DIR)"
	@echo "rm -rf $(BUILD_DIR)"
	@rm -rf $(BUILD_DIR)

# Link the final executable
$(BIN): $(OBJS)
	@mkdir -p $(@D)
	@echo "$(BLUE)[LD]$(RESET) $(@F)"
	@echo "$(CXX) $(LDFLAGS) $^ -o $@"
	@$(CXX) $(LDFLAGS) $^ -o $@

# Compile source files
$(BUILD_DIR)/%.o: %
	@mkdir -p $(@D)
	@FILE_NAME=$(notdir $<); \
	echo "$(YELLOW)[CC]$(RESET) $$FILE_NAME"; \
	if echo "$<" | grep -qE '\.c$$'; then \
		echo "$(CC) $(CFLAGS) -I$(SRC_DIRS) -c $< -o $@"; \
		$(CC) $(CFLAGS) -I$(SRC_DIRS) -c $< -o $@; \
	else \
		echo "$(CXX) $(CXXFLAGS) -I$(SRC_DIRS) -c $< -o $@"; \
		$(CXX) $(CXXFLAGS) -I$(SRC_DIRS) -c $< -o $@; \
	fi

# Include dependencies for incremental builds
-include $(DEPS)

# Use all CPU cores if not fallback to 1 core
MAKEFLAGS += -j$(shell nproc 2>/dev/null || echo 1)
