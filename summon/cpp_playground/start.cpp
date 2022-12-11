#include <cstdio>
#include <thread>

class TreeNode {
  public:
    int value;

    TreeNode *parent;
    TreeNode *leftChild;
    TreeNode *rightChild;

    TreeNode();
    TreeNode(int val);
    ~TreeNode();

    void printValue();
};

TreeNode::TreeNode() {
  printf("treenode created.\n");
}

TreeNode::TreeNode(int val) {
  printf("treenode created.\n");
  value=val;
}

TreeNode::~TreeNode() {
  printf("treenode destroyed.\n");
}

void TreeNode::printValue() {
  printf("value: %d\n", value);
}

int main(int argc, char **argv) {
  TreeNode tn1(20);

  printf("main.\n");

  std::thread thread(&TreeNode::printValue, tn1);

  thread.join();

  return 0;
}
