"""
Covers:
 - Functions are first class objects
 - Function argumnents
 - Higher-order functions
 - Anonymous functions
 - Pure functions
 - Recursion
 - Iterators
 - Generators
 - Decorators
 - The operator module
 - The functools module
 - The itertools module
 - The toolz, fn and funcy modules
"""

# Exercises
"""http://people.duke.edu/~ccc14/sta-663/FunctionsSolutions.html#exercises"""


"""1. Rewrite the following nested loop as a list comprehension
    ans = []
    for i in range(3):
        for j in range(4):
            ans.append((i, j))
    print ans"""

arr = [(i,j) for i in range(3) for j in range(4)]
arr


"""2. Rewrite the following as a list comprehension
        ans = map(lambda x: x*x, filter(lambda x: x%2 == 0, range(5)))
        print ans"""

arr = [x**2 for x in range(5) if x%2 == 0]


"""3. Convert the function below into a pure function with no global variables or side effects
    x = 5
    def f(alist):
        for i in range(x):
            alist.append(i)
        return alist
    
    alist = [1,2,3]
    ans = f(alist)
    print ans
    print alist # alist has been changed!"""

def f(alist, x):
    newList = alist.copy()
    for i in range(x):
        newList.append(i)
    return newList
    
alist = [1,2,3]
ans = f(alist, 5)
print(ans)
print(alist) # alist has been changed!"""
    
# better example
def f2(alist, x):
    return alist + [n for n in range(x)]

alist2 = [1,2,3]
ans2 = f2(alist2, 5)
print(ans2)
print(alist2) # alist has been changed!"""

# even better example
def f3(alist, x):
    return alist + range(x)


"""4. Write a decorator hello that makes every wrapped function print “Hello!”
    For example:
        @hello
        def square(x):
            return x*x"""

#import datetime
def TimeThis(func):
    def timer(*arg1, **arg2):
        start = datetime.datetime.now()
        func(*arg1, **arg2)
        end = datetime.datetime.now()
        return print(end - start)
    return timer

@TimeThis
def readfile(str):
    return [line for line in open(str)]

readfile("requirements.txt")


"""5. Rewrite the factorial function so that it does not use recursion.
    def fact(n):
        # base case
        if n==0:
            return 1
        # recursive case
        else:
            return n * fact(n-1)"""

# still uses recursion
def factCached(n, cache={0:1, 1:1}):
    try:
        return cache[n]
    except:
        cache[n] = n * factCached(n-1)
        return cache[n]

# assignment
def factAssignment(n):
    x = 1
    if n == 0 or n == 1:    
        return x
    else:
        for i in range(1, n+1):
            x *= i
        return x

arr1 = [factCached(x) for x in range(10)]
arr2 = [factAssignment(x) for x in range(10)]


"""Exercise 6. Rewrite the same factorail funciotn so that it uses a cache to speed up calculations"""

# still uses recursion
def factCached(n, cache={0:1, 1:1}):
    try:
        return cache[n]
    except:
        cache[n] = n * factCached(n-1)
        return cache[n]

arrEx6 = [factCached(x) for x in range(10)]


"""7. Rewrite the following anonymous functiona as a regular named fucntion: lambda x, y: x**2 + y**2"""

@TimeThis
def hypotSquared(x, y):
    return x**2 + y**2

import math
@TimeThis
def hypotSquaredAlt(x, y):
    return math.hypot(x, y)**2

hypotSquared(3,6)
hypotSquaredAlt(3,6)


"""8. Find an efficient way to extrac a subset of dict1 into a a new dictionary dict2 
that only contains entrires with the keys given in the set good_keys. Note that good_keys 
may include keys not found in dict1 - these must be excluded when building dict2.

    import numpy as np
    import cPickle

    try:
        dict1 = cPickle.load(open('dict1.pic'))
    except:
        numbers = np.arange(1e6).astype('int') # 1 million entries
        dict1 = dict(zip(numbers, numbers))
        cPickle.dump(dict1, open('dict1.pic', 'w'), protocol=2)

    good_keys = set(np.random.randint(1, 1e7, 1000)"""

dict1 = {str(x): x**2 for x in range(1, 100)}
good_keys = set(str(x) for x in range(30, 70))
dict2 = {x: dict1[x] for x in dict1.keys() if x in good_keys}