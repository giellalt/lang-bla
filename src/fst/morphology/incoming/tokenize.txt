# tokenize.py

# script for tokenizing input

# with open("genesis.txt", "r") as f:
#    data = f.readlines()
 
# for line in data:
#    words = line.split()
#    print words

import sys
import re

# Old-fashioned way of explicitly opening and closing a file for input

# input = open("genesis.txt", "r") 
# text = input.read()
# input.close()

# More robust way of specifying a file for input without explicitly
# opening or closing it

# with open("genesis.txt", "r") as f:

# Opting to use standard input rather than a specified file

with sys.stdin as f:
    text = f.read()

# Some commands for scrutinizing input

# print(type(text))
# print(text)
# print(len(text))
# print(re.split(r'[ \n\t]+', text))

# Split input text into lines based on new-line characters

lines = text.splitlines()

# Some commands for scrutinizing results of line-ification

# print(lines)
# print(lines[99])
# print(len(lines))

# Specifying an empty list

items = []

# Removing white-space from the beginnings and ends of lines 

for line in lines:
    stripped = line.strip()
#    tokens = stripped.split()
#    print(tokens)
#   for token in tokens:
#        print(token)

#    tokens = re.split(r'[ \t]+', stripped)
#    tokens = re.split(r'\s+', stripped)
#    tokens = re.split(r'\w+', stripped)

# Splitting lines into lists of non-white-space strings

    tokens = re.findall(r'\S+', stripped)
#    tokens = re.findall(r"\w+(?:[-']\w+)*|'|[-.(]+|\S\w*", stripped)

# Adding line-by-line non-white-space strings into 'items'

    for token in tokens: 
        elements = re.findall(r'\w+[\'\.]\w+|\w+|\W', token)
        for element in elements:
            items.append(element)

# Commands for scrutinizing results
# print(items)

# Standardization of text

# Specifying lists of exceptions for proper names (for lower case)
# and abbreviations for treatime of full stops

propernames = [ "Alberta", "Edmonton", "Canadian" ]
abbreviations = [ "e.g", "i.e", "etc", "N.B", "U.S", "EU" ]

# Commands for scrutinizing lists of exceptional cases

# print(propernames)
# print(abbreviations)

# Setting initial variable with expectation of lower-case

tolow = "yes"

# Setting item/token index at the very beginning (=0)

i=0
# for i in range(0, len(items)):
while i<len(items):
    if((items[i] in abbreviations) and items[i+1]=="."):
        items[i] = items[i] + (".")
        del(items[i+1])
    i=i+1

# Scrutinizing interim results
# print(items)

for i in range(0, len(items)):
    if(tolow=="yes" and items[i][0:1].isalpha() and not(items[i] in propernames)):
        items[i] = items[i].lower()
        tolow="no"
    if(items[i]=="." or items[i]=='"' or items[i]=="!" or items[i]=="?"):
        tolow="yes"

# Scrutinizing interim results
# print(items)

for i in range(0, len(items)):
   print(items[i])