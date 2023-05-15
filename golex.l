%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
int linenum = 1;
%}


%%

";"                                       {return SEMICOLON;}

"import"                                  {return IMPORT;}

"("                                       {return LP;}
")"                                       {return RP;}

"package"[ ]+"main"                       {return PACKAGEMAIN;}
"func"                                    {return FUNC;}
"func"[ ]+"main"						  {return FUNCMAIN;}
"{"                                       {return LCB;}
"}"                                       {return RCB;}

"var"                                     {return VARTOKEN;}

"TRUE"|"true"|"FALSE"|"false"             {return BOOL;}
"="                                       {return ASSIGN1;}
":="                                      {return ASSIGN2;}

","                                       {return COMMA;}
"int"|"int8"|"int16"|"int32"|"int64"      {return TYPEINT;}
"uint"|"uint8"|"uint16"|"uint32"|"uint64"|"uintptr" {return TYPEUINT;}
"float32"|"float64"                       {return TYPEFLOAT;}
"double"                                  {return TYPEDOUBLE;}
"bool"                                    {return TYPEBOOL;}
"char"                                    {return TYPECHAR;}
"string"                                  {return TYPESTRING;}
"complex64"|"complex128"				  {return TYPECOMPLEX;}

"fmt.Println"                             {return PRINTLN;}
"fmt.Print"                               {return PRINT;}
"fmt.Printf"                              {return PRINTF;}
"fmt.Scanln"                              {return SCANLN;}
"fmt.Scan"                                {return SCAN;}
"fmt.Scanf"                               {return SCANF;}

"||"                                      {return OR;}
"&&"                                      {return AND;}
"|"                                       {return BITOR;}
"^"                                       {return BITNOT;}
"&"                                       {return BITAND;}
"=="                                      {return EQ;}
"!="                                      {return NE;}
"<"                                       {return LT;}
">"                                       {return GT;}
"<="                                      {return LE;}
">="                                      {return GE;}
"+"                                       {return PLUS;}
"-"                                       {return MINUS;}
"*"                                       {return MULTIPLY;}
"/"                                       {return DIVIDE;}
"%"                                       {return MOD;}
"++"	                                  {return PP;}
"--"									  {return MM;}
"!"                                       {return NOT;}
"<<"									  {return SHIFTL;}
">>"									  {return SHIFTR;}

"for"                                     {return FOR;}
"if"                                      {return IF;}
"else"                                    {return ELSE;}
"else if"								  {return ELSEIF;}

"switch"                                  {return SWITCH;}
"case"                                    {return CASE;}
"default"                                 {return DEFAULT;}
":"										  {return COLON;}

"return"                                  {return RETURN;}

["].*["]                                  {return STRING;}
['].[']                                   {return CHAR;}
[&][a-zA-Z][_a-zA-Z0-9]*                  {return AVAR;}
[-]?[1-9][0-9]*|[0]                       {return NUM;}
[-]?[0-9]*[.][0-9]+$                      {return NUM;}
[-]?[1-9][0-9]*[i]						  {return COMPLEX;}
[a-zA-Z][_a-zA-Z0-9]*                     {return VAR;}
[a-zA-Z][_a-zA-Z0-9]*[.][A-Z][_a-zA-Z0-9]* {return VAR;}
"//"[^\n]*[\n]			  				  {printf("*(Comment detected)*\n|");}
"/*".*"*/"								  {printf("*(comment detected)*\n|");}

[ \t]                                     {;}
[\n]									  {++linenum;/*printf("|\n");*/}
.                                         {printf("unexpected character\n");}

%%
