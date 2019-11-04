parser: lexer.l parser.y lex.yy.c parser.tab.c
	flex lexer.l
	bison -d parser.y
	bison -dy parser.y
	gcc -c lex.yy.c parser.tab.c
	gcc -o parser lex.yy.o parser.tab.o -ll