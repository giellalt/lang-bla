#!/bin/sh

echo 'root.lexc noun_stems.lexc verb_stems.lexc noun_suffixes.lexc prefixes-new.lexc verb_suffixes.lexc particles.lexc pronouns.lexc ../dem.lexc' |

gawk 'BEGIN { printf "!! Blackfoot morphotax -- aggregate of all LEXC files\n\n" > "testlexicon.lexc"; }
{ nf=split($0, files, " ");
  for(i=1; i<=nf; i++)
     {
       while((getline line < files[i])!=0)
          {
#            if(index(line, ";")!=0)
#              {
#                gsub("á","a", line);
#                gsub("í","i", line);
#                gsub("ó","o", line);
#              }
            printf "%s\n", line >> "testlexicon.lexc";
          }
       printf "\n\n" >> "testlexicon.lexc";
     }
}'
