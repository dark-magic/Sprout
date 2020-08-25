#pragma once

#include "TreeNode.hpp"
#include "../symboltable/Symbol.hpp"

class VariableTypeNodeNode : public TreeNode {
  using TreeNode::TreeNode;
  public:
    Symbol analyse(Symbol sym);
    Symbol execute(Symbol sym);
};