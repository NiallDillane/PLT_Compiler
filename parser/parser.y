%{
/* 
 * JIBUC parser
*/
	#include <stdio.h>
	#include <string.h>
	#include <stdbool.h>
	#include <ctype.h>
	#define RED "\x1B[31m"
	#define GRN "\x1B[32m"
	#define RESET "\x1B[0m"

	int yylex();
	int yyerror(char *s);
	char* catError(char *s, char *t);
	char* doubleX(char *val);
	int addVar(char *cap, char *id);
	char* lookup(char *id);
	void checkVar(char *id1, char *id2);
	int checkVal(char *id, char *val);

	int yylineno;
	char *varList[50][2];
	bool valid = true;

%}

%token START END MAIN CAPACITY EQUALSTO EQUALSTOVALUE ADD TO 
%token INPUT OUTPUT NUMBER STRING IDENTIFIER EOL SEPARATOR

%type <var> CAPACITY
%type <var> IDENTIFIER
%type <num> NUMBER

%union {
	char *var;
	char *num;
}

%%
prog: 
	START EOL decs MAIN EOL stmts END EOL 
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
	IDENTIFIER EQUALSTO IDENTIFIER EOL { checkVar($1, $3); }
	| IDENTIFIER EQUALSTOVALUE NUMBER EOL { checkVal($1, $3); }
	| ADD NUMBER TO IDENTIFIER EOL { checkVal($4, $2); }
	| ADD IDENTIFIER TO IDENTIFIER EOL { checkVar($2, $4); }
	| INPUT ins EOL
	| OUTPUT outs EOL

ins:
	id
	| id SEPARATOR ins

outs:
	id
	| STRING
	| id SEPARATOR outs
	| STRING SEPARATOR outs

id:
  	IDENTIFIER { lookup($1); }
%%


extern FILE *yyin;
int main() {
	// Read this file
	yyin = fopen("sampleJIBUC.txt", "r");
	do yyparse();
		while (!feof(yyin));

	if (valid)
		printf(GRN "valid file\n" RESET);
	return 0;
}

int yyerror(char *s) {
	fprintf(stderr, RED "Error " RESET "on line %d:\n\t%s\n", yylineno, s);
	valid = false;
	return 0;
}

char* catError(char *s, char *t) {
	char *catmsg = malloc(strlen(s) + strlen(t));
	strcpy(catmsg, s);
	strcat(catmsg, t);
	return catmsg;
}

char* doubleX(char *val){
	for (int j = 0; j < strlen(val); j++){
		if (isdigit(val[j]))
			val[j] = 'X';
		else
			val[j] = '-';
	}
	return val;
}

int addVar(char *cap, char *id) { 
	int i;
	for (i=0; i < 50; i++) {
		if (varList[i][0] == '\0'){
			break;
		}
		else if (strcmp(varList[i][1], id) == 0) { // check if id already exists
			yyerror(catError("Variable already exists: ", id));
			return 0;
		}
	}
	varList[i][0] = cap;
	varList[i][1] = id;

	// printf("%d:\t %s , %s\n", i, varList[i][0], varList[i][1]);

	return 0;
}

/* find the capacity of an id */
char* lookup(char *id) {
	for (int i=0; i < 50; i++) {
		if (varList[i][0] == '\0'){
			yyerror(catError("id not declared: ", id));
			return NULL;
		}
		else if (strcmp(varList[i][1], id) == 0){
			return varList[i][0];
		}
	}
	return NULL;
}

void checkVar(char *id1, char *id2){
	if (lookup(id1) == NULL)
		; // id 1 not declared
	else if (lookup(id2) == NULL)
		; // id 2 not declared
	else if (strcmp(lookup(id1), lookup(id2)) != 0)
		yyerror("id capacities do not match");
}

int checkVal(char *id, char *val){
	int i;
	for (i=0; i < 50; i++) {
		if (varList[i][0] == '\0'){
			yyerror(catError("Variable not declared: ", id));
			return 0;
		}
		else if (strcmp(varList[i][1], id) == 0) { 
			char *valX = doubleX(val);

			if (!(strcmp(varList[i][0], valX) == 0))
				yyerror("id capacity and number format do not match");
			return 0;
		}
	}
	return 0;
}
