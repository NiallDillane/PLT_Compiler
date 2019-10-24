%{
	/*
	 * Simple verb recognition
	 * insert C libraries here
	*/
%}

%% 

	/*
	 * Main section with RegEx
	*/

[\t ]+ // ignore whitespace

is |
am | 
are | 
were | 
was | 
be | 
being | 
been |
do |
does |
go { printf("%s: is a verb\n", yytext); }

[a-zA-Z]+ { printf("%s is not a verb\n", yytext); }

.|\n { ECHO; } // normal default anyway


	/*
		{doubleDec}[" "]+{id} { 
		printf("%s: is a declaration\n", yytext); 
		}

		{id}[" "]+("EQUALS-TO")[" "]+{id} |
		{id}[" "]+("EQUALS-TO-VALUE")[" "]+{num} { 
			printf("%s: is an assignment\n", yytext); 
		}

		INPUT[" "]+{id}["; "{id}]*"." { 
			printf("%s: is an input\n", yytext); 
		}

		PRINT[" "]+[{id}*;[" "]+]*\".*\"["; "{id}]*"." { 
			printf("%s: is an output\n", yytext); 
		}
	*/

%%

main(){
	yylex();
}