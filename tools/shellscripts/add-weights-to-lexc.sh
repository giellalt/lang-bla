#!/bin/sh

# Usage:
#    add-weights-to-lexc.sh 1: LEXC 2: WEIGHTS 3: WTYPE 4: WINFMULT

# Example:
#    ./add-weights-to-lexc.sh ~/giellatekno/lang-crk/src/fst/lexicon.tmp.lexc crk_weights.txt log 2 | less

cat $1 | gawk '{ print; } END { print "LEXICON @ENDLEXICON@"; }' |
    
gawk -v WEIGHTS=$2 -v WTYPE=$3 -v WINFMULT=$4 'BEGIN { weights=WEIGHTS;
wtype=WTYPE; winfmult=WINFMULT;
if(winfmult=="")
  winfmult=2;
if(wtype!="log" && wtype!="abs")
  wtype="log";
  while((getline < weights)!=0)
    if(match($2, "^.+\\+.+$")==0)
    {
      tag=$2;
      if($1>max)
        max=$1;
      gsub("\\+","\\+",tag);
      gsub("0","%0",tag);
      gsub("%+","%",tag);
      w[tag]=$1;
      tlen[tag]=length(tag);
    }
# Section for including lemmas in weighting, which slows down their insertion for now.
#  else
#    {
#      lex=$2;
#      split(lex,f,"+");
#      gsub("\\-","\\-",f[1]);
#      lex=f[1];
#      w[lex]=$1;
#      tlen[lex]=length(f[1]);
#    }
  for(t in w)
    l[t]=-log(w[t]/max);
  wloginf=-log(0.5/max);
  wabsinf=2*max;
}
{
  if(match($0,"^[^!]*LEXICON ")==0 && CLEX=="")
    {
      print $0;
      next;
    }
  if(match($0,"^[^!]*LEXICON ")!=0 && CLEX=="") 
    {
      CLEX = $0;
      next;
    }
  if(match($0,"^[^!]*LEXICON ")!=0 && CLEX!="")
    {
      nline=split(CLEX, line, "\n");
      wlocmax=0;
      for(i=1; i<=nline; i++)
        if(match(line[i],"^[^!]+:[^!]+;")!=0)
          {
            sub("\"[^\"]*\"","",line[i]);
            llexc=line[i];
            sub("!.*","",llexc);
  
            wlexc=0;
            PROCINFO["sorted_in"]="@val_num_desc";
            for(t in tlen)
               if(sub(t, "", llexc)!=0)
                 if(wtype=="abs")
                   wlexc+=w[t];
               else
                  wlexc+=l[t];

            if(wlexc*1==0)
              wlexc="@MAXWEIGHT@";
            if(wlexc*1>wlocmax)
              wlocmax=wlexc;

            sub(";", "\"weight: " wlexc "\" ;", line[i]);
          }
       # This condition should rule out printing the final @ENDLEXICON@ added
       # at the beginning, but does not seem to work yet properly.
       if(index($0, "LEXICON @ENDLEXICON@")==0)
       for(i=1; i<=nline; i++)
          {
            if(wlocmax!=0)
              sub("@MAXWEIGHT@", wlocmax*winfmult, line[i]);
            else
              sub("\"[^\"]*\"","", line[i]);
            print line[i];
          }
       CLEX=$0;
       next;
    }
  if(match($0,"^[^!]*LEXICON ")==0 && CLEX!="") 
    CLEX = CLEX "\n" $0;
}
END { print CLEX; }' |

egrep -v '^LEXICON @ENDLEXICON@$'
