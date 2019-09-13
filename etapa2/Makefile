# Compiler to be used 
CC = gcc

# Compiler flags
# -Wall : turns on (mostly) all compiler warning
CFLAGS = -Wall

# The target executable
TARGET = etapa2

# Compiles all
all : $(TARGET)

# Links all objects file to generate the target
$(TARGET):  y.tab.c lex.yy.c lex.yy.o y.tab.o main.o
	$(CC) $(CFLAGS) lex.yy.o y.tab.o main.o -o $(TARGET) -lfl

# Generates the y.tab.c  bison file
y.tab.c: parser.y
	bison -d parser.y

# Generates the lex.yy.c flex file
lex.yy.c: scanner.l
	flex scanner.l

# Generates the lex.yy.o object file
lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

# Generates the y.tab.o object file
y.tab.o: y.tab.o
	gcc -c y.tab.c

# Generates the main.o object file
main.o: main.c
	gcc -c main.c

# Deletes object files, the target and the bison/flex files
clean:
	rm *.o $(TARGET) lex.yy.c y.tab.c