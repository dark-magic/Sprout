
#include <assert.h>
#include "node.h"

struct node * new_node(unsigned int type, struct node * child, struct node * brother, const char * value) {
    struct node * instance = malloc(sizeof(struct node));
    assert(instance);
    
    instance->child = child;
    instance->value = value;
    instance->type = type;
    instance->brother = brother;
    
    return instance;
}

struct node * append_brother(struct node * parent, struct node * brother) {
    struct node * original_parent = parent;
    
    while(parent->brother)
        parent = parent->brother;
    
    parent->brother = brother;
    
    return original_parent;
}
