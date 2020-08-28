#include <iostream>

#include "TenaryNode.hpp"
#include "../symboltable/Symbol.hpp"

using namespace std;
Symbol TenaryNode::analyse(Symbol symParam) {
  cout << "Value: " << value << endl;
  return Symbol::EMPTY();
}

Symbol TenaryNode::execute(Symbol sym) {
  cout << "Executing: " << value << endl;
  return Symbol::EMPTY();
}
