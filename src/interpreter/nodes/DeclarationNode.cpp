#include <string>
#include <memory>
#include <variant>

#include "DeclarationNode.hpp"
#include "../ErrorHandler.hpp"
#include "../symboltable/SymbolTable.hpp"
#include "../symboltable/Symbol.hpp"
#include "../../parser/node.h"

using namespace std;

DeclarationNode::DeclarationNode(struct node * n, bool mut) : DeclarationNode(n) {
  isMut = mut;
}

Symbol DeclarationNode::addSymbols() {
	Symbol s;
  string type = children[0]->addSymbols().dataType;

	if (isMut) {
    if (type.compare("string") == 0) {
      s = Symbol::MUTABLE(value,type,"");
    }
    else {
      s = Symbol::MUTABLE(value,type,0);
    }
	}
  else {
		if (type.compare("string") == 0) {
      s = Symbol::MUTABLE(value,type,"");
    }
    else {
      s = Symbol::MUTABLE(value,type,0);
    }
	}

	SymbolTable::getInstance()->add(s);
  return Symbol::EMPTY();
}

Symbol DeclarationNode::sematicCheck(Symbol sym) {
  shared_ptr<SymbolTable> syms = SymbolTable::getInstance();
  cout  << type << ":  " << syms->get(value).dataType << "  " << value << endl;
  
  for (int i = 0; i < children.size(); i++) {
    children[i]->sematicCheck();
  }

  return Symbol::EMPTY();
}

Symbol DeclarationNode::execute(Symbol param) {
  shared_ptr<SymbolTable> syms = SymbolTable::getInstance();
  Symbol sym = syms->get(value);

  if (children[0]->type != VariableTypeNode || children.size() == 2) {
    sym.value = children[children.size() - 1]->execute().value;
    syms->add(sym);
  }

  cout << value << ": " << get<int>(syms->get(value).value) << endl;
  return Symbol::EMPTY();
}
