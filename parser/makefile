parser: lexer.l parser.y lex.yy.c parser.tab.c
	flex lexer.l
	bison -dy parser.y
	gcc -c lex.yy.c parser.tab.c
	gcc -o example lex.yy.o parser.tab.o -ll