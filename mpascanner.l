%{
//asdassad
#include <stdlib.h>
#include <string.h>

#define YY_NO_INPUT

int column;
int line;
char* yytext;

int beginComCord[2];
%}

%option nounput

A [aA]
B [bB]
C [cC]
D [dD]
E [eE]
F [fF]
G [gG]
H [hH]
I [iI]
J [jJ]
K [kK]
L [lL]
M [mM]
N [nN]
O [oO]
P [pP]
Q [qQ]
R [rR]
S [sS]
T [tT]
U [uU]
V [vV]
W [wW]
X [xX]
Y [yY]
Z [zZ]

INTLIT		([1-9][0-9]*)|0

EXP			[eE]([+-])?[0-9]+
REALLIT		([0-9][0-9]*)"."([0-9][0-9]*)({EXP})?|([1-9][0-9]*){EXP}

RESERVED	{A}{R}{R}{A}{Y}|{C}{H}{A}{R}|{C}{A}{S}{E}|{C}{O}{N}{S}{T}|{D}{O}{W}{N}{T}{O}|{F}{I}{L}{E}|{F}{O}{R}|{G}{O}{T}{O}|{I}{N}|{L}{A}{B}{E}{L}|{N}{I}{L}|{O}{F}|{P}{A}{C}{K}{E}{D}|{P}{R}{O}{C}{E}{D}{U}{R}{E}|{R}{E}{C}{O}{R}{D}|{S}{E}{T}|{T}{O}|{T}{Y}{P}{E}|{W}{I}{T}{H}

NQUOTE		[^'\n]
STRING		\'([^'\n]|\'\')*\'
STRINGUN	\'([^'\n]|\'\')*

SCOMM		"(*"|"{"
ECOMM		"*)"|"}"

ASSIGN  	":="
BEGIN       {B}{E}{G}{I}{N}
COLON		":"
COMMA		","
DO 			{D}{O}
DOT			"."
ELSE		{E}{L}{S}{E}
END			{E}{N}{D}
FORWARD		{F}{O}{R}{W}{A}{R}{D}
FUNCTION	{F}{U}{N}{C}{T}{I}{O}{N}
IF			{I}{F}
LBRAC		"("
NOT 		{N}{O}{T}
OUTPUT		{O}{U}{T}{P}{U}{T}
PARAMSTR	{P}{A}{R}{A}{M}{S}{T}{R}
PROGRAM     {P}{R}{O}{G}{R}{A}{M}
RBRAC 		")"
REPEAT		{R}{E}{P}{E}{A}{T}
SEMIC		";"
THEN		{T}{H}{E}{N}
UNTIL		{U}{N}{T}{I}{L}
VAL 		{V}{A}{L}
VAR 		{V}{A}{R}
WHILE  		{W}{H}{I}{L}{E}
WRITELN 	{W}{R}{I}{T}{E}{L}{N}
OP1			{A}{N}{D}|{O}{R}
OP2			"<"|">"|"="|"<>"|"<="|">="
OP3			"+"|"-"
OP4			"*"|"/"|{M}{O}{D}|{D}{I}{V}

ID			([a-z]|[A-Z)([a-z]|[A-Z]|[0-9])*

%S COMMENT
%S CODE

%%
					{BEGIN CODE;}
<CODE>{SCOMM}		{beginComCord[0]=line; beginComCord[1]=column; column = column + yyleng; BEGIN COMMENT;}
<COMMENT><<EOF>>	{printf("Line %d, col %d: unterminated comment\n",beginComCord[0], beginComCord[1]);return 0;}
<COMMENT>{ECOMM}	{column = column + yyleng; BEGIN CODE;}
<COMMENT>\n 		{line++;column=1;}
<COMMENT>.			{column = column + yyleng;}


<CODE>{ASSIGN}  	{column = column + yyleng; printf("ASSIGN\n");}
<CODE>{BEGIN}  		{column = column + yyleng; printf("BEGIN\n");}
<CODE>{COLON}  		{column = column + yyleng; printf("COLON\n");}
<CODE>{COMMA}  		{column = column + yyleng; printf("COMMA\n");}
<CODE>{DO}  		{column = column + yyleng; printf("DO\n");}
<CODE>{DOT}  		{column = column + yyleng; printf("DOT\n");}
<CODE>{ELSE}  		{column = column + yyleng; printf("ELSE\n");}
<CODE>{END}  		{column = column + yyleng; printf("END\n");}
<CODE>{FORWARD}  	{column = column + yyleng; printf("FORWARD\n");}
<CODE>{FUNCTION}  	{column = column + yyleng; printf("FUNCTION\n");}
<CODE>{IF}  		{column = column + yyleng; printf("IF\n");}
<CODE>{LBRAC}  		{column = column + yyleng; printf("LBRAC\n");}
<CODE>{NOT}  		{column = column + yyleng; printf("NOT\n");}
<CODE>{OUTPUT}  	{column = column + yyleng; printf("OUTPUT\n");}
<CODE>{PARAMSTR}  	{column = column + yyleng; printf("PARAMSTR\n");}
<CODE>{PROGRAM}  	{column = column + yyleng; printf("PROGRAM\n");}
<CODE>{RBRAC}  		{column = column + yyleng; printf("RBRAC\n");}
<CODE>{REPEAT}  	{column = column + yyleng; printf("REPEAT\n");}
<CODE>{SEMIC}  		{column = column + yyleng; printf("SEMIC\n");}
<CODE>{THEN}  		{column = column + yyleng; printf("THEN\n");}
<CODE>{UNTIL}  		{column = column + yyleng; printf("UNTIL\n");}
<CODE>{VAL}  		{column = column + yyleng; printf("VAL\n");}
<CODE>{VAR}  		{column = column + yyleng; printf("VAR\n");}
<CODE>{WHILE}  		{column = column + yyleng; printf("WHILE\n");}
<CODE>{WRITELN}  	{column = column + yyleng; printf("WRITELN\n");}
<CODE>{OP1}  		{column = column + yyleng; printf("OP1(%s)\n",yytext);}
<CODE>{OP2}  		{column = column + yyleng; printf("OP2(%s)\n",yytext);}
<CODE>{OP3}			{column = column + yyleng; printf("OP3(%s)\n",yytext);}
<CODE>{OP4}         {column = column + yyleng; printf("OP4(%s)\n",yytext);}
<CODE>{RESERVED}    {column = column + yyleng; printf("RESERVED(%s)\n",yytext);}

<CODE>{INTLIT}    	{column = column + yyleng;  printf("INTLIT(%d)\n",atoi(yytext));}
<CODE>{STRING}    	{column = column + yyleng;  printf("STRING(%s)\n",yytext);}
<CODE>{REALLIT}    	{column = column + yyleng;  printf("REALLIT(%s)\n",yytext);}
<CODE>{STRINGUN}	{printf("Line %d, col %d: unterminated string\n",line,column);column = column + yyleng;}

<CODE>{ID}     		{column = column + yyleng;  printf("ID(%s)\n",yytext);}

<CODE>\t			{column = column + yyleng;}
<CODE>" "			{column = column + yyleng;}
<CODE><<EOF>>      	{column++; yyterminate(); return 0;}
<CODE>.				{printf("Line %d, col %d: illegal character ('%s')\n",line,column,yytext);column = column + yyleng;}
<CODE>\n			{column=1; line++;}
%%
void yyerror (char *s){
	printf ("Line %d, col %lu: %s: %s\n", line, column-yyleng, s, yytext);
}

int yywrap()
{
return 1;
}
