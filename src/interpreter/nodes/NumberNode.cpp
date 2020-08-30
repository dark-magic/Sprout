#include <string>
#include <memory>

#include "NumberNode.hpp"
#include "../ErrorHandler.hpp"
#include "../symboltable/SymbolTable.hpp"
#include "../symboltable/Symbol.hpp"

using namespace std;

Symbol NumberNode::addSymbols() {
  return Symbol::EXPRESSION("int", stoi(value));
}

Symbol NumberNode::sematicCheck(Symbol sym) {
  return Symbol::EXPRESSION("int", stoi(value));
}

Symbol NumberNode::execute(Symbol sym) {
  for (int i = 0; i < children.size(); i++) {
    children[i]->execute();
  }

  return Symbol::EMPTY();
}
