#include <iostream>

#include "VariableTypeNodeNode.hpp"
#include "../symboltable/Symbol.hpp"

using namespace std;
Symbol VariableTypeNodeNode::analyse(Symbol sym) {
  cout << "Value: " << value << endl;
  return Symbol();
}

Symbol VariableTypeNodeNode::execute(Symbol sym) {
  cout << "Executing: " << value << endl;
  return Symbol();
}
