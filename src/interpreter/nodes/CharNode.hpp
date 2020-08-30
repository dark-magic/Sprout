#pragma once

#include "TreeNode.hpp"
#include "../symboltable/Symbol.hpp"

class CharNode : public TreeNode {
  using TreeNode::TreeNode;

  public:
    Symbol addSymbols();
    Symbol sematicCheck(Symbol sym);
    Symbol execute(Symbol sym);
};