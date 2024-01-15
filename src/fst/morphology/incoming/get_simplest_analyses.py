# This program is used to return the "simplest" parses out of the full list of parses
# that are produced by the Blackfoot FST. It does this simply by adding together the
# number of preverbs and prenouns present in each parse, organizes them into a dictionary,
# sorts the items from those with the smallest number of preverbs and prenouns to those with 
# the largest, and then returning the top 12 results which will include the word and parse counts
# and the original surface form at the end.

import sys
import re

with sys.stdin as f:
    for line in f:
        lines = f.readline()
        parses = lines.split(',')
        prenoun = "PN/"
        preverb = "PV/"
        create_dict = dict.fromkeys(parses, 0)
        count_list = [i.count(prenoun) + i.count(preverb) for i in parses]
        count_dict = dict(zip(parses, count_list))
        sort_dict = sorted(count_dict.items(), key=lambda x: x[1])
        result = tuple(sort_dict)
        print(result[:12])