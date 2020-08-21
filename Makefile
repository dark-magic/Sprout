.PHONY: clean all

OBJECTS = $(addprefix ./bin/, parser.tab.o lex.yy.o error.o node.o main.o interpreter.o TreeNode.o FunctionNode.o)

all: bin sprout

clean:
	rm -f $(addprefix ./src/, lex.yy.c parser.tab.c parser.tab.h) sprout
	rm -rf ./bin

./src/lex.yy.c: ./src/lexer.l
	flex -o $@ $^

./src/parser.tab.c: ./src/parser.y
	bison -d -o $@ $^

bin:
	mkdir -p ./bin

./bin/%.o: ./src/%.c
	gcc $(CFLAGS) -c -o $@ $^

./bin/%.o: ./src/%.cpp
	g++ $(CPPFLAGS) -c -o $@ $^

sprout: $(OBJECTS)
	g++ $(CPPFLAGS) -o $@ $^
