
WORK_PATH=../../work
LIB_PATH=../../work/lib
MAIN_PATH=../../work/target

CURRENT_PATH=$(shell pwd)
PROGRAM_NAME=$(shell basename $(CURRENT_PATH))
PROGRAM_SOURCE=$(shell ls $(PROGRAM_NAME).main.*)
SOURCES=*.asm 

OBJECTS=$(SOURCES:.asm=.o)
LIBS = $(foreach dir, $(OBJECTS), $(addprefix $(LIB_PATH)/, $(dir)))
#LIBS = $(filter-out $(LIB_PATH)/$(PROGRAM_NAME).main.o, $(LIBS))

.PHONY: init clean

all: run

# Compile all asm files
lib: init $(LIBS)
	
# Compile an asm program
compile_$(PROGRAM_NAME).main.asm: init lib
	ld $(LIBS) -o $(MAIN_PATH)/$(PROGRAM_NAME)

# Compile an c program
compile_$(PROGRAM_NAME).main.c: init lib
	gcc -no-pie $(PROGRAM_SOURCE) $(LIBS) -o $(MAIN_PATH)/$(PROGRAM_NAME)

build: compile_$(PROGRAM_SOURCE)

$(MAIN_PATH)/$(PROGRAM_NAME): build

run: $(MAIN_PATH)/$(PROGRAM_NAME)
	$(MAIN_PATH)/$(PROGRAM_NAME)

test:
	@echo test

$(LIB_PATH)/%.o: %.asm
	@echo Compile: $^
	nasm $^ -o $@ -felf64

init:
	mkdir -p $(WORK_PATH)
	mkdir -p $(WORK_PATH)/lib
	mkdir -p $(WORK_PATH)/target
	
clean:
	@echo "Clean $(WORK_PATH)"
	rm -rf $(WORK_PATH)

info:
	@echo "OBJECTS:$(OBJECTS)"
	@echo "LIBS:$(LIBS)"
	@echo "CURRENT_PATH:$(CURRENT_PATH)"
	@echo "PROGRAM_NAME:$(PROGRAM_NAME)"
	@echo "PROGRAM_SOURCE:$(PROGRAM_SOURCE)"

#    $@ : produit (ou but) de la règle 
#    $< : nom de la première dépendance (ou source) 
#    $? : toutes les dépendances plus récentes que le but 
#    $^ : toutes les dépendances 
#    $+ : idem mais chaque dépendance apparait autant de fois qu'elle est cité et l'ordre d'apparition est conservé. 