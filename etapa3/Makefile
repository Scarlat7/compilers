# Compiler to be used 
CC = gcc

# Compiler flags
# -Wall : turns on (mostly) all compiler warning
CFLAGS = -Wall

# The target executable
TARGET = etapa3

# Path to include
INC = -I ./include/

# Source files
SRC = $(wildcard src/*.c)
OBJ = $(SRC:src/%.c=%.o)

# Compiles all
all : $(TARGET)

# Links all objects file to generate the target
$(TARGET):  $(OBJ) parser.tab.c lex.yy.c lex.yy.o parser.tab.o main.o 
	$(CC) $(CFLAGS) $(INC) $< lex.yy.o parser.tab.o main.o -o $(TARGET) -lfl

# Generates the y.tab.c  bison file
parser.tab.c: parser.y
	bison -d parser.y -v

# Generates the lex.yy.c flex file
lex.yy.c: scanner.l
	flex scanner.l

# Generates the lex.yy.o object file
lex.yy.o: lex.yy.c
	$(CC) $(INC) -c lex.yy.c

# Generates the parser.tab.o object file
parser.tab.o: parser.tab.c 
	$(CC) $(INC) -c parser.tab.c 

# Generates the main.o object file
main.o: main.c
	$(CC) $(INC) -c main.c

# Misc library
$(OBJ): $(SRC)
	$(CC) $(INC) $(CFLAGS) -c $< -o $@

# Deletes object files, the target and the bison/flex files
clean:
	rm *.o $(TARGET) lex.yy.c parser.tab.c parser.tab.h parser.output