#include <string>
#include <memory>

#include "TypeNode.hpp"
#include "../ErrorHandler.hpp"
#include "../symboltable/SymbolTable.hpp"
#include "../symboltable/Symbol.hpp"

using namespace std;

TypeNode::TypeNode(struct node * n, bool ref) : TypeNode(n) {
  isRef = ref;
}

Symbol TypeNode::addSymbols() {
  return Symbol::TYPE(value);
}

Symbol TypeNode::sematicCheck(Symbol sym) {
  shared_ptr<SymbolTable> syms = SymbolTable::getInstance();
  
  for (int i = 0; i < children.size(); i++) {
    children[i]->sematicCheck();
  }

  return Symbol::EMPTY();
}

Symbol TypeNode::execute(Symbol sym) {
  for (int i = 0; i < children.size(); i++) {
    children[i]->execute();
  }

  return Symbol::EMPTY();
}
