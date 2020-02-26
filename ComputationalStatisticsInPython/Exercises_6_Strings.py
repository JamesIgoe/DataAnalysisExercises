

#""" Working with Text (http://people.duke.edu/~ccc14/sta-663/TextProcessingSolutions.html#working-with-text"""

#""" Exercises: http://people.duke.edu/~ccc14/sta-663/TextProcessingSolutions.html#exercises"""

#""" 
#1. Write a function to find the complementary strand given a DNA sequence. For example

#    - Given ATCGTTA Return TAGCAAT
#    Note: The following are complementary bases A|T, C|G.
#"""

#def dna_remap(inString, outString, stringToProcess):
#    transTab = str.maketrans(str.upper(inString), str.upper(outString))
#    return str.upper(stringToProcess).translate(transTab) 

#inString = 'aTCG'
#outSstring = 'TAGC'
#stringToProcess = 'ATCGTTA' 
#dna_remap(inString, outSstring, stringToProcess)
 
#"""
#2. Write a regular expression that matches the following:

#Phone numbers with the format: (919)-1234567 (i.e. 
#(123)-9876543 should match but not 234-1234567 or (123)-666666)

#Email addresss john.doe@duke.edu (i.e. steve@gmail.com should 
#match but not steve@gmail)

#DNA seqences with the motif A-C-T-G where - indicates 0 or 1 
#other nucleotide (any of A,C,T or G)
#"""

#import re as re

#match_expression = re.compile("[(]\d{3}[)][-]\d{7}")

#test_string = ['646.303.2584'
#               ,'646-303.2584'
#               ,'646 303 2584'
#               ,'(646) 303-2584'
#               ,'(919)-1234567'
#               ,'(123)-9876543'
#               ,'234-1234567'
#               ,'(123)-666666']

#for item in test_string:
#    m = re.match(match_expression, item)

#    if m:
#        print(m.group(), "match", sep=" ")
#    else:
#        print(item, "fail", sep=" ")

            
#match_expression = re.compile("^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$")

#test_string = ['john.doe@duke.edu','steve@gmail.com','steve@gmail','steve/german@some.edu']

#for item in test_string:
#    m = re.match(match_expression, item)
#    if m:
#        print(m.group(), "match", sep=" ")
#    else:
#        print(item, "fail", sep=" "

#"""
#3. Download ‘Pride and Prejudice’ by Jane Austem from Project Gutenbrrg.
#    - Remove all punctuation and covert to lower case
#    - Count how many times the word ‘married’ appears
#    - Count how often the word ‘daughter’ and ‘married’ appear in the same 10-word window
#"""

#"""target_url = "http://www.gutenberg.org/cache/epub/1342/pg1342.txt"

##import urllib.request as req
#import string

#text = req.urlopen(target_url).read().decode('utf-8')
#text = text.lower().translate(None, string.punctuation)


#"""
#4. Download “The Gutenberg Webster’s Unabridged Dictionary” from Project Gutenbrrg
#    - First extract all defined words (109561 words) - oops I cannot replicate this number
#    - Count the number of defined English words containing 3 or more vowels (aeiou)
#    - Find all longest palindrome (a palindrome is a word that is spelt the same forwards as backwards - e.g. ‘deified’)
#"""
