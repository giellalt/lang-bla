#!/bin/sh

ls root.lexc noun_prefixes.lexc noun_stems.lexc noun_suffixes.lexc verb_prefixes.lexc prevn.lexc verb_stems.lexc verb_suffixes.lexc particles.lexc pronouns.lexc ../dem.lexc |

gawk 'BEGIN { printf "!! Blackfoot morphotax\n\n" > "lexicon.lexc"; }
{
  file=$0;
  while((getline line < file)!=0)
     printf "%s\n", line >> "lexicon.lexc";
  printf "\n\n" >> "lexicon.lexc";
}'
