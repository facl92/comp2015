%{

#include <stdlib.h>
#include <string.h>

#define YY_NO_INPUT

int column=1;
int line=1;
char* yytext;

int beginComCord[2];
%}

%option nounput
%option case-insensitive

INTLIT		[0-9]+

EXP			[eE]([+-])?[0-9]+
REALLIT		([0-9][0-9]*)"."([0-9][0-9]*)({EXP})?|([0-9][0-9]*){EXP}

RESERVED	arctan|abs|array|char|chr|case|const|cos|dispose|downto|eof|eoln|exp|file|for|get|goto|in|input|label|ln|nil|of|pack|packed|procedure|record|set|to|type|with|unpack|maxint|new|odd|ord|page|pred|put|read|readln|reset|rewrite|round|sin|sqr|sqrt|succ|text|trunc|write

NQUOTE		[^'\n]
STRING		'({NQUOTE}|'')*'
STRINGUN	'({NQUOTE}|'')*

SCOMM		"(*"|"{"
ECOMM		"*)"|"}"

ASSIGN  	":="
BEGIN       begin
COLON		":"
COMMA		","
DO 			do
DOT			"."
ELSE		else
END			end
FORWARD		forward
FUNCTION	function
IF			if
LBRAC		"("
NOT 		not
OUTPUT		output
PARAMSTR	paramstr
PROGRAM     program
RBRAC 		")"
REPEAT		repeat
SEMIC		";"
THEN		then
UNTIL		until
VAL 		val
VAR 		var
WHILE  		while
WRITELN 	writeln
OP1			and|or
OP2			"<"|">"|"="|"<>"|"<="|">="
OP3			"+"|"-"
OP4			"*"|"/"|mod|div

ID			([a-z]|[A-Z])([a-z]|[A-Z]|[0-9])*

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

<CODE>{INTLIT}    	{column = column + yyleng;  printf("INTLIT(%s)\n",yytext);}
<CODE>{REALLIT}    	{column = column + yyleng;  printf("REALLIT(%s)\n",yytext);}
<CODE>{STRING}    	{column = column + yyleng;  printf("STRING(%s)\n",yytext);}
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
