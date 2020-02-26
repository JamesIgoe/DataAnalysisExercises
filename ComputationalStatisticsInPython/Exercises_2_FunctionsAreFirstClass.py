# Tutorial
"""http://people.duke.edu/~ccc14/sta-663/FunctionsSolutions.html"""


# Higher Order Functions
"""http://people.duke.edu/~ccc14/sta-663/FunctionsSolutions.html#higher-order-functions"""

def power_function(num, power):
    """power of num."""
    return num**power

def add_function(num, more):
    """sum of num."""
    return num+more

def runFunction(fx, x, y):
    return fx(x,y)

num = 2
powers = range(0,64)

arrPower = list(map(lambda x: runFunction(power_function, num, x), powers))
arrAdd = list(map(lambda x: runFunction(add_function, num, x), powers))

arrPower
arrAdd


# Recursion
"""http://people.duke.edu/~ccc14/sta-663/FunctionsSolutions.html#recursion"""

# Correct Example
def fibonacci(n):
    if n==0 or n==1:
        return 1
    else:
        return fibonacci(n-1) + fibonacci (n-2)

[fibonacci(n) for n in range(10)]

def fibonacciWithCache(n, cache={0:1, 1:1}):
    try:
        return cache[n]
    except:
        cache[n] = fibonacci(n-1) + fibonacci (n-2)
        return cache[n]

[fibonacciWithCache(n) for n in range(10)]

# Correct Example
def factorial(n):
    if n==0:
        return 1
    else:
        return n * factorial(n-1)

# Correct Example, with caching
def factorialWithCache(n, cache={0:1}):
    try:
        return cache[n]
    except KeyError:
        cache[n] = n * factorial(n-1)
        return cache[n]

#5! = 1*2*3*4*5
[factorial(n) for n in range(100)]
[factorialWithCache(n) for n in range(100)]


def FibonacciNonRecursive(n):
    """Fib without recursion.
    Note: uses assignment reversal"""
    a, b = 0, 1
    for i in range(1, n+1):
        a, b = b, a+b
    return b

[FibonacciNonRecursive(i) for i in range(1)]


# Iterators can be created from sequences with the built-in function iter()
"""http://people.duke.edu/~ccc14/sta-663/FunctionsSolutions.html#iterators"""

xs = [n for n in range(10)]
x_iter = iter(xs)

[x for x in x_iter]

for x in x_iter:
    print(x)


# Generators
"""http://people.duke.edu/~ccc14/sta-663/FunctionsSolutions.html#generators"""

# Functions containing the 'yield' keyword return iterators
# After yielding, the function retains its previous state
def limit_seats(n):
    """Limits number and counts down"""
    for i in range(n, 0, -1):
        yield i

counter = limit_seats(10)

for count in counter:
    print(count)


# Iterators can also be created with 'generator expressions'
# which can be coded similar to list generators but with parenthesis
# in place of square brackets
maxUsers = [x for x in range(10)]
for x in maxUsers:
    print(x)

# Many built-in Python functions return iterators including file handlers
for line in open('requirements.txt'):
    print(line)


# Decorators
# Here is a simple decorator to time an arbitrary function
def func_timer(func):
    """Times how long the function took."""
    def f(*args, **kwargs):
        import time
        start = time.time()
        results = func(*args, **kwargs)
        print("Elapsed: %.2fs" % (time.time() - start))
        return 

@func_timer
def fibonacciWithCacheWithTimer(n, cache={0:1, 1:1}):
    try:
        return cache[n]
    except:
        cache[n] = fibonacci(n-1) + fibonacci (n-2)
        return cache[n]

[fibonacciWithCacheWithTimer(n) for n in range(10)]



# The functools module
"""The most useful function in the functools module is partial, which allows you to create 
a new function from an old one with some arguments “filled-in”."""

from functools import partial
def power_function(power, num):
    """power of num."""
    return num**power

square = partial(power_function, 2)
cube = partial(power_function, 3)
quad = partial(power_function, 4)



# The itertools module
"""This provides many essential functions for working with iterators. 
The permuations and combinations generators may be particularly useful 
for simulations, and the groupby gnerator is useful for data analyiss."""

from itertools import cycle, groupby, islice, permutations, combinations

simualtedDataSeries = list(islice(cycle('abcd'), 0, 20))

simulatedSeries = list(islice(cycle('acgt'), 0, 4))
[p for p in permutations(simulatedSeries)]

text = [line for line in open('requirements.txt')]
pairs = [(k, g) for k, g in groupby(text, key=len)]

