EXE       := program
SRC_DIRS  := src test include
BUILD_DIR := build
BIN_DIR   := $(BUILD_DIR)/out
ARGS      ?=

CC        := clang
CXX       := clang++
STD_C     := gnu17
STD_CPP   := gnu++17

BASE_FLAGS := -Wall -Wextra -Wpedantic -MMD -MP

OPT_DBG   := -O0 -ggdb3 -fstack-protector-strong -fno-omit-frame-pointer
OPT_REL   := -O3 -flto -fstack-protector-strong -march=native -mtune=native -DNDEBUG

CFLAGS_DBG   := $(BASE_FLAGS) $(OPT_DBG) -std=$(STD_C)
CXXFLAGS_DBG := $(BASE_FLAGS) $(OPT_DBG) -std=$(STD_CPP)
CFLAGS_REL   := $(BASE_FLAGS) $(OPT_REL) -std=$(STD_C)
CXXFLAGS_REL := $(BASE_FLAGS) $(OPT_REL) -std=$(STD_CPP)

LIBS        :=
LDFLAGS_DBG :=
LDFLAGS_REL := -flto -s

SRCS := $(shell find $(SRC_DIRS) -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' \))
INCS := $(addprefix -I,$(shell find $(SRC_DIRS) -type d))

DBG_OBJS := $(SRCS:%.c=$(BUILD_DIR)/dbg/%.o)
DBG_OBJS := $(DBG_OBJS:%.cc=$(BUILD_DIR)/dbg/%.o)
DBG_OBJS := $(DBG_OBJS:%.cpp=$(BUILD_DIR)/dbg/%.o)

REL_OBJS := $(SRCS:%.c=$(BUILD_DIR)/rel/%.o)
REL_OBJS := $(REL_OBJS:%.cc=$(BUILD_DIR)/rel/%.o)
REL_OBJS := $(REL_OBJS:%.cpp=$(BUILD_DIR)/rel/%.o)

DEPS_DBG := $(DBG_OBJS:.o=.d)
DEPS_REL := $(REL_OBJS:.o=.d)

BIN_DBG := $(BIN_DIR)/d$(EXE)
BIN_REL := $(BIN_DIR)/$(EXE)

.DEFAULT_GOAL := debug
.PHONY: debug release run clean compile_db install uninstall

debug: $(BIN_DBG)
release: $(BIN_REL)

GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
RESET  := \033[0m

run: $(BIN_DBG)
	@./$< $(ARGS)

compile_db:
	@echo "$(YELLOW)[BEAR] generating compile_commands.json$(RESET)"
	@bear -- make -B

clean:
	@echo "$(RED)[CLEAN] nuking$(RESET)"
	rm -rf $(BUILD_DIR)

install: $(BIN_REL)
	@echo "$(GREEN)[INSTALL]$(RESET)"
	cp $(BIN_REL) /usr/local/bin/$(EXE)

uninstall:
	@echo "$(RED)[UNINSTALL]$(RESET)"
	rm -f /usr/local/bin/$(EXE)

$(BUILD_DIR)/dbg/%.o: %.c
	@mkdir -p $(@D)
	@echo "$(YELLOW)[CC] $<$(RESET)"
	$(CC) $(CFLAGS_DBG) $(INCS) -c $< -o $@

$(BUILD_DIR)/dbg/%.o: %.cc
	@mkdir -p $(@D)
	@echo "$(YELLOW)[CXX] $<$(RESET)"
	$(CXX) $(CXXFLAGS_DBG) $(INCS) -c $< -o $@

$(BUILD_DIR)/dbg/%.o: %.cpp
	@mkdir -p $(@D)
	@echo "$(YELLOW)[CXX] $<$(RESET)"
	$(CXX) $(CXXFLAGS_DBG) $(INCS) -c $< -o $@

$(BUILD_DIR)/rel/%.o: %.c
	@mkdir -p $(@D)
	@echo "$(YELLOW)[CC] $<$(RESET)"
	$(CC) $(CFLAGS_REL) $(INCS) -c $< -o $@

$(BUILD_DIR)/rel/%.o: %.cc
	@mkdir -p $(@D)
	@echo "$(YELLOW)[CXX] $<$(RESET)"
	$(CXX) $(CXXFLAGS_REL) $(INCS) -c $< -o $@

$(BUILD_DIR)/rel/%.o: %.cpp
	@mkdir -p $(@D)
	@echo "$(YELLOW)[CXX] $<$(RESET)"
	$(CXX) $(CXXFLAGS_REL) $(INCS) -c $< -o $@

$(BIN_DBG): $(DBG_OBJS)
	@mkdir -p $(@D)
	@echo "$(GREEN)[LD] $@$(RESET)"
	$(CXX) $^ -o $@ $(LIBS) $(LDFLAGS_DBG)

$(BIN_REL): $(REL_OBJS)
	@mkdir -p $(@D)
	@echo "$(GREEN)[LD] $@$(RESET)"
	$(CXX) $^ -o $@ $(LIBS) $(LDFLAGS_REL)

-include $(DEPS_DBG)
-include $(DEPS_REL)

# use all cores by default
MAKEFLAGS += -j$(shell nproc)
