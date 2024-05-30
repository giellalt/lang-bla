#!/bin/sh

# bla2json.sh

# Transforms Blackfoot dictionary content in TSV format to IMPORTJSON format

tr -d '"' |

# tr -s '\r' '\n' |

gawk -F"\t" 'BEGIN { }
match($0, "^#")==0 {
  line[++nr]=$0;
  n=split(line[nr],s,"\t");
  for(i=1; i<=n; i++)
     f[nr, i]=s[i];
}
END {

  for(j=1; j<=n; j++)
     {
       if(f[1, j]=="ROOT") root_col=j;
       if(f[1, j]=="ANALYSIS") anl_col=j;   
       if(f[1, j]=="LEMMA") lemma_col=j;
       if(f[1, j]=="POS") pos_col=j;
       if(f[1, j]=="DEFINITION") gloss_col=j;
       if(f[1, j]=="DEFINITION2") gloss2_col=j;
       if(f[1, j]=="FORMOF") formof_col=j;
     }


# IMPORTJSON format
# [
#   ⋮,
#   {
#     "analysis": [[], "nîmiw", ["+V", "+AI", "+Ind", "+3Sg"]],
#     "head": "nîmiw",
#     "linguistInfo": { "stem": "nîmi-" },
#     "paradigm": "VAI",
#     "senses": [{ "definition": "s/he dances", "sources": ["CW"] }],
#     "slug": "nîmiw"
#   },
#   {
#     "analysis": [[], "nîmiw", ["+V", "+AI", "+Ind", "+X"]],
#     "formOf": "nîmiw",
#     "head": "nîminâniwan",
#     "senses": [
#       {
#         "definition": "it is a dance, a time of dancing",
#         "sources": ["CW"]
#       }
#      ]
#   },
#   ⋮
# ]

printf "[\n";
 
for(i=2; i<=nr; i++)
   {
     lemma=f[i, lemma_col]; pos=f[i, pos_col]; gloss=f[i, gloss_col]; stem=f[i, root_col]; root=f[i, root_col];
     fstanl=f[i, anl_col];
     if(f[i, lemma3_col]!="") lemma=f[i, lemma3_col];
     note1=f[i, note1_col]; note2=f[i, note2_col]; formof=f[i, formof_col];

     if(formof=="")
       {
         head=root;

         paradigm=pos;
         sub("-.*$", "",paradigm);

         slug=head;
         gsub("[ ]+", "_", slug);
         if(slug in slugs)
           {
             slug=slug "@" ++slugs[slug];
           }
         else
           slugs[slug]=1;

         m=match(fstanl, "^(.*\\+)*([^\\+]+)(\\+N|\\+V|\\+Ipc|\\+Pron|\\+Num)(.*)$", a);
         prefix=a[1];
         lemma=a[2];
         suffix=a[3] a[4];
         gsub("\\+", "+\", \"", prefix); sub(", \"$", "", prefix);
         gsub("\\+", "\", \"+", suffix); sub("^\", ", "", suffix);
         if(prefix!="") prefix = "\"" prefix;
         if(suffix!="") suffix=suffix "\"";
         wc=a[3]; sub("^\\+","",wc);
#          analysis=sprintf("[%s], \"%s\", [%s]", prefix, lemma, suffix);

         printf "  {\n";

         printf "    \"head\": \"%s\",\n", head;
#          printf "    \"analysis\": [%s]\n", analysis;
         printf "    \"linguistInfo\": {\n"
         printf "      \"inflectional_category\": \"%s\",\n", pos;
         printf "      \"stem\": \"%s\",\n", stem;
         printf "      \"pos\": \"%s\",\n", wc;
         printf "      \"wordclass\": \"%s\"\n", paradigm;
         printf "     },\n";
         printf "    \"paradigm\": \"%s\",\n", paradigm;
         printf "    \"senses\": [{ \"definition\": \"%s\", \"sources\": [\"F&R\"] }],\n", gloss;
         printf "    \"slug\": \"%s\"\n", slug;
         printf "  }";

         if(i<nr)
           printf ",\n";
         else
           printf "\n";
       }
   }

printf "]\n";

}'
