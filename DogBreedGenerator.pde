



void setup()
{
StringList lines = new StringList();
lines.append(loadStrings("DogBreeds.txt"));
lines.append(loadStrings("RandomWords.txt"));
println("Done Loading");
println("Init Tree");
Tree T = new Tree(lines.get(0).toLowerCase());
println("Done Init");
println("Training Begin");
for(int i = 1; i < lines.size();i++)
{
 T.addString(lines.get(i).toLowerCase());
}
println("Training End");

for(int i = 0; i < 25; i++)
{
println(T.GetRand());
}

}


void draw()
{
}




class Tree
{
  
  Node Root;
  
  
  Tree(String firstWord)
  {
    Root = new Node(' ');
    Root = trainString(Root,firstWord,0);
  }
  
  class Node
  {
   char Letter;
   IntList Probs = new IntList();
   ArrayList<Node> childNodes = new ArrayList<Node>();
   
   Node(char L)
   {
    Letter = L; 
   }
   
   String PickRandom(String prev)
   {
    if(childNodes.size() == 0)
    {
     return ""; 
    }
    else
    {
     int id = (int)random(childNodes.size());
     return childNodes.get(id).Letter + childNodes.get(id).PickRandom(prev);
    }
   }
   
  }
  
  String GetRand()
  {
    return Root.PickRandom("");
  }
  
  void addString(String s)
  {
    Root = trainString(Root,s,0);
  }
  
  Node trainString(Node n, String s, int Char)
  {
    println(s);
    char c = s.charAt(Char);
    boolean FoundChar = false;
    for(int i = 0; i < n.childNodes.size();i++)
    {
      if(n.childNodes.get(i).Letter == c)
      {
        n.Probs.add(i,1);
        n.childNodes.set(i,trainString(n.childNodes.get(i),s,Char+1));
        FoundChar = true;
        break;
      }
    }
    if(!FoundChar && Char < s.length()-1)
    {
     Node newNode = new Node(c);
     newNode = trainString(newNode,s,Char+1);
     n.childNodes.add(newNode);
     n.Probs.append(1);
    }
    return n;
  }
}
