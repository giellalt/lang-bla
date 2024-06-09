#!/bin/sh

# extract-flags.sh (LEXC)

# Usage:
#    cat lexicon.lexc | ./extract-flags.sh

gawk '{
 sub("!.*$","");
 while(match($0,"@[^@]+@",f)!=0)
      {
        sub(f[0],""); flags[f[0]]++;
      }
}
END {
  PROCINFO["sorted_in"]="@ind_str_asc";
  for(ff in flags) print ff;
}'
