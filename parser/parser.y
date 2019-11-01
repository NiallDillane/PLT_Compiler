%{
/* Limited sentence recogniser 
	
	stmt:
	STRING {
		printf("This is your string");
	}
	| NUM {
		printf("That is a number");
	}
	| OTHER

;
*/
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
	START EOL decs stmts END EOL { printf("valid\n"); }
;

decs: 
	dec decs
	| 
;

dec:
	CAPACITY IDENTIFIER EOL
	| error
;

stmts:
	MAIN EOL stmt stmts
	| 
;

stmt:
	IDENTIFIER EQUALSTO IDENTIFIER EOL
	| IDENTIFIER EQUALSTOVALUE NUMBER EOL
	| ADD NUMBER TO IDENTIFIER EOL
	| ADD IDENTIFIER TO IDENTIFIER EOL
	| INPUT ins EOL
	| OUTPUT outs EOL

ins:
	IDENTIFIER
	| IDENTIFIER SEPARATOR ins

outs:
	IDENTIFIER
	| STRING
	| IDENTIFIER SEPARATOR outs
	| STRING SEPARATOR outs
%%


extern FILE *yyin;
int main(){
	do yyparse();
		while(!feof(yyin));
}

int yyerror(char *s){
	fprintf(stderr, "Error: %s\n\ton line %d\n", s, yylineno);
	return 0;
}