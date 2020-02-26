# Tutorial
"""http://people.duke.edu/~ccc14/sta-663/IntroductionToPythonSolutions.html"""


# Tutorial Exercises
"""http://people.duke.edu/~ccc14/sta-663/IntroductionToPythonSolutions.html#exercises"""


"""1. Solve the FizzBuzz probelm
“Write a program that prints the numbers from 1 to 100. But for multiples of three print “Fizz” 
instead of the number and for the multiples of five print “Buzz”. 
For numbers which are multiples of both three and five print “FizzBuzz”."""
def fizz_buzz(begin, end):
    """Write a program that prints the numbers from 1 to 100.
    But for multiples of three print “Fizz” instead of the number
    and for the multiples of five print “Buzz”.
    For numbers which are multiples of both three and five print “FizzBuzz"""
    for i in range(begin, end):
        if i%3 == 0 & i%5 == 0:
            print("FizzBuzz")
        elif i%5 == 0:
            print("Buzz")
        elif i%3 == 0:
            print("Fizz")
        else:
            print(i)

fizz_buzz(0,100)


"""2. Given x=3 and y=4, swap the values of x and y so that x=4 and y=3."""
x, y = 3, 4
x, y = y, x
x


"""3. Write a function that calculates and returns the euclidean distance between two points u and v, 
where u and v are both 2-tuples (x,y)(x,y). For example, if u=(3,0) and v=(0,4), 
the function should return 55."""
import math
def euclidean(UPoint, VPoint, ShortCalc):
    """Write a function that calculates and returns the euclidean distance 
    between two points u and v, where u and v are both 2-tuples (x,y). 
    For example, if u=(3,0) and v=(0,4) the function should return 5."""
    try:
        if ShortCalc == False:
            hyp = UPoint[0]**2 + VPoint[1]**2
            return hyp**.5
        elif ShortCalc == True:
            return math.hypot(UPoint[0], VPoint[1])
    except:
        return 0

euclidean((3,0),(0,4),True)


"""4. Using a dictionary, write a program to calculate the number times each character occurs in the given string s. 
Ignore differneces in capitalization - i.e ‘a’ and ‘A’ should be treated as a single key. For example, 
we should get a count of 7 for ‘a’."""
import string
someString = """Write a function that calculates and returns the euclidean distance 
    between two points u and v, where u and v are both 2-tuples (x,y). 
    For example, if u=(3,0) and v=(0,4) the function should return 5."""

def CountCharacters(someString):
     """Using a dictionary, write a program to calculate the number times 
     each character occurs in the given string s. Ignore differneces in 
     capitalization - i.e ‘a’ and ‘A’ should be treated as a single key. 
     For example, we should get a count of 7 for ‘a’."""
     arr = list(someString.lower())
     arrUnique = dict.fromkeys(set(arr), 0)
     for item in arrUnique:
         arrUnique[item] = arr.count(item)
     return arrUnique

def CountCharactersAlt(someString):
     """Using a dictionary, write a program to calculate the number times 
     each character occurs in the given string s. Ignore differneces in 
     capitalization - i.e ‘a’ and ‘A’ should be treated as a single key. 
     For example, we should get a count of 7 for ‘a’."""
     newDict = {}
     for item in list(someString.lower()):
         try:
             val = newDict.get(item)
             newDict[item] = val + 1
         except:
             newDict[item] = 1
     return newDict

def CountCharactersAlt2(someString):
     """Using a dictionary, write a program to calculate the number times 
     each character occurs in the given string s. Ignore differneces in 
     capitalization - i.e ‘a’ and ‘A’ should be treated as a single key. 
     For example, we should get a count of 7 for ‘a’."""
     newDict = {}
     for item in someString.lower():
         newDict[item] = newDict.get(item, 0) + 1
     return newDict

CountCharacters(someString)
CountCharactersAlt(someString)
CountCharactersAlt(someString)


"""5. Write a program that finds the percentage of sliding windows of length 5 for the sentence s that 
contain at least one ‘a’. Ignore case, spaces and punctuation. For example, the first sliding window 
is ‘write’ which contains 0 ‘a’s, and the second is ‘ritea’ which contains 1 ‘a’."""
import string
somestring = """Write a function that calculates and returns the euclidean distance 
    between two points u and v, where u and v are both 2-tuples (x,y). 
    For example, if u=(3,0) and v=(0,4) the function should return 5."""

def Sliding_Windows_Percentage(someString, findThis):
     """Write a program that finds the percentage of sliding windows 
     of length 5 for the sentence s that contain at least one ‘a’. 
     Ignore case, spaces and punctuation. For example, the first 
     sliding window is ‘write’ which contains 0 ‘a’s, and the second 
     is ‘ritea’ which contains 1 ‘a’."""
     exclude = set(string.punctuation)
     out = ''.join(ch for ch in somestring.replace(" ","").replace("/n","") if ch not in exclude)
     found_Counter = 0
     for i in range(0, len(out)-4):
         if findThis in out[i: i+4]:
             found_Counter += 1
     return found_Counter / (len(out)-4)

Sliding_Windows_Percentage(somestring, 'b')

"""6. Find the unique numbers in the following list."""
numList = [36, 45, 58, 3, 74, 96, 64, 45, 31, 10, 24, 19, 33, 86, 99, 18, 63, 70, 85,
 85, 63, 47, 56, 42, 70, 84, 88, 55, 20, 54, 8, 56, 51, 79, 81, 57, 37, 91,
 1, 84, 84, 36, 66, 9, 89, 50, 42, 91, 50, 95, 90, 98, 39, 16, 82, 31, 92, 41,
 45, 30, 66, 70, 34, 85, 94, 5, 3, 36, 72, 91, 84, 34, 87, 75, 53, 51, 20, 89, 51, 20]

#Soluton 1
list(dict.fromkeys(set(numList), 0).keys())

#Solution 2
list(set(numList) & set(numList))


"""8. Create a list of the cubes of x for x in [0, 10] using
a for loop
a list comprehension
the map function"""
testListForLoop = [x for x in range(0, 11)]
testListComprehension = [x**3 for x in range(0, 11)]
testListMap = list(map(lambda x: x**3, testListForLoop))


"""9. A Pythagorean triple is an integer solution to the Pythagorean theorem a2+b2=c2a2+b2=c2. 
The first Pythagorean triple is (3,4,5). Find all unique Pythagorean triples for the positive 
integers a, b and c less than 100."""
import math
def findTriples():
    """A Pythagorean triple is an integer solution to the Pythagorean theorem a2+b2=c2. 
    The first Pythagorean triple is (3,4,5). Find all unique Pythagorean triples for the positive 
    integers a, b and c less than 100."""
    resultList = list()
    for leg1 in range(1, 100):
        for leg2 in range(1, 100):
            leg3 = math.hypot(leg1, leg2)
            if leg3 == math.floor(leg3) & math.floor(leg3) <= 100:
                resultList.append([leg1,leg2,int(leg3)])
    return resultList

# The better solution
pythagorean_triples = [(a, b, c) for a in range(1, 100)
                                 for b in range(1, 100)
                                 for c in range(1, 100)
                                 if a**2 + b**2 == c**2]

pythagorean_triples


"""10. Fix the bug in this function that is intended to take a list of numbers 
and return a list of normalized numbers."""
def f(xs):
    """Return normalized list summing to 1."""
    s = 0
    for x in xs:
        s += x
    tempList = [(x/s)/2 for x in xs]
    return tempList + list(reversed(tempList))

