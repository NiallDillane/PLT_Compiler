%{
	/*
	 * Simple verb recognition
	 * insert C libraries here
	*/
%}

%option noyywrap
%option caseless
%option yylineno


doubleDec	X+|X+-X+
num			[0-9]+|[0-9]+.[0-9]+
idChar		[a-zA-Z0-9-]
id				[a-zA-Z]{1}{idChar}{0,6}

%% 

	/*
	 * Main section with RegEx
	*/

[\n\t\r ]+ 

START. |
END-NOW. | 
MAIN. { 
	printf("%s: is a keyword\n", yytext); 
}

{doubleDec} {
	printf("%s: is a double\n", yytext); 
}

EQUALS-TO |
EQUALS-TO-VALUE { 
	printf("%s: is an assignment\n", yytext); 
}

ADD |
TO { 
	printf("%s: is an assignment\n", yytext); 
}

INPUT { 
	printf("%s: is an input\n", yytext); 
}

PRINT { 
	printf("%s: is an output\n", yytext); 
}

{num} { 
	printf("%s: is a number\n", yytext); 
}

\"[^"]*\" {
	printf("%s: is a string\n", yytext); 
}

{id} { 
	printf("%s: is an identifier\n", yytext); 
}

.[" "]*$ {
	printf("%s: is the end of a line\n", yytext); 
}

; {
	printf("%s: is a separator\n", yytext);
}

{idChar}{8,} |
. { 
	printf("%s is not part of the language\n", yytext); 
}

%%

int main(){
	yylex();
}