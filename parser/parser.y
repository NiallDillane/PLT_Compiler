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
	CAPACITY IDENTIFIER EOL { addVar($1, $2); } 
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

int addVar(char *cap, char *id){
	int i;
	for(i=0; i < 50; i++){
		if(varList[i][1] == id){ // check if id already exists
			fprintf(stderr, "Variable: %s already exists\n\ton line %d\n", id, yylineno);
			return 0;
		}
		else if(varList[i][0] == '\0'){
			break;
		}
	}
	varList[i][0] = cap;
	varList[i][1] = id;
}