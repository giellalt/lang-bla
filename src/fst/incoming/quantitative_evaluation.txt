from statistics import mean
import random

with open('all_words.txt') as f:
    lines = f.readlines()
    
# Count total number of unique words
    all_lines = len(lines)
    print('Total lines:', all_lines)
    
# Count total number of unparsed words
    num_lines = [line for line in lines if "+?" in line]
    print('Total unparsed:', len(num_lines))

# Count total number of parsed words
    total_parsed = all_lines - len(num_lines)
    print('Total parsed:', total_parsed)
    
# Calculate percentage of words left parsed and unparsed
    percentage = len(num_lines) / all_lines
    print('percent unparsed:', percentage)
    percentage2 = total_parsed / all_lines
    print('percent parsed:', percentage2)
    
# Count the total number of verb and noun stems parsed (regardless of stem class)
    verb = [line for line in lines if "+V" in line or "Der/Nom" in line and "Der/Verb" not in line]
    verbs = len(verb)
    print('there are', verbs, 'words parsed as verbs')
    noun = [line for line in lines if "+N" in line or "Der/Verb" in line and "Der/Nom" not in line]
    nouns = len(noun)
    print('there are', nouns, 'words parsed as nouns')
    
# Count the total number of verb or noun stems parsed
    noun_stem = [line for line in lines if "Der/Verb" in line or "+N" in line and "Der/Nom" not in line]
    noun_stems = len(noun_stem)
    verb_stem = [line for line in lines if "Der/Nom" in line or "+V" in line and "Der/Verb" not in line]
    verb_stems = len(verb_stem)
    print("the total number of noun stems parsed is: " , noun_stems)
    print("the total number of verb stems parsed is: " , verb_stems)

# Count the number of noun stems parsed as verbs and verb stems parsed as nouns
    verbalization = [line for line in lines if "Der/Verb" in line and "Der/Nom" not in line]
    verbalizations = len(verbalization)
    print("the noun stems parsed as verbs " , verbalizations)
    nominalization = [line for line in lines if "Der/Nom" in line and "Der/Verb" not in line]
    nominalizations = len(nominalization)
    print("the verb stems parsed as nouns: " , nominalizations)
    
# Count the number of noun stems parsed as nouns and verb stems parsed as verbs
    reg_noun = [line for line in lines if "+N" in line and "Der/Nom" not in line]
    reg_nouns = len(reg_noun)
    print("the noun stems parsed as nouns" , reg_nouns)
    reg_verb = [line for line in lines if "+V" in line and "Der/Verb" not in line]
    reg_verbs = len(reg_verb)
    print("the verb stems parsed as verbs: " , reg_verbs)
    
# Count the total number of noun or verb stems parsed as BOTH nouns and verbs
    noun_union = reg_nouns - noun_stems
    noun_unions = noun_union + verbalizations
    print("the number of noun stems parsed as BOTH: " , noun_unions)
    verb_union = reg_verbs - verb_stems
    verb_unions = verb_union + nominalizations
    print("the number of verb stems parsed as BOTH: " , verb_unions)
 
# Return random list of parses. Use this to return values and hand check the accuracy of the # parses.
#    for line in lines:
#        random_num = random.choice(lines)
#        print("Random element is :", str(random_num))

### END CODE ###