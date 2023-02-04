#!/bin/sh

# Usage:
#    ./extract-rule-test-cases.sh 1:PATH-TO-phonology.xfscript

# Example:
# ./extract-rule-test-cases.sh phonology.xfscript| ./rewrite-rule-test.sh phonology.xfscript short hfst | less

cat $1 |

gawk '$1 ~ /^!!€/ {
  if(test=="")
    {
      test=$2;
      next;
    }
  if(test!="")
    {
      test=test "\t" $2;
      next;
    }
}
{
  if(test!="")
    {
      print test;
      test="";
    }
}'
