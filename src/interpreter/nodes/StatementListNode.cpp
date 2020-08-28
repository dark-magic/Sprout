#include <iostream>

#include "StatementListNode.hpp"
#include "../symboltable/Symbol.hpp"

using namespace std;

Symbol StatementListNode::analyse(Symbol symParam) {
  cout << "Value: " << value << endl;
  return Symbol::EMPTY();
}

Symbol StatementListNode::execute(Symbol sym) {
  cout << "Executing: " << value << endl;
  return Symbol::EMPTY();
}
