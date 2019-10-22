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

%%

main(){
   yylex();
}