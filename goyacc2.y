%{
#include <ctype.h>
#include <stdio.h>
%}

%start sstmt
%token SEMICOLON IMPORT STRING LP RP LCB RCB PACKAGEMAIN FUNC FUNCMAIN NUM FOR RETURN COLON COMPLEX
%token VARTOKEN VAR ASSIGN1 ASSIGN2 COMMA TYPEINT TYPEFLOAT TYPEDOUBLE TYPEBOOL TYPESTRING TYPECHAR
%token BOOL CHAR PRINT PRINTLN PRINTF SCANLN SCAN SCANF AVAR SWITCH CASE DEFAULT TYPEUINT TYPECOMPLEX
%token OR AND BITOR BITNOT BITAND EQ NE LT GT LE GE MULTIPLY DIVIDE MOD IF ELSE ELSEIF SHIFTL SHIFTR

%nonassoc PP MM MINUS NOT
%left OR AND BITNOT EQ NE LT GT LE GE SHIFTL SHIFTR
%left PLUS MULTIPLY DIVIDE MOD
%left BITOR BITAND

%%
sstmt: packstmt stmt mainfunc stmt
	| packstmt mainfunc stmt
	| packstmt stmt mainfunc
	| packstmt mainfunc
	;
packstmt : PACKAGEMAIN 		{printf("--Package setup\n|");}
	;
mainfunc : mainf 			{printf("--Main function end\n|");}
	;
stmt : stmt SEMICOLON block	{printf("|\n|");}
	| stmt block			{printf("|\n|");}
	| block					{printf("|\n|");}
block : header				{printf("--Header referencing\n");}
    | varstmt				{printf("----Variable statement\n");}
	| printstmt				{printf("----Print instruction\n");}
    | scanstmt				{printf("----Scan instruction\n");}			
    | forstmt				{printf("--For loop end\n");}
    | ifstmt				{printf("--If statement end\n");}
	| swstmt				{printf("--Switch statement end\n");}
    | dfunc					{printf("--Function declaration end\n");}
    | ufunc					{printf("----Function usage\n");}
/*	| error					{printf("!*abnormal formation\n|");}*/
	;

divider : SEMICOLON 		
    | 						
	;
header : IMPORT error 				{printf("!*header error*!\n| Usage: import >headerfile< \n|");} 
	| IMPORT STRING
    | IMPORT LP strings  RP	
	| IMPORT LP RP
	| IMPORT LP error RP 			{printf(" !*header error*!\n| Usage: import { >headerfiles< }\n|");}
	;
strings : STRING					
	| STRING divider strings
	;

mainf : FUNCMAIN LP RP mlcb RCB  
	| FUNCMAIN LP RP mlcb stmt RCB
	;
mlcb : LCB 						{printf("--Main function start\n|");}	
	;	

varstmt : /*VARTOKEN error				{printf(" !*variable statement error*!\n| Usage: var >variables< >=< >values<\n| or	var >variables types< >=< >values<\n| or	var >variables types<");}
	| VARTOKEN error exprs				{printf(" !*variable statement error*!\n| Usage: var >variables< >=< values\n| or   var >variables types< >=< values\n|");}
	|*/ VARTOKEN error ASSIGN1 error		{printf(" !*variable statement error*!\n| Usage: var >variables< = >values<\n| or   var >variables types< = >values<\n|");}
/*	| VARTOKEN vars error				{printf(" !*variable statement error*!\n| Usage: var variables >=< >values<\n|");}*/
	| VARTOKEN error ASSIGN1 exprs		{yyerror("syntax error");printf(" !*variable statement error*!\n| Usage: var >variables< = values\n| or   var >variables types< = values\n|");}
	| VARTOKEN vars error exprs			{printf(" !*variable statement error*!\n| Usage: var variables >=< values\n|");}
	| VARTOKEN vars ASSIGN1 error		{printf(" !*variable statement error*!\n| Usage: var variables = >values<\n|");}
	| VARTOKEN vars ASSIGN1 exprs

/*	| VARTOKEN vardec error				{printf(" !*variable statement error*!\n| Usage: var variables types >=< >values<\n|");}*/
	| VARTOKEN vardec ASSIGN1 error		{printf(" !*variable statement error*!\n| Usage: var variables types = >values<\n|");}
/*	| VARTOKEN vardec error exprs		{printf(" !*variable statement error*!\n| Usage: var variables types >=< values\n|");}*/
	| VARTOKEN vardec ASSIGN1 exprs

	| VARTOKEN error					{printf(" !*variable statement error*!\n| Usage: var >variables types<\n|");}
	| VARTOKEN vardec

	| error ASSIGN2 error				{printf(" !*variable statement error*!\n| Usage: >variables types< := >values<\n|");}
	| vars ASSIGN2 error				{printf(" !*variable statement error*!\n| Usage: variables types := >values<\n|");}
	| error ASSIGN2 exprs				{yyerror("syntax error");printf(" !*variable statement error*!\n| Usage: >variables types< := values\n|");}
	| vars ASSIGN2 exprs			
 
	| error ASSIGN1 error				{printf(" !*variable statement error*!\n| Usage: >variables< := >values<\n|");}	
	| vars ASSIGN1 error				{printf(" !*variable statement error*!\n| Usage: variables := >values<\n|");}
	| error ASSIGN1 exprs				{yyerror("syntax error");printf(" !*variable statement error*!\n| Usage: >variables< := values\n|");}
	| vars ASSIGN1 exprs			
	;
vardec : vars type COMMA vardec
	| vars type
	;
exprs : expr COMMA exprs
	| expr
vars : VAR COMMA vars
	| VAR
	;
type : TYPEINT
	| TYPEUINT
	| TYPEFLOAT
	| TYPEDOUBLE
	| TYPEBOOL
	| TYPECHAR
	| TYPESTRING
	| TYPECOMPLEX
	;

printstmt : PRINTLN LP error RP			{printf(" !*print error*!\n| Usage: fmt.Println( >exprssions< )\n|");}
	| PRINTLN LP exprs RP
	| PRINT LP error RP					{printf(" !*print error*!\n| Usage: fmt.Print( >exprssions< )\n|");}
	| PRINT LP exprs RP
	| PRINTF LP error RP				{printf(" !*print error*!\n| Usage: fmt.Prinf( >\"string\"<, >exprssions< )\n|");}
	| PRINTF LP error COMMA exprs RP	{printf(" !*print error*!\n| Usage: fmt.Prinf( >\"string\"<, exprssions )\n|");}
	| PRINTF LP STRING error RP			{printf(" !*print error*!\n| Usage: fmt.Prinf( \"string\", >exprssions< )\n|");}
	| PRINTF LP STRING COMMA exprs RP
	;
scanstmt : SCANLN LP error RP			{printf(" !*input error*!\n| Usage: fmt.Scanln( >variable_addresses< )\n|");}
	| SCANLN LP avars RP
	| SCAN LP error RP					{printf(" !*input error*!\n| Usage: fmt.Scan( >variable_addresses< )\n|");}
	| SCAN LP avars RP
	| SCANF LP error RP					{printf(" !*input error*!\n| Usage: fmt.Scanf( >\"string\"<, >variable_addresses< )\n|");}
	| SCANF LP STRING error RP			{printf(" !*input error*!\n| Usage: fmt.Scanf( \"string\", >variable_addresses< )\n|");}
	| SCANF LP error COMMA avars RP		{printf(" !*input error*!\n| Usage: fmt.Scanf( >\"string\"<, variable_addresses )\n|");}
	| SCANF LP STRING COMMA avars RP
	;
avars : AVAR COMMA avars
	| AVAR
	;

expr : expr OR expr 
	| expr AND expr
	| expr BITOR expr
	| expr BITNOT expr
	| expr BITAND expr
	| expr EQ expr
	| expr NE expr
	| expr LE expr
	| expr GE expr
	| expr LT expr
	| expr GT expr
	| expr SHIFTL expr
	| expr SHIFTR expr
	| expr PLUS expr 
	| expr MINUS expr
	| expr MULTIPLY expr
	| expr DIVIDE expr
	| expr MOD expr
	| PP expr
	| MM expr
	| MINUS expr
	| NOT expr
	| LP expr RP
	| expr PP
	| expr MM
	| VAR
	| NUM
	| COMPLEX
	| STRING
	| BOOL
	| CHAR
	| ufunc
	;

forstmt : FOR error forlcb error RCB {printf(" !*for statement error*!\n| Usage: for >compare_statement< { >statements< }\n|");}
	| FOR error forlcb stmt RCB		{printf(" !*for statement error*!\n| Usage: for >compare_statement< { statements }\n|");}
	| FOR pfstmt forlcb error RCB	{printf(" !*for statement error*!\n| Usage: for compare_statement { >statements< }\n|");}
	| FOR pfstmt forlcb stmt RCB
	| FOR error forlcb RCB			{printf(" !*for statement error*!\n| Usage: for >compare_statement< { statements }\n|");}
	| FOR pfstmt forlcb RCB
	;
forlcb : LCB		 				{printf("--For loop start\n|\n|");}	
	;
pfstmt : LP fstmt RP
    | fstmt
	| fcstmt
	;
fstmt : fdstmt SEMICOLON fcstmt SEMICOLON fcstmt
	;
fdstmt :
	| VAR ASSIGN2 expr				
	;
fcstmt : 
	| expr
	;

ifstmt : IF error iflcb error RCB el	{printf(" !*if statement error*!\n| Usage: if >compare_statement< { >statements< }\n|");}
	| IF error iflcb stmt RCB el		{printf(" !*if statement error*!\n| Usage: if >compare_statement< { statements }\n|");}
	| IF iftmp iflcb error RCB el		{printf(" !*if statement error*!\n| Usage: if compare_statement { >statements< }\n|");}
	| IF iftmp iflcb stmt RCB el
	| IF error iflcb RCB el				{printf(" !*if statement error*!\n| Usage: if >compare_statement< { statements }\n|");}
	| IF iftmp iflcb RCB el
	;
iftmp : VAR ASSIGN2 expr SEMICOLON expr {printf("*(short variable statement defore if statement)*\n|");}
	| expr
	;
iflcb: LCB 								{printf("--If statement start\n|");}
el : 
	| ELSE elselcb error RCB			{printf(" !*else statement error*!\n| Usage: else { >statements< }\n|");}
    | ELSE elselcb stmt RCB
	| ELSE elselcb RCB
	| ELSEIF error eliflcb error RCB el	{printf(" !*else if statement error*!\n| Usage: else if >compare_statement< { >statements< }\n|");}
	| ELSEIF error eliflcb stmt RCB el	{printf(" !*else if statement error*!\n| Usage: else if >compare_statement< { statements }\n|");}
	| ELSEIF expr eliflcb error RCB el	{printf(" !*else if statement error*!\n| Usage: else if compare_statement { >statements< }\n|");}
    | ELSEIF expr eliflcb stmt RCB el
	| ELSEIF error eliflcb RCB el		{printf(" !*else if statement error*!\n| Usage: else if >compare_statement< { statements }\n|");}
	| ELSEIF expr eliflcb RCB el
	;
elselcb : LCB						{printf("--Else\n|");}
	;
eliflcb : LCB						{printf("--Else if\n|");}
	;

swstmt :SWITCH error swlcb error RCB		{printf(" !*switch statement error*!\n| Usage: switch >expression< { >case_statement< }\n|");}
	| SWITCH error swlcb casestmt RCB        {printf(" !*switch statement error*!\n| Usage: switch >expression< { case_statement }\n|");}
	| SWITCH dstmt_swvar swlcb error RCB        {printf(" !*switch statement error*!\n| Usage: switch expression { >case_statement< }\n|");}
	| SWITCH dstmt_swvar swlcb casestmt RCB
	;
swlcb : LCB 						{printf("--Switch statement start\n|");} 
dstmt_swvar : 
	| expr
	| VAR ASSIGN2 expr SEMICOLON		{printf("*(short variable statement defore switch statement)*\n|");}
	| VAR ASSIGN2 expr SEMICOLON expr	{printf("*(short variable statement defore switch statement)*\n|");}
	;
casestmt :
	| divider CASE error cscolon error casestmt	{printf(" !*case statement error*!\n| Usage: case >expression< : >statement< \n|");}
	| divider CASE error cscolon stmt casestmt	{printf(" !*case statement error*!\n| Usage: case >expression< : statement \n|");}
	| divider CASE error cscolon casestmt 		{printf(" !*case statement error*!\n| Usage: case >expression< : statement \n|");}
	| divider CASE expr cscolon error casestmt	{printf(" !*case statement error*!\n| Usage: case expression : >statement< \n|");}
	| divider CASE expr cscolon stmt casestmt
	| divider CASE expr cscolon casestmt
	| DEFAULT dfcolon error						{printf(" !*default statement error*!\n| Usage: default : >statement< \n|");}
	| DEFAULT dfcolon stmt
	| DEFAULT dfcolon 
	;
cscolon : COLON 					{printf("--Case\n|");}
	;
dfcolon : COLON						{printf("--Default\n|");}
	;


dfunc : FUNC error LP error RP dfr	{printf(" !*function declaration error*!\n| Usage: func >function_name<( >parameters< ) \n|");}
	| FUNC error LP vardec RP dfr	{printf(" !*function declaration error*!\n| Usage: func >function_name<( parameters ) \n|");}
	| FUNC VAR LP error RP dfr		{printf(" !*function declaration error*!\n| Usage: func function_name( >parameters< ) \n|");}
	| FUNC VAR LP vardec RP dfr
	| FUNC error LP RP dfr			{printf(" !*function declaration error*!\n| Usage: func >function_name<( parameters ) \n|");}
	| FUNC VAR LP RP dfr
	;
dflcb : LCB 							{printf("--Function declaration start\n|");}
	;
dfr: dflcb error RCB								{printf(" !*function statement error*!\n| Usage: func function_name( parameters ) { >statements< } \n|");}
	| dflcb stmt RCB	
	| dflcb	RCB

	| error dflcb error RCB					{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types< { >statements< >return variables< } \n|");}
	| error dflcb error RETURN exprs RCB	{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types< { >statements< return variables } \n|");}
	| error dflcb stmt error RCB			{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types< { statements >return variables< } \n|");}
	| atype dflcb error RCB					{printf(" !*function return error*!\n| Usage: func function_name( parameters ) return_types { >statements< >return variables< } \n|");}
	| error dflcb stmt RETURN exprs RCB 	{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types< { statements return variables } \n|");}
	| atype dflcb error RETURN exprs RCB	{printf(" !*function return error*!\n| Usage: func function_name( parameters ) return_types { >statements< return variables } \n|");}
	| atype dflcb stmt error RCB			{printf(" !*function return error*!\n| Usage: func function_name( parameters ) return_types { statements >return variables< } \n|");}
	| atype dflcb stmt RETURN RCB			{yyerror("syntax error");printf(" !*function return error*!\n| Usage: func function_name( parameters ) return_types { statements >return variables< } \n| or	func function_name( parameters ) >return_types_and_values< { statements return } \n|");}
	| atype dflcb stmt RETURN exprs RCB 	

	| error dflcb RETURN exprs RCB			{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types< { statements return variables } \n|");}
	| atype dflcb RETURN exprs RCB

	| LP error RP dflcb error RCB				{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types_and_values< { >statements< >return< } \n| or	func function_name( parameters ) >return_types_and_values< { >statements< >return variables< } \n|");}
	| LP error RP dflcb error RETURN RCB		{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types_and_values< { >statements< return } \n|");}
	| LP error RP dflcb stmt error RCB			{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types_and_values< { statements >return< } \n| or   func function_name( parameters ) >return_types_and_values< { statements >return variables< } \n|");}
	| LP vardec RP dflcb error RCB				{printf(" !*function return error*!\n| Usage: func function_name( parameters ) return_types_and_values { >statements< >return< } \n| or   func function_name( parameters ) return_types_and_values { >statements< >return variables< } \n|");}
	| LP error RP dflcb stmt RETURN RCB			{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types_and_values< { statements return } \n|");}
	| LP vardec RP dflcb error RETURN RCB		{printf(" !*function return error*!\n| Usage: func function_name( parameters ) return_types_and_values { >statements< return } \n|");}
	| LP vardec RP dflcb stmt error RCB			{printf(" !*function return error*!\n| Usage: func function_name( parameters ) return_types_and_values { statements >return< } \n| or   func function_name( parameters ) return_types_and_values { statements >return variables< } \n|");}
    | LP vardec RP dflcb stmt RETURN RCB

	| LP error RP dflcb RETURN RCB				{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types_and_values< { statements return } \n|");}
	| LP vardec RP dflcb RETURN RCB

	| LP error RP dflcb error RETURN exprs RCB	{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types_and_values< { >statements< return variables } \n|");}
	| LP error RP dflcb stmt RETURN exprs RCB	{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types_and_values< { statements return variables } \n|");}
	| LP vardec RP dflcb error RETURN exprs RCB	{printf(" !*function return error*!\n| Usage: func function_name( parameters ) return_types_and_values { >statements< return variables } \n|");}
    | LP vardec RP dflcb stmt RETURN exprs RCB

	| LP error RP dflcb RETURN exprs RCB		{printf(" !*function return error*!\n| Usage: func function_name( parameters ) >return_types_and_values< { statements return variables } \n|");}
    | LP vardec RP dflcb RETURN exprs RCB 
	;

	

atype : LP types RP
	| type
	;
types : type COMMA types
	| type
	;

ufunc : VAR LP exprs RP
	| VAR LP RP
	;
%%
extern int linenum;
int main(){
	printf("----------------------------------\n");
	printf("| Go programming language parser |\n");
	printf("----------------------------------\n|");
	return yyparse();
}
int yyerror(char *s){
	fprintf(stderr, "| *line %d: %s\n",linenum, s);
}
int yywrap(void){
	printf("\n----------------------------------\n");
	printf("|       End of the parser        |\n");
	printf("----------------------------------\n");
}
