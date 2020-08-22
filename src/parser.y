%define api.pure full
%locations
%param { yyscan_t scanner }

%code top {
    #include <stdio.h>
    #include "node.h"
    #include "error.h"
    
    #define YYERROR_VERBOSE 1
}

%code requires {
    typedef void * yyscan_t;
}

%union {
    char * string;
    struct node * ast;
}

%code {
    int yylex(YYSTYPE * yylvalp, YYLTYPE * yyllocp, yyscan_t scanner);
    void yyerror(YYLTYPE * yyllocp, yyscan_t unused, const char * msg);
    
    void dispatch(struct node *);
}

%token<string> NUMERIC_IMMEDIATE
%token<string> IDENTIFIER
%token<string> STR_CONSTANT
%token<string> CHAR_CONSTANT

%token KEYWORD_LET
%token KEYWORD_WHILE
%token KEYWORD_IF
%token KEYWORD_FN
%token KEYWORD_MUT
%token KEYWORD_CLASS
%token KEYWORD_MODULE
%token KEYWORD_EMIT
%token KEYWORD_RETURN
%token KEYWORD_EVENT
%token KEYWORD_DO
%token KEYWORD_ELSE
%token KEYWORD_MATCH
%token KEYWORD_FOR
%token KEYWORD_IMPORT
%token KEYWORD_AS

%token OP_LEFT_PAREN
%token OP_RIGHT_PAREN
%token OP_LEFT_SQPAREN
%token OP_RIGHT_SQPAREN
%token OP_DOT
%token OP_PLUS
%token OP_MINUS
%token OP_SHR
%token OP_SHL
%token OP_MOD
%token OP_SLASH
%token OP_STAR
%token OP_LEFT_BRACKET
%token OP_RIGHT_BRACKET
%token OP_TENARY
%token OP_COLON
%token OP_ARROW
%token OP_INCREMENT
%token OP_DECREMENT
%token OP_BIN_AND
%token OP_BIN_OR
%token OP_LOG_AND
%token OP_LOG_OR
%token OP_XOR
%token OP_ADD_EQ
%token OP_SUB_EQ
%token OP_SHL_EQ
%token OP_SHR_EQ
%token OP_MUL_EQ
%token OP_DIV_EQ
%token OP_MOD_EQ
%token OP_AND_EQ
%token OP_OR_EQ
%token OP_XOR_EQ
%token OP_EQ
%token OP_CMP_EQ
%token OP_CMP_GE
%token OP_CMP_LE
%token OP_CMP_GT
%token OP_CMP_LT
%token OP_CMP_NE
%token OP_TILDE
%token OP_COMMA
%token OP_BANG
%token OP_AT
%token SEMICOLON

%type<ast> ImportStatement FunctionDeclaration ParameterList ParameterListLoop FnCodeBlock Statement StatementList ReturnStatement Expression DeclarationStatement CodeBlock ConditionalStatement

%left OP_LOG_OR
%left OP_LOG_AND
%left OP_BIN_OR
%left OP_XOR
%left OP_BIN_AND
%left OP_CMP_EQ OP_CMP_NE
%left OP_CMP_GE OP_CMP_GT OP_CMP_LE OP_CMP_LT
%left OP_SHL OP_SHR
%left OP_PLUS OP_MINUS
%left OP_STAR OP_SLASH OP_MOD
%left OP_BANG OP_TILDE
%left OP_DOT OP_ARROW
%left OP_LEFT_SQPAREN OP_RIGHT_SQPAREN
%left OP_LEFT_PAREN OP_RIGHT_PAREN
%left OP_INCREMENT OP_DECREMENT

%start TopLevelScope
%%

TopLevelScope
: ImportStatement[decl] TopLevelScope { dispatch($decl); }
| FunctionDeclaration[decl] TopLevelScope { dispatch($decl); }
| %empty { dispatch(NULL); }
;

ImportStatement
: KEYWORD_IMPORT IDENTIFIER[pkg] SEMICOLON {
    $$ = new_node(ImportDeclaration, NULL, NULL, $pkg);
}
| KEYWORD_IMPORT IDENTIFIER[pkg] KEYWORD_AS IDENTIFIER[id] SEMICOLON {
    $$ = new_node(ImportDeclaration,
        new_node(AsCompound, NULL, NULL, $id),
    NULL, $pkg);
}
;

FunctionDeclaration
: KEYWORD_FN IDENTIFIER[name] ParameterList[param] FnCodeBlock[code] {
    $$ = new_node(FunctionDeclaration,
        append_brother(
            $param,
            $code
        ),
    NULL, $name);
}
| KEYWORD_FN IDENTIFIER[name] ParameterList[params] OP_COLON IDENTIFIER[return_type] FnCodeBlock[code] {
    $$ = new_node(FunctionDeclaration,
        new_node(FunctionReturnType, NULL,
            append_brother(
                $params,
                $code
            ), $return_type
        ),
    NULL, $name);
}
;

ParameterList
: OP_LEFT_PAREN ParameterListLoop[loop] OP_RIGHT_PAREN {
    $$ = new_node(ParameterList, $loop, NULL, NULL);
}
| OP_LEFT_PAREN OP_RIGHT_PAREN {
    $$ = new_node(ParameterList, NULL, NULL, NULL);
}
;

ParameterListLoop
: IDENTIFIER[param_name] OP_COLON IDENTIFIER[param_type] OP_COMMA ParameterListLoop[next] {
    $$ = new_node(Parameter,
        new_node(ParameterType, NULL, NULL, $param_type)
    , $next, $param_name);
}
| IDENTIFIER[param_name] OP_COLON IDENTIFIER[param_type] {
    $$ = new_node(Parameter,
        new_node(ParameterType, NULL, NULL, $param_type)
    , NULL, $param_name);
}
;

FnCodeBlock
: OP_LEFT_BRACKET StatementList[stmt_list] OP_RIGHT_BRACKET {
    $$ = new_node(CodeBlock, $stmt_list, NULL, NULL);
}
| OP_LEFT_BRACKET OP_RIGHT_BRACKET {
    $$ = new_node(CodeBlock, NULL, NULL, NULL);
}
;

CodeBlock
: FnCodeBlock { $$ = $1; }
| Statement { $$ = $1; }
;

StatementList
: Statement[stmt] {
    $$ = new_node(StatementList, $stmt, NULL, NULL);
}
| StatementList[next] Statement[stmt] {
    $$ = new_node(StatementList, $stmt, $next, NULL);
}
;

Statement
: ReturnStatement { $$ = $1; }
| DeclarationStatement { $$ = $1; }
| ConditionalStatement { $$ = $1; }
| SEMICOLON {
    $$ = new_node(EmptyStatement, NULL, NULL, NULL);
}
;

ConditionalStatement
: KEYWORD_IF OP_LEFT_PAREN Expression[expr] OP_RIGHT_PAREN CodeBlock[code] {
    $$ = new_node(ConditionalStatement,
        append_brother(
            $expr,
            $code
        ),
    NULL, NULL);
}

DeclarationStatement
: KEYWORD_LET IDENTIFIER[name] OP_EQ Expression[value] SEMICOLON {
    $$ = new_node(LocalDeclarationStatement, $value, NULL, $name);
}
| KEYWORD_LET IDENTIFIER[name] OP_COLON IDENTIFIER[type] OP_EQ Expression[value] SEMICOLON {
    $$ = new_node(LocalDeclarationStatement,
        new_node(VariableTypeNode, NULL, $value, $type)
    , NULL, $name);
}
| KEYWORD_MUT IDENTIFIER[name] OP_EQ Expression[value] SEMICOLON {
    $$ = new_node(MutableLocalDeclarationStatement, $value, NULL, $name);
}
| KEYWORD_MUT IDENTIFIER[name] OP_COLON IDENTIFIER[type] OP_EQ Expression[value] SEMICOLON {
    $$ = new_node(MutableLocalDeclarationStatement,
        new_node(VariableTypeNode, NULL, $value, $type),
    NULL, $name);
}
| KEYWORD_MUT IDENTIFIER[name] OP_COLON IDENTIFIER[type] SEMICOLON {
    $$ = new_node(MutableLocalDeclarationStatement,
        new_node(VariableTypeNode, NULL, NULL, $type)
    , NULL, $name);
}
;

ReturnStatement
: KEYWORD_RETURN Expression[value] SEMICOLON {
    $$ = new_node(ReturnStatement, $value, NULL, NULL);
}
| KEYWORD_RETURN SEMICOLON {
    $$ = new_node(ReturnStatement, NULL, NULL, NULL);
}
;

Expression
: NUMERIC_IMMEDIATE[imm] {
    $$ = new_node(NumericImmediate, NULL, NULL, $imm);
}
| IDENTIFIER[ref] {
    $$ = new_node(SymbolImmediate, NULL, NULL, $ref);
}
| Expression[expr1] OP_PLUS Expression[expr2] {
    $$ = new_node(AddExpression,
        append_brother(
            $expr1,
            $expr2
        ),
    NULL, NULL);
}
| Expression[expr1] OP_MINUS Expression[expr2] {
    $$ = new_node(SubtractExpression,
        append_brother(
            $expr1,
            $expr2
        ),
    NULL, NULL);
}
| Expression[expr1] OP_STAR Expression[expr2] {
    $$ = new_node(MultiplyExpression,
        append_brother(
            $expr1,
            $expr2
        ),
    NULL, NULL);
}
| Expression[expr1] OP_SLASH Expression[expr2] {
    $$ = new_node(DivideExpression,
        append_brother(
            $expr1,
            $expr2
        ),
    NULL, NULL);
}
| Expression[expr1] OP_MOD Expression[expr2] {
    $$ = new_node(ModulusExpression,
        append_brother(
            $expr1,
            $expr2
        ),
    NULL, NULL);
}
| OP_LEFT_PAREN Expression[expr] OP_RIGHT_PAREN {
    $$ = $expr;
}
;

%%

void yyerror(YYLTYPE * yyllocp, yyscan_t unused, const char * msg) {
    parser_error(msg, yyllocp->first_line, yyllocp->first_column);
}
