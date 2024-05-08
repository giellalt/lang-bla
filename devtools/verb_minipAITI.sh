#!/bin/bash

# script to generate paradigms for generating word forms
# command, when you are in smn:
# sh devtools/verb_minip.sh 2SYLL_OD | less
# sh devtools/verb_minip.sh kihlođ 


LOOKUP=$(echo $LOOKUP)
LOOKUP=$(echo $LOOKUP)
GTLANGS=$(echo $GTLANGS)


PATTERN=$1
L_FILE="in.txt"
cut -d '!' -f1 src/fst/morphology/stems/verb_stems.lexc | egrep $PATTERN | cut -d ':' -f1>$L_FILE

P_FILE="test/data/testverbparadigmAITI.txt"

for lemma in $(cat $L_FILE);
do
 for form in $(cat $P_FILE);
 do
# echo "${lemma}${form}" | $LOOKUP $GTLANGS/lang-bla/src/fst/generator-gt-norm.xfst
  echo "${lemma}${form}" | $HLOOKUP $GTLANGS/lang-bla/src/fst/generator-gt-norm.hfstol     
 done
done

