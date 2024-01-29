

ifndef ROOT_PATH
$(error ROOT_PATH is not set)
endif

WORK_PATH     ?=$(ROOT_PATH)/work
TEST_PATH     ?=$(ROOT_PATH)/test

LIB_PATH      ?=$(WORK_PATH)/lib
MAIN_PATH     ?=$(WORK_PATH)/target
DEBUG_PATH    ?=$(WORK_PATH)/debug
TEST_WORK_PATH?=$(WORK_PATH)/test

CURRENT_PATH?=$(shell pwd)
INCLUDE_PATH=$(CURRENT_PATH)
# PROGRAM_NAME: name of the programm/test to build. 
#               be default, it's the name of the folder.
PROGRAM_NAME?=$(shell basename $(CURRENT_PATH))
# PROGRAM_SOURCE: the name of the source file that contain the main.
#                 It's the PROGRAM_NAME following by `.main` and than the extansion `.c` or `.asm`
PROGRAM_SOURCE?=$(shell ls $(PROGRAM_NAME).main.*)
# TEST_SOURCE: the name of the source file that contain tests.
#              It's the PROGRAM_NAME following by `.test.c`
TEST_SOURCE?=$(shell ls $(PROGRAM_NAME).test.*)
# PROGRAM_TEST: The name of the output file for tests.
PROGRAM_TEST?=$(TEST_SOURCE:.c=)
# SOURCES_ASM: List of all `.asm` files.
SOURCES_ASM?=$(wildcard *.asm)
# LIBS_ASM: List of `.asm` library files (not a `.main.asm`).
LIBS_ASM?=$(filter-out %.main.asm,$(SOURCES_ASM))
# LIB_OBJECTS: List of `.o` to build from `.asm`files.
LIB_OBJECTS?=$(LIBS_ASM:%.asm=%.o)
# LIBS: List of full path `.o` to build from `.asm`files.
LIBS?=$(foreach obj_file, $(LIB_OBJECTS), $(addprefix $(LIB_PATH)/, $(obj_file)))

DEBUGS=$(foreach obj_file, $(LIB_OBJECTS), $(addprefix generate_debug_, $(obj_file)))

INCLUDE_OPTION?=$(INCLUDE_PATH:%=-I%)

PYTHON=python3

.PHONY: init clean

all: run

# Compile all asm files
lib: init $(LIBS)
	
# Compile an asm program
compile_$(PROGRAM_NAME).main.asm: init lib $(LIB_PATH)/$(PROGRAM_NAME).main.o
	@echo Compile: $(PROGRAM_NAME).main.asm
	@ld $(LIB_PATH)/$(PROGRAM_NAME).main.o $(LIBS) -o $(MAIN_PATH)/$(PROGRAM_NAME)

# Compile an c program
compile_$(PROGRAM_NAME).main.c: init lib
	@echo Compile: $(PROGRAM_NAME).main.c
	@gcc -no-pie $(PROGRAM_SOURCE) $(LIBS) $(INCLUDE_OPTION) -o $(MAIN_PATH)/$(PROGRAM_NAME)

# Compile asm files
$(LIB_PATH)/%.o: %.asm
	@echo Compile: $^
	@nasm $^ -o $@ -felf64

build: compile_$(PROGRAM_SOURCE)

$(MAIN_PATH)/$(PROGRAM_NAME): build

# Run main program
run: $(MAIN_PATH)/$(PROGRAM_NAME)
	@echo Execute: $(PROGRAM_NAME)
	@$(MAIN_PATH)/$(PROGRAM_NAME)

test: init lib
	@echo Generate test launcher
	@bash $(TEST_PATH)/build_test_file.sh $(TEST_SOURCE) $(TEST_WORK_PATH)/$(TEST_SOURCE)
	@echo Compile test file: $(TEST_SOURCE)
	@gcc -no-pie $(TEST_WORK_PATH)/$(TEST_SOURCE) $(LIBS) -I$(TEST_PATH) -I$(WORK_PATH)/examples/print $(INCLUDE_OPTION) -o $(MAIN_PATH)/$(PROGRAM_TEST)
	@echo Execute tests
	@$(MAIN_PATH)/$(PROGRAM_TEST)

generate_debug_%.o: %.asm
	@echo Generate debug file: $<
	
	@$(PYTHON) $(ROOT_PATH)/scripts/generate_debug.py . $(<:%.asm=%) $(DEBUG_PATH)

	@echo Compile: $^
	@nasm $(DEBUG_PATH)/$(<:%.asm=%.debug.asm) -o $(LIB_PATH)/$(<:%.asm=%.o) -felf64


compile_debug_%.main: %.main.c
	@echo Generate debug file: $<
	@$(PYTHON) $(ROOT_PATH)/scripts/generate_debug_c_file.py . $(<:%.c=%) $(DEBUG_PATH)
	@echo Compile: $(PROGRAM_NAME).main.c
	@gcc -no-pie $(DEBUG_PATH)/$(PROGRAM_NAME).main.debug.c $(LIB_PATH)/print.o $(LIB_PATH)/debug.o $(foreach obj_file, $(LIB_OBJECTS), $(addprefix $(LIB_PATH)/, $(obj_file))) -o $(MAIN_PATH)/$(PROGRAM_NAME).debug
	                                                        
lib_for_debug:
	@nasm $(ROOT_PATH)/examples/print/print.asm -o $(LIB_PATH)/print.o -felf64
	@nasm $(ROOT_PATH)/examples/debug/debug.asm -o $(LIB_PATH)/debug.o -felf64

$(MAIN_PATH)/$(PROGRAM_NAME).debug: compile_debug_$(PROGRAM_NAME).main

debug: init $(DEBUGS) lib_for_debug $(MAIN_PATH)/$(PROGRAM_NAME).debug
	$(MAIN_PATH)/$(PROGRAM_NAME).debug $(DEBUG_PATH)/debug.data
	@$(PYTHON) $(ROOT_PATH)/scripts/format_debug.py $(DEBUG_PATH)/debug.data $(DEBUG_PATH)

init:
	@echo Create working dirs
	@mkdir -p $(WORK_PATH)
	@mkdir -p $(LIB_PATH)
	@mkdir -p $(MAIN_PATH)
	@mkdir -p $(DEBUG_PATH)
	@mkdir -p $(TEST_WORK_PATH)
	
clean:
	@echo "Clean $(WORK_PATH)"
	@rm -rf $(WORK_PATH)

info:
	@echo "SOURCES_ASM:$(SOURCES_ASM)"
	@echo "LIBS_ASM:$(LIBS_ASM)"
	@echo "INCLUDE_OPTION:$(INCLUDE_OPTION)"
	@echo "LIB_OBJECTS:$(LIB_OBJECTS)"	
	@echo "LIBS:$(LIBS)"
	@echo "CURRENT_PATH:$(CURRENT_PATH)"
	@echo "PROGRAM_NAME:$(PROGRAM_NAME)"
	@echo "TEST_PATH:$(TEST_PATH)"
	@echo "TEST_SOURCE:$(TEST_SOURCE)"
	@echo "TEST_WORK_PATH:$(TEST_WORK_PATH)"
	@echo "DEBUGS:$(DEBUGS)"
	

#    $@ : produit (ou but) de la règle 
#    $< : nom de la première dépendance (ou source) 
#    $? : toutes les dépendances plus récentes que le but 
#    $^ : toutes les dépendances 
#    $+ : idem mais chaque dépendance apparait autant de fois qu'elle est cité et l'ordre d'apparition est conservé. 