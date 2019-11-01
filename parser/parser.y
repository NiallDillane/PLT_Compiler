%{
/* Limited sentence recogniser 
	

	decs: 
		dec decs
		| 
	;

	dec:
		CAPACITY IDENTIFIER EOL
		| error
	;

	stmt:
	STRING {
		printf("This is your string");
	}
	| NUM {
		printf("That is a number");
	}
	| OTHER

;*/
	#include<stdio.h>

	extern int yylex();
	extern int yyerror(char *s);
	extern int yylineno;

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
prog: 
	START { printf("go fuck yourself"); }
;
%%
extern FILE *yyin;
int main(){
	yyin = stdin;
	do yyparse();
		while(!feof(yyin));
}

int yyerror(char *s){
	fprintf(stderr, "%s\n", s);
}