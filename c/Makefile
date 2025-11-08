####################################################
######### Copyright (c) 2025 Ali Almalki ###########
############## <makestatic@github> #################
##################### BSD-3 ########################
####################################################

EXE       := program
SRC_DIRS  := src1 src2
BUILD_DIR := build
PREFIX    ?= /usr
CC        := $(shell command -v clang 2>/dev/null || echo gcc)
CXX       := $(shell command -v clang++ 2>/dev/null || echo g++)
CFLAGS    := -Wall -Wextra -Wpedantic -ggdb -O3 -std=gnu17 -MMD -MP
CXXFLAGS  := -Wall -Wextra -Wpedantic -ggdb -O3 -fno-exceptions -std=gnu++17 -MMD -MP
LDFLAGS   :=                     

SRCS      := $(shell find $(SRC_DIRS) -type f \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' \))
OBJS      := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS      := $(OBJS:.o=.d)
BIN       := $(BUILD_DIR)/$(EXE)

GREEN     := \033[0;32m
RED       := \033[0;31m
RESET     := \033[0m


.PHONY: all clean install uninstall

all: $(BIN)

$(BIN): $(OBJS)
	@mkdir -p $(@D)
	@printf "$(GREEN)%s$(RESET)\n" "$(CXX) $^ $(LDFLAGS) -o $@"
	@$(CXX) $^ $(LDFLAGS) -o $@

$(BUILD_DIR)/%.o: %
	@mkdir -p $(@D)
	$(eval EXT := $(suffix $<))
	$(eval COMP := $(CC))
	$(if $(filter .cpp .cc,$(EXT)),$(eval COMP := $(CXX)))
	@printf "$(GREEN)%s$(RESET)\n" "$(COMP) $(if $(filter .c,$(EXT)),$(CFLAGS),$(CXXFLAGS)) -I$(SRC_DIRS) -c $< -o $@"
	@$(COMP) $(if $(filter .c,$(EXT)),$(CFLAGS),$(CXXFLAGS)) -I$(SRC_DIRS) -c $< -o $@

-include $(DEPS)

install: $(BIN)
	@echo "$(GREEN)"
	install -D -m755 $(BIN) $(PREFIX)/bin/$(EXE)
	@echo "$(RESET)"

uninstall:
	@echo "$(RED)"
	rm -f $(PREFIX)/bin/$(EXE)
	@echo "$(RESET)"

clean:
	@echo "$(RED)"
	rm -rf $(BUILD_DIR)
	@echo "$(RESET)"
