#!/bin/sh

grep -v '+?' |

gawk '{ for(i=5; i<=NF; i++)
           {
             m=match($i, "(.*\\+)?([-[:alpha:]]+)(\\+NA|\\+NI|\\+NAD|\\+NID|\\+VAI|\\+VII|\\+VTI|\\+VTA)(.*)$", f);
             if(m!=0)
               {
                 prefix = f[1];
                 lemma = f[2];
                 pos = f[3];
                 suffix = f[4];
                 n = split(prefix, f1, "+");
                 for(j = 1; j < n; j++ )
                    freq[f1[j]"+"]++;
                 n = split(suffix, f1, "+");
                 for(j = 2; j <= n; j++ )
                    freq["+"f1[j]]++;
                 freq[lemma pos]++;
                 freq[pos]++;
               }
          }
}
END { for(t in freq)
         printf "%i\t%s\n", freq[t], t;
}' |

sort -nr
