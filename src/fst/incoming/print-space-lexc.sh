#!/bin/sh

# cat bla_verb_full.lexc |

gawk -v MULTCHAR=$1 'BEGIN { multchar=MULTCHAR; }
{ sub("[[:space:]]*!.*$","");
  if(index($0,"Multichar_Symbols")!=0)
    { p=1; next; }
  if(index($0,"LEXICON ")!=0)
    p=2;
  if(p==1 && $0!="")
    mult[$0]=length($0);
  if(p==2)
    if($0!="" && match($0,"^LEXICON ")==0)
      {
        sub("[^ \t]+[[:space:]]*;[ ]*[^!]*$","");
        PROCINFO["sorted_in"]="@val_num_desc";
        for(m in mult)
          if(mult[m]>=2)
            {
              gsub("\\+","\\+",m);
              gsub("\\^","\\^",m);
              gsub(m, "[&]");
            }
        n=split($0, c, "");
        printf "%i:", NR;
        s=" ";
        for(i=1; i<=n; i++)
           {
             if(c[i]=="[")
               {
                 printf " ";
                 s="";
               }
             if(c[i]=="]")
               s=" ";
             if(c[i]!="[" && c[i]!="]")
               if(multchar=="")
                 printf "%s%s", s, c[i];
               else
                 if(s==" ")
                   printf "%s%s", s, c[i];
                 else
                   printf "%s", multchar;
           }
        printf "\n";
      }
}'
