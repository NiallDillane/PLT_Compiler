parser:
	flex lexer.l
	bison -dy parser.y
	gcc -c lex.yy.c y.tab.c
	gcc -o parser lex.yy.o y.tab.o -ll
