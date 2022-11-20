#include <cstdio>

class TreeNode {
  public:
    int value;

    TreeNode *parent;
    TreeNode *leftChild;
    TreeNode *rightChild;

    TreeNode();
    ~TreeNode();
};

TreeNode::TreeNode() {
  printf("treenode created.\n");
}

TreeNode::~TreeNode() {
  printf("treenode destroyed.\n");
}

int main(int argc, char **argv) {
  TreeNode tn1;

  printf("main.\n");

  return 0;
}
