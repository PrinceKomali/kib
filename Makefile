DC := /usr/bin/gdc
CFLAGS := -Wall
BUILD := build
SRCDIR := src
O := $(BUILD)/o

TARGET_NAME := kib

SRC := $(SRC)_$(wildcard $(SRCDIR)/*.d)
SRC := $(notdir $(SRC))
OBJS := $(patsubst %, $(O)/%.o, $(SRC))
define bold
	@printf "\x1b[1m"
endef
define print
	@echo -e "\x1b[33m$(1)\x1b[34m -> \x1b[32m$(2)\x1b[0m"
endef

all: dircheck $(BUILD)/$(TARGET_NAME)


$(BUILD)/$(TARGET_NAME): $(OBJS)
	$(call bold)
	$(call print,$^,$@)
	@$(DC) -o $@ $(SDLFLAGS) $^ 

$(O)/%.o: $(SRCDIR)/%
	$(call print,$^,$@)
	@$(DC) $(CFLAGS) -I$(SRCDIR) -c -o $@ $^  


dircheck:
	@mkdir -p $(BUILD)
	@mkdir -p $(O)

clean: 
	@find $(BUILD) -type f -delete
run: all
	$(BUILD)/$(TARGET_NAME)
.PHONY: clean run 