# Compiler to be used 
CC = gcc

# Compiler flags
# -Wall : turns on (mostly) all compiler warning
CFLAGS = -Wall

# The target executable
TARGET = lexical_analyzer

# Compiles all
all : $(TARGET)

# Links all objects file to generate the target
$(TARGET):  lex.yy.c lex.yy.o main.o
	$(CC) $(CFLAGS) lex.yy.o main.o -o $(TARGET) -lfl

# Generates the lex.yy.c file
lex.yy.c: scanner.l
	flex scanner.l

# Generates the lex.yy.o object file
lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

# Generates the main.o object file
main.o: main.c
	gcc -c main.c

# Deletes object files, the target and the lexical analyzer
clean:
	rm *.o $(TARGET) lex.yy.c