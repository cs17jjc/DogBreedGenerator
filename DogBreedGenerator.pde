



void setup()
{
StringList lines = new StringList();
lines.append(loadStrings("DogBreeds.txt"));
lines.append(loadStrings("RandomWords.txt"));
lines.append(loadStrings("RandomPlaces.txt"));
//lines.append(loadStrings("Debug.txt"));
lines.lower();
//println("Done Loading");
//println("Init Tree");
Tree T = new Tree(lines.get(0));
//println("Done Init");
//println("Training Begin");
for(int i = 1; i < lines.size();i++)
{
 T.addString(lines.get(i));
}
//println("Training End");
//println("Normalisation");
T.Normalise();
//println("Normalisation End");

String NewBreed = "";
for(int Ammount = 0; Ammount < 500; Ammount++)
{
  String[] ls = new String[25];
for(int i = 0; i < 25; i++)
{
  boolean picked = false;
  while(picked == false)
  {
   NewBreed = T.GetRand();
   if(!lines.hasValue(NewBreed))
   {
     picked = true;  
   }
  }
  ls[i] = NewBreed;
}
saveStrings("output.txt",ls);
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
   
   String PickWeightedRandom(String prev)
   {
    if(childNodes.size() == 0)
    {
     return ""; 
    }
    else
    {
      while(true)
      {
     for(int i = 0; i < childNodes.size();i++)
     {
       int rnd = (int)random(100);
       if(rnd < Probs.get(i))
       {
         //println(Probs.get(i) + " > " + rnd);
         if(childNodes.get(i).Letter == ' ' && random(100) < 75)
         {
          return " " + Root.PickWeightedRandom("");
         }
         else
         {
           return childNodes.get(i).Letter + childNodes.get(i).PickWeightedRandom(prev);
         }
       }
     }
      }
      
    }
   }
   
  }
  
  String GetRand()
  {
    return Root.PickWeightedRandom("");
  }
  
  void addString(String s)
  {
    Root = trainString(Root,s,0);
  }
  
  void Normalise()
  {
   Root = NormaliseNodes(Root); 
  }
  
  Node NormaliseNodes(Node n)
  {
    float sum = 0;
    for(int i = 0; i < n.Probs.size();i++)
    {
       sum += n.Probs.get(i);
    }
    for(int i = 0; i < n.Probs.size();i++)
    {
      //println((int)(((float)n.Probs.get(i)/sum)*100.0) + " : " + n.Letter + " : " + n.childNodes.get(i).Letter);
      n.Probs.set(i,(int)(((float)n.Probs.get(i)/sum)*100.0));
    }
    for(int i = 0; i < n.childNodes.size();i++)
    {
       n.childNodes.set(i,NormaliseNodes(n.childNodes.get(i)));
    }
    return n;
  }
  
  Node trainString(Node n, String s, int Char)
  {
    char c = s.charAt(Char);
    boolean FoundChar = false;
    for(int i = 0; i < n.childNodes.size();i++)
    {
      if(n.childNodes.get(i).Letter == c)
      {
        n.Probs.add(i,1);
        if(Char < s.length() -1)
        {
          n.childNodes.set(i,trainString(n.childNodes.get(i),s,Char+1));
        }
        FoundChar = true;
        break;
      }
    }
    if(!FoundChar)
    {
     Node newNode = new Node(c);
     if(Char < s.length() -1)
     {
     newNode = trainString(newNode,s,Char+1);
     }
     n.childNodes.add(newNode);
     n.Probs.append(1);
    }
    return n;
  }
}
