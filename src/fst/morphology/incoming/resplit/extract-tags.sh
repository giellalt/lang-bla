#!/bin/sh

# extract-tags.sh (LEXC)

# Usage:
#    cat lexicon.lexc | ./extract-tags.sh

gawk '{
 sub("!.*$","");
 n=split($0,lexc,":");
 if(n==2)
   while(match(lexc[1], "([^\\+@]+\\+)|(\\+[^\\+@]+)", f)!=0)
        {
          tag=f[0];
          sub("\\+","\\+",tag);
          sub(tag, "", lexc[1]);
          tags[f[0]]++;
      }
}
END {
  PROCINFO["sorted_in"]="@ind_str_asc";
  for(tt in tags)
     print tt;
}'
