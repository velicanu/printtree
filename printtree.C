#include "HiForestAnalysis/hiForest.h"

void printtree(string filename)
{
  HiForest * c = new HiForest(filename.data(),"forest",cPPb,0);
  c->InitTree();
  c->hltTree->Print();
}

int main(int argc, char *argv[])
{
  if(argc != 2)
  {
    cout<<"usage ./testforest.exe <filename>"<<endl;
    return 1;
  }
  printtree(argv[1]);
  return 0;
}
