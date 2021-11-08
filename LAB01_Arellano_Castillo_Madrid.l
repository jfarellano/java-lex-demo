%{
#include<stdio.h>
#include <stdlib.h>
#include <string.h>
int idC = 1;
char ids[99999];
int lexErrorsC = 1;
char lexErrors[99999];
%}
	
ID 			[a-zA-Z][0-9a-zA-Z]*
CTE-ENTERA	[-+]?[0-9]+
CTE-REAL	[-+]?[0-9]+((".")[0-9]+)?([eE][-+]?[0-9]+((".")[0-9]+)?)?
ERROR 		[0-9]+[0-9a-zA-Z]+
%%

"public"	    {fprintf(yyout, "PUBLIC=%s", yytext);}
"private"	    {fprintf(yyout, "PRIVATE=%s", yytext);}
"protected"	    {fprintf(yyout, "PROTECTED=%s", yytext);}


"static"   	    {fprintf(yyout, "STATIC=%s", yytext);}
"void"			{fprintf(yyout, "VOID=%s", yytext);}
"class"         {fprintf(yyout, "CLASS=%s", yytext);}
"new"           {fprintf(yyout, "NEW=%s", yytext);}

"return"		{fprintf(yyout, "INS-RETORNAR=%s", yytext);}

"if"			{fprintf(yyout, "SI=%s", yytext);}
"else"			{fprintf(yyout, "SINO=%s", yytext);}
"while"			{fprintf(yyout, "MIENTRAS-QUE=%s", yytext);}
"for"			{fprintf(yyout, "PARA=%s", yytext);}
"break"			{fprintf(yyout, "INS-TERMINAR=%s", yytext);}

"int"|"double"|"char"|"String"			{fprintf(yyout, "TIPO=%s", yytext);}

{ID}			{
					// Print out.
					fprintf(yyout, "ID=%s", yytext);

					// Finf if unique
					char *token;
				    char temp[9999];
				    strcpy(temp,ids);
				    int save = 1;
				    token = strtok(temp, ";");
				    while(token != NULL && save) {
				        if (strcmp(token,yytext) == 0) save = 0;
				        token = strtok(NULL, ";");
				    }
				    if (save) {
				        if (idC > 1) strcat(ids,";");
				        strcat(ids,yytext);
				        idC = idC + 1;
				    }
				}

"=" 		{fprintf(yyout, "OP-ASIGN=%s", yytext);}

{CTE-ENTERA}	{fprintf(yyout, "CTE-ENTERA=%s", yytext);}
{CTE-REAL}		{fprintf(yyout, "CTE-REAL=%s", yytext);}
\".*\"	{fprintf(yyout, "CTE-CADENA=%s", yytext);}

"//".*\n?       				{fprintf(yyout, "");}
"/*"([^*]|\*+[^*/])*\*+"/"		{fprintf(yyout, "");} 

"(" 			{fprintf(yyout, "PARENT-A=%s", yytext);}
")" 			{fprintf(yyout, "PARENT-C=%s", yytext);}
"[" 			{fprintf(yyout, "CORCHETE-A=%s", yytext);}
"]" 			{fprintf(yyout, "CORCHETE-C=%s", yytext);}

"*"				{fprintf(yyout, "OP-MULT=%s", yytext);}
"+"				{fprintf(yyout, "OP-SUMA=%s", yytext);}
"-"				{fprintf(yyout, "OP-SUST=%s", yytext);}
"/"				{fprintf(yyout, "OP-DIV=%s", yytext);}
"%"				{fprintf(yyout, "OP-MOD=%s", yytext);}
"++"|"--"|"+="|"-="|"*="|"/="    {fprintf(yyout, "OP-ARIT-ESP=%s", yytext);}

"&&"			{fprintf(yyout, "OP-Y=%s", yytext);}
"||"			{fprintf(yyout, "OP-O=%s", yytext);}
"!"			{fprintf(yyout, "OP-NO=%s", yytext);}

"=="			{fprintf(yyout, "IGUAL=%s", yytext);}
">"				{fprintf(yyout, "MAYOR=%s", yytext);}
"<"				{fprintf(yyout, "MENOR=%s", yytext);}
"<>"|"!="		{fprintf(yyout, "DIFERENTE=%s", yytext);}
"<="			{fprintf(yyout, "MENOR-IGUAL=%s", yytext);}
">="			{fprintf(yyout, "MAYOR-IGUAL=%s", yytext);}

"{" 			{fprintf(yyout, "LLAVE-A=%s", yytext);}
"}"				{fprintf(yyout, "LLAVE-C=%s", yytext);}

" "				{fprintf(yyout, " ");}	
\t 				{fprintf(yyout, "\t");}
\n				{fprintf(yyout, "\n");}
\r				{fprintf(yyout, "\r");}

";"				{fprintf(yyout, "PUNTO-COMA=%s", yytext);}
":"				{fprintf(yyout, "DOS-PUNTOS=%s", yytext);}
","				{fprintf(yyout, "BLOQUE-INST=%s", yytext);}

{ERROR}			{
					fprintf(yyout, "CARACTER-NO-RECONOCIDO=%s", yytext);
					char *token;
				    char temp[9999];
				    strcpy(temp,lexErrors);
				    int save = 1;
				    token = strtok(temp, ";");
				    while(token != NULL && save) {
				        printf("%s\n", token);
				        if (strcmp(token,yytext) == 0) save = 0;
				        token = strtok(NULL, ";");
				    }
				    if (save) {
				        if (lexErrorsC > 1) strcat(lexErrors,";");
				        strcat(lexErrors,yytext);
				        lexErrorsC = lexErrorsC + 1;
				    }
				}

.           	{fprintf(yyout, "CARACTER-NO-RECONOCIDO=%s", yytext);
					if (!strstr(lexErrors, yytext)) {
						if (lexErrorsC > 1) strcat(lexErrors,";");
						strcat(lexErrors,yytext);
						lexErrorsC = lexErrorsC + 1;
					}
				}

%%

int yywrap(){}
int main(int argc, char *argv[]) 
{
	printf("Lo que has recibido en el argv[1] es: %s\n", argv[1]);
	FILE *fp = fopen(argv[1], "r");
	FILE *out_file = fopen("salida.txt", "w"); // write only
    yyin = fp;
    yyout = out_file;
    yylex();

    fprintf(out_file,"\n\nTABLA DE INDENTIFICADORES\n");
    fprintf(out_file, "Hay %d identificadores\n", idC-1);
    if (idC>1)
    {
    	int i=0;
    	fprintf(out_file, " Id=");
    	while (i < strlen(ids)) 
    	{    
    		fprintf(out_file, "%c", ids[i]);
    		if (ids[i] == ';')
    		{
    			fprintf(out_file, " Id=");
    		}
		    i = i + 1;
		}
    }
    fprintf(out_file, "\n");

    fprintf(out_file,"\n\nERRORES LEXICOS\n");
    fprintf(out_file, "Hay %d errores lexicos\n", lexErrorsC-1);
    fprintf(out_file, "%s", lexErrors);
    fprintf(out_file, "\n");

    fclose(out_file);
    fclose(fp);
    return(0);
}

