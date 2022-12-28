#!/bin/sh

# rewrite-rule-test.sh 1: XFSCRIPT rule file (path) 2: REPORT 3: FSTTYPE

# LEXC forms from standard input, so multiple words can be processed
# Input must have one LEXC form per line to be processed,
# as well as an optional second space-separated form representing the
# final outcome.

gawk -v XFSCRIPT=$1 -v REPORT=$2 -v FSTTYPE=$3 'BEGIN { xfscript=XFSCRIPT;
report=REPORT; fsttype=FSTTYPE; FS="\t";

#   if(fsttype!="foma" && fsttype!="hfst" && fsttype!="hfstol")
  if(fsttype!="foma" && fsttype!="hfst")
    {
      if(fsttype=="")
        {
          fsttype="foma";
          print "Setting FST type as \"foma\" by default" > "/dev/stderr";
        }
      else
        {
#          print "Aborting <- specify FST type for phonological rule(s) among the following: 1) foma; 2) hfst; or 3) hfstol";
          print "Aborting <- specify FST type for phonological rule(s) among the following: 1) foma; or 2) hfst";
          exit;
        }
    }

  while((getline < xfscript)!=0)
  {
    sub("[ \t]*!.*$","",$0);
    if(index($0,"regex")!=0)
      { rx=1; regex=""; }
    if(rx)
      regex=regex" "$0;
    if(index($0,";")!=0)
      rx=0;
  }

  sub("^[ \t]*(read )?regex.*\\[[ ]*", "", regex);
  sub("[ ]*\\].*;.*$", "", regex);
  n=split(regex,rule,"[ ]*\\.o\\.[ ]*");
  for(i=1; i<=n; i++)
     if(length(rule[i])>maxrulelen)
       maxrulelen=length(rule[i]);
  maxixlen=length(n);

  for(i=1; i<=n; i++)
     {
       fst=fsttype "/" rule[i] "." fsttype;
       "if [ -f \"" fst "\" ]\nthen\n echo 1\nelse\necho 0\nfi" | getline exit_status;
       if(exit_status!=1)
         missing_fst=missing_fst fst " ";
     }
  if(missing_fst!="")
    {
      printf "Aborting <- FST(s) (in %s format) for rules is/are missing in: %s/\n %s\n", toupper(fsttype), fsttype, missing_fst;
      exit;
    }
}
{
  input=$1; lexc=$1; ntarget=0;
  gsub("0","",input);
  if(NF>=2)
    for(i=2; i<=NF; i++)
       if($i!="")
         {
           gsub("0","",$i);
           target[$i]=$i;
           ntarget++;
         }
  gsub("\\.o\\.","->",regex);
  if(report=="long")
    {
      print "REWRITE RULE SEQUENCE:";
      print regex;
      print "";
      print "0 - "input;
      print "---";
    }
    
  for(i=1; i<=n; i++)
     {
       flookup_cmd="flookup -b -i"; fomabin=fsttype "/" rule[i] ".foma";
       hfst_lookup_cmd="hfst-lookup -q"; hfst=fsttype "/" rule[i] ".hfst";
       hfstol_lookup_cmd="hfst-optimized-lookup -q"; hfstol=fsttype "/" rule[i] ".hfstol";

       if(fsttype=="foma")
         { lookup_cmd=flookup_cmd; rulefst=fomabin; }
       if(fsttype=="hfst")
         { lookup_cmd=hfst_lookup_cmd; rulefst=hfst; }
       # HFSTOL FSTs can be created, but look-ups do not work currently
       if(fsttype=="hfstol")
         { lookup_cmd=hfstol_lookup_cmd; rulefst=hfstol; }

       output=""; delete diff; ndiff=0;
       ninput=split(input, input2, "\n");

       for(j=1; j<=ninput; j++)
          {
            fst_result=lookup(lookup_cmd, rulefst, input2[j]);
            output=output sprintf("%s\n", fst_result);

            noutput=split(fst_result, output2, "\n");
            for(k=1; k<=noutput; k++)
               {
                 if(input2[j]==output2[k])
                   d="|";
                 else
                   d="+";
                 diff[++ndiff]=d;
               }
          }
       sub("\n$","",output);
       input=output;

       noutput=split(output, output2, "\n");
       if(report=="long")
         {
           printf "%"maxixlen"i: %-"maxrulelen"s ", i, rule[i];
           for(k=1; k<=noutput; k++)
              printf " %s %s", diff[k], output2[k];
           printf "\n";
         }
     }

  if(report=="long")
    print "---";

  outcome=output;
  gsub("\n", "\t", outcome);
  gsub("[<>]", "", outcome);
  noutcome=split(outcome, outcome2, "\t");

  delete success; nlocsuccess=0; nlocmiss=0;
  for(i=1; i<=noutcome; i++)
     {
       if(outcome2[i] in target)
         {
           success[i]="(=)";
           nlocsuccess++;
           target[outcome2[i]]="";
         }
       else
         if(noutcome==1)
           success[i]="(<> " outcome2[i] ")";
         else
           success[i]="(<>)";
     }

  printf "%i: 1-%i: %s ->", NR, n, lexc; 
  for(i=1; i<=noutcome; i++)
     {
       if(noutcome>=2 && i<noutcome)
         sep=" /";
       else
         sep="";
       printf " %s %s%s", outcome2[i], success[i], sep;
     }
  for(t in target)
     if(target[t]!="")
       {
         nlocmiss++;
         printf " | -/-> %s", t;
       }
  printf "\n";

  if(nlocsuccess==noutcome && nlocmiss==0)
    n_success++;
  else
    if(nlocsuccess>0)
      n_mixed++;
    else
      n_fail++;

  printf "%"length(NR)+1"s STATS: Correct: %i/%i - Wrong: %i/%i - Missed: %i/%i\n", "", nlocsuccess, noutcome, noutcome-nlocsuccess, noutcome, nlocmiss, ntarget;
  if(report=="long")
    print "";
}

END { if(NR>=1) printf "SUMMARY - SUCCESS: %i/%i - FAIL: %i/%i - PARTIAL: %i/%i\n", n_success, NR, n_fail, NR, n_mixed, NR;
}

function lookup(cmd, fst, input,     fst_output, inp, out, i, nr, nf, rs, fs)
{
  rs=RS; fs=FS;
  cmd_fst=cmd " " fst;

  # print input |& cmd_fst;
  # fflush(); close(cmd_fst, "to");
  # while((cmd_fst |& getline)!=0)
  #    {
  #      fst_output[++nr]=$0;
  #    }
  # fflush(); close(cmd_fst, "from");

  RS=""; FS="\n";
  print input |& cmd_fst;
  fflush(); close(cmd_fst, "to");
  cmd_fst |& getline inp;
  fflush(); close(cmd_fst, "from");
  RS=rs; FS=fs;

  nr=split(inp,fst_output,"\n");
  for(i=1; i<=nr; i++)
     {
       nf=split(fst_output[i],f,"\t");
       if(nf!=0)
         if(match(fst_output[i],"\\+\\?[\t$]")==0)
           out=out f[2] "\n";
         else
           out=out "+?" "\n";
     }
  sub("\n$","",out);
  
  return out;
}'

