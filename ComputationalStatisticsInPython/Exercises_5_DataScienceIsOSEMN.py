# Data science is OSEMN
"""http://people.duke.edu/~ccc14/sta-663/DataProcessingSolutions.html#data-science-is-osemn"""

# Acquiring Data

"""Plain text files
We can open plain text files with the open function. This is a common and very flexible format, 
but because no structure is involved, custom processing methods to extract the information needed may be necessary.
Example 1: Suppose we want to find out how often the words alice and drink occur in the same 
sentence in Alice in Wonderland."""

text = open('Data\pg989.txt','r').read().replace('\r\n', ' ').lower()

# sentence extraction and frequency
import re
punctuation = '\.|\?|\!'
sentences = re.split(punctuation, text)
len(sentences)

# word extraction and frequency
import re
words = re.split(' ', text)
len(words)

# converts to a sorted dictioanry
import collections as coll
counter=coll.Counter(words)
len(counter)

# if looking to exclude extraneous terms
exclude = ('the','of','to','and','that','in','','a','as','is','for','not','by','he','it','which''with','or','i','with','from','which')
trimmedWords = [word for word in words if word not in exclude]
trimmedWordCounter=coll.Counter(trimmedWords)

# Reading a text file line by line
import csv
with open('Data\pg989.txt') as f:
    lines = list()
    for line in csv.reader(row for row in f if not row.startswith('#')):
        if len(line) > 0:
            print(line)

# Reading a csv line by line
import csv
with open('Data\OECD - Quality of Life.csv') as f:
    lines = list()
    for line in csv.reader(row for row in f):
        Country, HofstederPowerDx, HofstederIndividuality, HofstederMasculinity, HofstederUncertaintyAvoidance, Diversity_Ethnic, Diversity_Linguistic, Diversity_Religious, ReligionMatters, Protestantism, Religiosity, IQ, Gini, Employment, Unemployment, EduReading, EduScience, TertiaryEdu, LifeExpectancy, InfantDeath, Obesity, HoursWorked, Prison, Carvandalism, Cartheft, Theftfromcar, Motorcycletheft, Bicycletheft, Assaultsandthreats, Sexualincidents, Burglaries, Robberies = line
        if len(line) > 0:
            print(Country)

# Load into a data frame
import pandas as pd
df = pd.read_csv('Data\OECD - Quality of Life.csv', header=0)
df


# to do - load json from url
import urllib.request as request
import requests
import json

url = "http://api.glassdoor.com/api/api.htm?v=1&t.p=54266&t.k=kkVtbXmhj3I&format=json&action=employers&userip=0.0.0.0&useragent=&q=vba&ps=20&pn=1"

# request the API
response_gd = requests.get(url, 
                           headers={"User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36"})

print(response_gd.content)

newResponse = str(response_gd.content)
#type(response_gd.content)
#type(newResponse)

data = json.loads(newResponse)
#print(data)


# Scrubbing data
"""http://people.duke.edu/~ccc14/sta-663/DataProcessingSolutions.html#scrubbing-data"""

# Load into a data frame
import pandas as pd
df = pd.read_csv('Data\OECD - Quality of Life.csv', header=0)
df

# list columns
df.columns.values.tolist()
# or
list(df.columns.values)

# extract column
"""http://pandas.pydata.org/pandas-docs/stable/indexing.html
Object      Type	Indexers
Series	    s.loc   [indexer]
DataFrame	df.loc  [row_indexer,column_indexer]
Panel	    p.loc   [item_indexer,major_indexer,minor_indexer]"""


# drop Nan
# using pandas.Series.dropna()




# Exercises
"""http://people.duke.edu/~ccc14/sta-663/DataProcessingSolutions.html#exercises"""

"""1. Write the following sentences to a file “hello.txt” using open and write. 
There should be 3 lines in the resulting file.

Hello, world.
Goodbye, cruel world.
The world is your oyster."""

str = 'Data\Test.txt'

f = open(str, 'w')
f.write('Hello, world.\r')
f.write('Goodbye, cruel world.\r')
f.write('The world is your oyster.')

# Writes same thing, only in one statement
f.write('\rHello, world.\rGoodbye, cruel world.\rThe world is your oyster.')

f.close()

with open(str, 'r') as f:
    content = f.read()
    print(content)


"""2. Using a for loop and open, print only the lines from the 
file ‘hello.txt’ that begin wtih ‘Hello’ or ‘The’."""

for line in open(str, 'r'):
    if line.startswith('Hello') or line.startswith('The') :
        print(line)


"""3. Most of the time, tabular files can be read corectly using 
convenience functions from pandas. Sometimes, however, line-by-line processing 
of a file is unavoidable, typically when the file originated from 
an Excel spreadsheet. Use the csv module and a for loop to create 
a pandas DataFrame for the file ugh.csv."""

# Reading a csv line by line
import pandas as pd
with open('Data\OECD - Quality of Life.csv') as f:
    rowCount = 0
    for line in csv.reader(row for row in f):
        if rowCount == 0:
            tempDf = pd.DataFrame(index=None, columns=line)
            rowCount = 1;
        else:
            for i in range(len(line)):
                tempDf.set_value(newDf.columns[i], rowCount, line[i])
            rowCount += 1
    tempDf

# the easy way
otherDf = pd.read_csv('Data\OECD - Quality of Life.csv')
