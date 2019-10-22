%{
   /*
    * Simple verb recognition
    * insert C libraries here
   */
%}

%option noyywrap
%option caseless
%option yylineno

%% 

   /*
    * Main section with RegEx
   */

[\n\t ]+ 

START. |
END-NOW. |
X+ |
[X]+-[X]+ { 
   printf("%s: is a declaration\n", yytext); 
}


END |
whatever { 
   printf("%s: is an assignment\n", yytext); 
}

X+-* |
. | \n { printf("%s is not part of the language\n", yytext); } // normal default anyway

%%

int main(){
   yylex();
}