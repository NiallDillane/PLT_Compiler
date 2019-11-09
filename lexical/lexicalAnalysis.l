%{
	/*
	 * 13132911 - Niall Dillane
	 * Note that I check standard ASCII quotes for strings,
	 * not unicode ones from Word, which were in the test program.
	*/
	#include <stdlib.h>
	#include <stdio.h>

	char* doubleCapacity(char *yytext);
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

START |
END-NOW | 
MAIN 				   { printf("%s: is a keyword\n", yytext); }

{doubleDec} 		{ printf("%s: is a double of capacity %s\n", yytext, 
								doubleCapacity(yytext)); }

EQUALS-TO |
EQUALS-TO-VALUE 	{ printf("%s: is an assignment\n", yytext); }

ADD |
TO 					{ printf("%s: is an assignment\n", yytext); }

INPUT 				{ printf("%s: is an input\n", yytext); }

PRINT 				{ printf("%s: is an output\n", yytext); }

{num} 				{ printf("%s: is a number\n", yytext); }

\"[^"]*\" 			{ printf("%s: is a string\n", yytext); }

{id} 					{ printf("%s: is an identifier\n", yytext); }

\. 			{ printf("%s: is the end of a line\n", yytext); }

; 						{ printf("%s: is a separator\n", yytext); }

{idChar}{8,} |
. 						{ printf("%s is not part of the language\n", yytext); }

%%

int main(){
	yylex();
}


/* For double length, which wasn't mentioned before
 * I was assessed, and was later removed as a requirement,
 * but I spent like 20 minutes on it sooo...
*/

char* doubleCapacity(char *yytext) {
	char *out = malloc(strlen(yytext));
	int count = 0;

	for (int i = 0; i < strlen(yytext); i++) {
		if (yytext[i] == 'X')
			count++;
		else if (yytext[i] == '-') {
			char *sub = malloc(strlen(yytext));
			sprintf(sub, "%d", count);
			strcat(out, sub);
			strcat(out, ".");
			count = 0;
		}
	}
	char *sub = malloc(strlen(yytext));
	sprintf(sub, "%d", count);
	strcat(out, sub);

	return out;
}
