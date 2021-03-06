#include <string>
#include <memory>

#include "EventNode.hpp"
#include "../ErrorHandler.hpp"
#include "../symboltable/SymbolTable.hpp"
#include "../symboltable/Symbol.hpp"
#include "../../parser/node.h"

using namespace std;

EventNode::EventNode(struct node * n) {
	line = n->line;
  col = n->col;

  value = (n->value) ? string(n->value) : "";
  type = n->type;

  n = n->child->child;
  while (n) {
    children.push_back(TreeNode::of(n));
    n = n->brother;
  }
}

Symbol EventNode::addSymbols() {
  shared_ptr<SymbolTable> syms = SymbolTable::getInstance();

  for (int i = 0; i < children.size(); i++) {
    children[i]->addSymbols();
  }
  return Symbol::EMPTY();
}

Symbol EventNode::sematicCheck(Symbol sym) {
  shared_ptr<SymbolTable> syms = SymbolTable::getInstance();
  cout << type << ":  " << value << endl;
  
  for (int i = 0; i < children.size(); i++) {
    children[i]->sematicCheck();
  }

  return Symbol::EMPTY();
}

Symbol EventNode::execute(Symbol sym) {
  for (int i = 0; i < children.size(); i++) {
    children[i]->execute();
  }

  return Symbol::EMPTY();
}
