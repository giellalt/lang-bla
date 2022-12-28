#!/bin/sh

# compile-rewrite-rules.sh 1: XFSCRIPT (path to) 2: FSTTYPE

# echo /Users/arppe/giella/langs/crk/src/fst/phonology.xfscript foma |

echo '' |
    
gawk -v XFSCRIPT=$1 -v FSTTYPE=$2 'BEGIN { xfscript=XFSCRIPT; fsttype=FSTTYPE;

# if(fsttype!="foma" && fsttype!="hfst" && fsttype!="hfstol")
if(fsttype!="foma" && fsttype!="hfst")
  {
    if(fsttype=="")
      {
        fsttype="foma";
        print "Setting FST type as \"foma\" by default" > "/dev/stderr";
      }
    else
      {
        # print "Aborting <- specify FST type for phonological rule(s) among the following: 1) foma; 2) hfst; or 3) hfstol";
        print "Aborting <- specify FST type for phonological rule(s) among the following: 1) foma; or 2) hfst";
        exit;
      }
  }

while((getline < xfscript)!=0)
  { if(index($0,"regex")!=0)
      { rx=1; regex=""; }
    if(rx)
      regex=regex" "$0;
    if(index($0,";")!=0)
      rx=0;
  }
sub("^[ ]*(read )regex.*\\[[ ]*","",regex);
sub("[ ]*\\].*;.*$","",regex);
n=split(regex,rule,"[ ]*\\.o\\.[ ]*");
cmd="-e \"source "xfscript"\"";
for(i=1; i<=n; i++)
   cmd=cmd" -e \"clear stack\" -e \"push "rule[i]"\" -e \"save stack "rule[i]"."fsttype"\"";
}

END {
if(fsttype=="foma")
  system("foma "cmd" -e \"quit\"");
if(fsttype=="hfst" || fsttype=="hfstol")
  system("hfst-xfst "cmd" -e \"quit\"");
# The following conversion works in principle, but the resultant HFSTOL FSTs do now work
if(fsttype=="hfstol")
  {
    for(i=1; i<=n; i++)
       {
         hfst=rule[i]".hfst";
         hfstol=rule[i]".hfstol";
         system("hfst-fst2fst -O -i " hfst " -o " hfstol ";");
       }
  }
}'
