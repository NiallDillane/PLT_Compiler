%{
/* Limited sentence recogniser */
#include<stdio.h>
%}
%token NOUN VERB ARTICLE
%%
sentence: ARTICLE NOUN VERB ARTICLE NOUN 
	{ printf("Is a valid Sentence!\n"); } 
%%
extern FILE *yyin;
main(){
	do yyparse();
		while(!feof(yyin));
}

yyerror(char *s){
	fprintf(stderr, "%s\n", s);
}