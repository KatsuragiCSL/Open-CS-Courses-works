/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */

/* ----- Declarations begin: */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>
#include <string>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

static int comment_layer = 0;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

%}

%option noyywrap

/* ----- Declarations end. */


/* ----- Definitions begin: */

DARROW          =>
DIGIT           [0-9]
TYPE            [A-Z][A-Za-z0-9_]*
OBJ             [a-z][A-Za-z0-9_]*
WHITESPACES     [ \f\r\t\v]+
%Start          COMMENTS
%Start          INLINE_COMMENTS
%Start          STRING

/* ----- Definitions end. */

 /* ----- Rules begin: */
%%

 /* Nested comments */
<INITIAL,COMMENTS,INLINE_COMMENTS>"(*" {
    comment_layer++;
    BEGIN COMMENTS;
}

<COMMENTS>[^\n(*]* { }

<COMMENTS>[()*] { }

<COMMENTS>"*)" {
    comment_layer--;
    if (comment_layer == 0) {
        BEGIN 0;
    }
}

<COMMENTS><<EOF>> {
    yylval.error_msg = "EOF in comment";
    BEGIN 0;
    return ERROR;
}

"*)" {
    yylval.error_msg = "Unmatched *)";
    return ERROR;
}


 /* ===============
  * inline comments
  * ===============
  */

<INITIAL>"--" {
	BEGIN INLINE_COMMENTS;
}

<INLINE_COMMENTS>[^\n]* { }

<INLINE_COMMENTS>\n {
    curr_lineno++;
    BEGIN 0;
}

 /* =========
  * STR_CONST
  * =========
  * String constants (C syntax)
  * Escape sequence \c is accepted for all characters c. Except for
  * \n \t \b \f, the result is c.
  */

<INITIAL>\" {
	BEGIN STRING;
	yymore();
}

 /* eat up valid chars */
<STRING>[^\\\"\n]* {
	yymore();
}

 /* normal escape char */
<STRING>\\[^\n] {
	yymore();
}

 /* escaped newline */
<STRING>\\\n {
    curr_lineno++;
    yymore();
}

<STRING><<EOF>> {
    yylval.error_msg = "unexpected EOF";
    BEGIN 0;
    yyrestart(yyin);
    return ERROR;
}

 /* Unescaped newline in string */
<STRING>\n {
    yylval.error_msg = "Unescaped newlines";
    BEGIN 0;
    curr_lineno++;
    return ERROR;
}

<STRING>\" {
	  /* construct input and output string */
    std::string input(yytext, yyleng);
		std::string output = "";
		/* trace position in input */
    std::string::size_type pos;

    // remove the '\"'s on two ends.
    input = input.substr(1, input.length() - 2);

		if (input.find_first_of('\0') != std::string::npos) {
        yylval.error_msg = "String contains null chars";
        BEGIN 0;
        return ERROR;
    }

    while ((pos = input.find_first_of("\\")) != std::string::npos) {
        output += input.substr(0, pos);

        switch (input[pos + 1]) {
        case 'b':
            output += "\b";
            break;
        case 't':
            output += "\t";
            break;
        case 'n':
            output += "\n";
            break;
        case 'f':
            output += "\f";
            break;
        default:
            output += input[pos + 1];
            break;
        }

        input = input.substr(pos + 2, input.length() - 2);
    }

    output += input;

    if (output.length() >= MAX_STR_CONST) {
        yylval.error_msg = "String is too long";
        BEGIN 0;
        return ERROR;
    }

    cool_yylval.symbol = stringtable.add_string((char*)output.c_str());
    BEGIN 0;
    return STR_CONST;

}

 /* ========
  * keywords
  * ========
  */

(?i:class) { return CLASS; }

(?i:else) { return ELSE; }

(?i:fi) { return FI; }

(?i:if) { return IF; }

(?i:in) { return IN; }

(?i:inherits) { return INHERITS; }

(?i:let) { return LET; }

(?i:loop) { return LOOP; }

(?i:pool) { return POOL; }

(?i:then) { return THEN; }

(?i:while) { return WHILE; }

(?i:case) { return CASE; }

(?i:esac) { return ESAC; }

(?i:of) { return OF; }

(?i:new) { return NEW; }

(?i:isvoid) { return ISVOID; }

(?i:not) { return NOT; }

t(?i:rue) {
    cool_yylval.boolean = 1;
    return BOOL_CONST;
}

f(?i:alse) {
    cool_yylval.boolean = 0;
    return BOOL_CONST;
}

{DIGIT}+ {
    cool_yylval.symbol = inttable.add_string(yytext);
    return INT_CONST;
}

 /* White Space */
{WHITESPACES} { }

 /* TYPEID */
{TYPE} {
    cool_yylval.symbol = idtable.add_string(yytext);
    return TYPEID;
}

 /* To treat lines. */
"\n" {
    curr_lineno++;
}

 /* OBJECTID */
{OBJ} {
    cool_yylval.symbol = idtable.add_string(yytext);
    return OBJECTID;
}

 /* =========
  * operators
  * =========
  */

"<-" { return ASSIGN; }

"<=" { return LE; }

"=>" { return DARROW; }

"+" { return '+'; }

"-" { return '-'; }

"*" { return '*'; }

"/" { return '/'; }

"<" { return '<'; }

"=" { return '='; }

"." { return '.'; }

";" { return ';'; }

"~" { return '~'; }

"{" { return '{'; }

"}" { return '}'; }

"(" { return '('; }

")" { return ')'; }

":" { return ':'; }

"@" { return '@'; }

"," { return ','; }

 /* =====
  * error
  * =====
  */

[^\n] {
    yylval.error_msg = yytext;
    return ERROR;
}

%%
