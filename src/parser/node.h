
#ifndef NODE_H
#define NODE_H

enum {
    ImportDeclaration, AsCompound, FunctionDeclaration, ParameterList, Parameter, ParameterType,
    CodeBlock, StatementList, ReturnStatement, NumericImmediate, FunctionReturnType,
    LocalDeclarationStatement, MutableLocalDeclarationStatement, VariableTypeNode,
    AddExpression, SubtractExpression, MultiplyExpression, DivideExpression, ModulusExpression,
    ConditionalStatement, ElseCompound, TypeCompound, StringImmediate, ComparisonExpresison, WhileStatement,
    ForStatement, ModuleDeclaration, AssignmentExpression, FunctionCall, LValue, DoWhileStatement,
    /* currently I'm the second one */
    PostOp, PreOp,
    ClassDeclaration, Tenary
};

struct node {
    struct node * child, * brother;
    char * value;
    unsigned int type;
};

struct node * new_node(unsigned int type, struct node * child, struct node * brother, char * value);
struct node * append_brother(struct node * parent, struct node * brother);

#endif
