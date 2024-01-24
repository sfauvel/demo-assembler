ROOT_PATH     =../..
WORK_PATH     =$(ROOT_PATH)/work
TEST_PATH     =$(ROOT_PATH)/test
TEST_WORK_PATH=$(WORK_PATH)/test
LIB_PATH      =$(ROOT_PATH)/work/lib
MAIN_PATH     =$(ROOT_PATH)/work/target

CURRENT_PATH=$(shell pwd)
PROGRAM_NAME=$(shell basename $(CURRENT_PATH))
PROGRAM_SOURCE=$(shell ls $(PROGRAM_NAME).main.*)
TEST_SOURCE=$(shell ls $(PROGRAM_NAME).test.*)
PROGRAM_TEST=$(TEST_SOURCE:.c=)
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

test: init lib
	bash $(TEST_PATH)/build_test_file.sh $(TEST_SOURCE) $(TEST_WORK_PATH)/$(TEST_SOURCE)
	gcc -no-pie $(TEST_WORK_PATH)/$(TEST_SOURCE) $(LIBS) -I$(TEST_PATH) -I$(WORK_PATH)/examples/print -o $(MAIN_PATH)/$(PROGRAM_TEST)
	$(MAIN_PATH)/$(PROGRAM_TEST)

$(LIB_PATH)/%.o: %.asm
	@echo Compile: $^
	nasm $^ -o $@ -felf64

init:
	mkdir -p $(WORK_PATH)
	mkdir -p $(LIB_PATH)
	mkdir -p $(MAIN_PATH)
	mkdir -p $(TEST_WORK_PATH)
	
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