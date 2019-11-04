%{
/* 
 * JIBUC parser
*/
	#include <stdio.h>
	#define RED "\x1B[31m"
	#define GRN "\x1B[32m"
	#define RESET "\x1B[0m"

	int yylex();
	int yyerror(char *s);
	int addVar(char *cap, char *id);
	int yylineno;
	char *varList[50][2];

%}

%token START END MAIN CAPACITY EQUALSTO EQUALSTOVALUE ADD TO 
%token INPUT OUTPUT NUMBER STRING IDENTIFIER EOL SEPARATOR

%type <var> CAPACITY
%type <var> IDENTIFIER
%type <num> NUMBER

%union {
	char *var;
	double num;
}

%%
prog: 
	START EOL decs MAIN EOL stmts END EOL { printf(GRN "valid file\n" RESET); }
;

decs: 
	dec decs
	| 
;

dec:
	CAPACITY IDENTIFIER EOL { addVar($1, $2); } 
	| error
;

stmts:
	stmt stmts
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
int main() {
	yyin = fopen("sampleJIBUC.txt", "r");
	do yyparse();
		while(!feof(yyin));
	return 0;
}

int yyerror(char *s) {
	fprintf(stderr, RED "Error: %s\n\ton line %d\n" RESET, s, yylineno);
	return 0;
}

int addVar(char *cap, char *id) { 
	int i;
	for(i=0; i < 50; i++) {
		if(varList[i][1] == id) { // check if id already exists
			fprintf(stderr, RED "Variable: %s already exists\n\ton line %d\n" RESET, id, yylineno);
			return 0;
		}
		else if(varList[i][0] == '\0'){
			break;
		}
	}
	varList[i][0] = cap;
	varList[i][1] = id;

	printf("%d:\t %s , %s\n", i, varList[i][0], varList[i][1]);

	return 0;
}