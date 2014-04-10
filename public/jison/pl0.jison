%token CALL WHILE DO VAR CONST NUMBER ID BEGIN END IF ELSE THEN PROCEDURE ODD

%left IF
%left THEN
%left ELSE

/* operator associations and precedence */
%right '='
%left ADDSUBOP
%left MULTDIVOP
%left '^'
%right '%'
%left UMINUS
%left '!'

%start program 
 
%% /* language grammar */
program
	: block "." EOF {return $1}
	;

/*block = [ "const" ident "=" number {";" ident "=" number} ";"]
        [ "var" ident {"," ident} ";"]
        { "procedure" ident ";" block ";" } statement .*/

block
	: constant variable procedure statement { $$ = { constante: $1, var: $2, procedimiento: $3, stat: $4 }; }
	;

variable 
	: /* empty */
	| VAR idlist ";" variable { $$ = { type: $1, left: $2, right: $4 }; }
	;
idlist
	: ID {$$ = $1;}
	| idlist ","  ID { $$ = { type: $2, left: $1, right: $3 }; }
	;

constant 
	: /* empty */
	| CONST constantlist ";" constant { $$ = { type: $1, left: $2, right: $4 }; }
	;

constantlist
	: simpleconstant {$$ = $1;}
	| constantlist ","  simpleconstant { $$ = { type: $2, left: $1, right: $3 }; }
	;

simpleconstant
	: ID "=" NUMBER { $$ = { type: $2, left: $1, right: $3 }; }
	;

argumentlist
	: factor {$$ = $1;}
	| argumentlist ","  factor  { $$ = { type: $2, left: $1, right: $3 }; }
	| /* empty */
	;


procedure
	: /* empty */
	| PROCEDURE ID "(" argumentlist ")" ";" block ";" procedure{ $$ = { type: $1, left: $2, arguments: $4, right: $7 }; }
	;

/*statement = [ ident ":=" expression | "call" ident |
            "begin" statement {";" statement } "end" |
            "if" condition "then" statement |
            "while" condition "do" statement ]*/
statement
	: ID "=" expresion { $$ = { type: $2, left: $1, right: $3 }; }
	| CALL ID "(" argumentlist ")" { $$ = { type: $1, left: $2, right: $4 }; }
	| BEGIN statementlist END { $$ = { type: $1, left: null, right: $2 }; }
	| ifstatement {$$ = $1;}
	| WHILE '(' condition ')'  DO statement { $$ = { type: $1, left: $2, right: $4 }; }
	;

ifstatement
	: IF '(' condition ')' THEN statement { $$ = { type: $1, left: $2, right: $4 }; }
	| IF '(' condition ')' THEN statement ELSE statement { $$ = { type: $1, cond: $2, then: $4, else: $6 }; }
	;

statementlist
	: statement {$$ = $1;}
	| statementlist ";" statement { $$ = { type: $2, left: $1, right: $3 }; }
	;

/*condition = "odd" expression |
            expression ("="|"#"|"<"|"<="|">"|">=") expression */

condition
	: ODD expresion { $$ = { type: $1, left: null, right: $2 }; }
	| expresion COMPARISON expresion { $$ = { type: $2, left: $1, right: $3 }; }
	;

/*expression = [ "+"|"-"] term { ("+"|"-") term}.*/
expresion
	: ADDSUBOP termlist { $$ = { type: $1, left: null, right: $2 }; }
	| termlist	{$$ = $1;}
	;

termlist
	: term {$$ = $1;}
	| termlist ADDSUBOP term { $$ = { type: $2, left: $1, right: $3 }; }
	;


/*term = factor {("*"|"/") factor}.*/
term
	: factorlist {$$ = $1;}
	;


factorlist
	: factor {$$ = $1;}
	| factorlist MULTDIVOP factor { $$ = { type: $2, left: $1, right: $3 }; }
	;
/*factor = ident | number | "(" expression ")".*/
factor
	: ID {$$ = {type: 'ID', value: yytext};}
	| NUMBER { $$ = {type: 'NUMBER', value: yytext};}
	| "(" expresion ")" {$$ = $2;}
	;
