%{
/* Limited sentence recogniser */
#include<stdio.h>

int yylex();
int yyerror(char *s);

%}

%token START END MAIN CAPACITY EQUALSTO EQUALSTOVALUE ADD TO 
%token INPUT OUTPUT NUMBER STRING IDENTIFIER EOL SEPARATOR

%type <var> CAPACITY
%type <var> IDENTIFIER
%type <num> NUMBER

%union{
	char *var;
	double num;
}
%%
begin: START EOL

%%
extern FILE *yyin;
main(){
	do yyparse();
		while(!feof(yyin));
}

yyerror(char *s){
	fprintf(stderr, "%s\n", s);
}