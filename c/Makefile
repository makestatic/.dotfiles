BUILD_DIR = build
OBJ_DIR   = $(BUILD_DIR)/obj
BIN_DIR   = $(BUILD_DIR)/bin
EXE      = $(BIN_DIR)/program

CC       = cc
CXX      = c++

DEBUG_FLAGS   = -Wall -Wextra -Wpedantic -O0 -ggdb3
RELEASE_FLAGS = -O2 -flto -march=native -DNDEBUG -fvisibility=hidden

CFLAGS   = $(DEBUG_FLAGS)
CXXFLAGS = $(DEBUG_FLAGS)
CPPFLAGS = -MMD -MP

LDFLAGS         =               # debug default
RELEASE_LDFLAGS = -flto -s
LDLIBS          =

DIRS := source

# recursive source finder in $(DIRS)
rwildcard = $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
SRC := $(foreach d,$(DIRS),$(call rwildcard,$d,*.c *.cc *.cpp))

# mirror structure in build/obj
OBJ := $(patsubst %, $(OBJ_DIR)/%, $(SRC))
OBJ := $(OBJ:%.c=%.o)
OBJ := $(OBJ:%.cc=%.o)
OBJ := $(OBJ:%.cpp=%.o)
DEP := $(OBJ:.o=.d)

GREEN  = \033[0;32m
RESET  = \033[0m

all: $(EXE)

release: CFLAGS=$(RELEASE_FLAGS)
release: CXXFLAGS=$(RELEASE_FLAGS)
release: LDFLAGS=$(RELEASE_LDFLAGS)
release: clean $(EXE)

$(EXE): $(OBJ)
	@mkdir -p $(dir $@)
	@echo "$(GREEN)[LINK] $@$(RESET)"
	$(CXX) $(OBJ) -o $@ $(LDFLAGS) $(LDLIBS)

# compile rules
$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	@echo "$(GREEN)[CC] $<$(RESET)"
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: %.cc
$(OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	@echo "$(GREEN)[CXX] $<$(RESET)"
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@

clean:
	@echo "$(GREEN)[CLEAN]$(RESET)"
	rm -rf $(BUILD_DIR)

run: all
	@echo "$(GREEN)[RUN] $(EXE)$(RESET)"
	$(EXE)

-include $(DEP)

# parallel builds by default
ifeq ($(filter -j%,$(MAKEFLAGS)),)
  MAKEFLAGS += -j$(shell nproc)
endif
