%{
	/*
	 * JIBUC Lexer
	 * Niall Dillane 
	*/
	#include "y.tab.h"
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

START					{ return(START); }

END-NOW 				{ return(END); }

MAIN             	{ return(MAIN); }

{doubleDec} 		{ yylval.var = strdup(yytext); return(CAPACITY);}

EQUALS-TO 			{ return(EQUALSTO); }

EQUALS-TO-VALUE 	{ return(EQUALSTOVALUE); }

ADD 					{ return(ADD); }

TO 					{ return(TO); }

INPUT 				{ return(INPUT); }

PRINT 				{ return(OUTPUT); }

{num} 				{ yylval.num = strdup(yytext); return(NUMBER);}

\"[^"]*\" 			{ return(STRING); }

{id} 					{ yylval.var = strdup(yytext); return(IDENTIFIER);}

.[" "]*$ 			{ return(EOL); }

; 						{ return(SEPARATOR); }

{idChar}{8,} |
. 						{ return(0); }

%%
