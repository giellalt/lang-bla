#!/bin/sh

echo 'root.lexc noun_prefixes.lexc noun_stems.lexc noun_suffixes.lexc verb_prefixes_new.lexc verb_stems.lexc verb_suffixes.lexc particles.lexc pronouns.lexc ../dem.lexc' |

gawk 'BEGIN { printf "!! Blackfoot morphotax -- aggregate of all LEXC files\n\n" > "lexicon.lexc"; }
{ nf=split($0, files, " ");
  for(i=1; i<=nf; i++)
     {
       while((getline line < files[i])!=0)
          printf "%s\n", line >> "lexicon.lexc";
       printf "\n\n" >> "lexicon.lexc";
     }
}'
