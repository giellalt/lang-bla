#!/bin/sh

# extract-flags.sh (LEXC)

# Usage:
#    cat lexicon.lexc | ./extract-flags.sh

gawk '{
 sub("!.*$","");
 while(match($0,"\\+[^\\+]+",f)!=0)
      {
        tag=f[0];
        gsub("\\+","\\+",tag);
        sub(tag,""); tags[tag]++;
      }
}
END {
  PROCINFO["sorted_in"]="@ind_str_asc";
  for(tt in tags) print tt;
}'
