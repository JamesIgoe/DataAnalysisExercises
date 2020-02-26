
# Vectors

x <- c(1, 2.5, 4.5)
class(x)
length(x)
attributes(x)
typeof(x)
is.integer(x)
is.double(x)
is.logical(x)
is.atomic(x)
is.vector(x)
is.array(x)
f <- factor(x)
f

# With the L suffix, you get an integer rather than a double
x <- c(1L, 6L, 10L)
class(x)
length(x)
attributes(x)
typeof(x)
is.integer(x)
is.double(x)
is.logical(x)
is.atomic(x)
is.vector(x)
is.array(x)

# Use TRUE and FALSE (or T and F) to create logical vectors
x <- c(TRUE, FALSE, T, F)
class(x)
length(x)
attributes(x)
typeof(x)
is.integer(x)
is.double(x)
is.logical(x)
is.atomic(x)
is.vector(x)
is.array(x)
f <- factor(x)
f
attributes(f)


x <- c("these are", "some strings")
class(x)
length(x)
attributes(x)
typeof(x)
is.integer(x)
is.double(x)
is.logical(x)
is.character
is.atomic(x)
is.vector(x)
is.array(x)
f <- factor(x)
f

#is.call
#is.complex
#is.data.frame
#is.element
#is.empty.model
#is.environment
#is.expression
#is.factor
#is.finite
#is.function



c(1, c(2, c(3, 4))) == c(1, 2, 3, 4)



# Corercion

x <- c("a", 1)
x
typeof(x)

x <- str(c("a", 1))
x
typeof(x)


x <- c(FALSE, FALSE, TRUE, T, F, T, T, T)
y <- as.numeric(x)
z <- as.character(x)

x
y
z

# Total number of TRUEs
sum(x)
sum(y)
sum(z)

# Proportion that are TRUE
mean(x)
mean(y)
mean(z)


# Lists

l <- list(x, y, z)
l

m <- c(unlist(x), unlist(y), unlist(z))
m
m[4]
m[14]
m[24]



#Exercises

# What are the six types of atomic vector ? How does a list differ from an atomic vector ?
# Answer: int, float, character, logical, imaginary, raw

# What makes is.vector() and is.numeric() fundamentally different to is.list() and is.character() ?
#   becuase is.vector and is.numeric are generic, while is.list and is.character are mre specific

# Test your knowledge of vector coercion rules by predicting the output of the following uses of c():
# c(1, FALSE)
# Answer: 1 0
c(1, FALSE)
# c("a", 1)
# Answer: coerces to character as "a" "1"
c(list(1), "a")
# c(TRUE, 1L)
# Answer: Coerces to integer 1 1
c(TRUE, 1L)


# Why do you need to use unlist() to convert a list to an atomic vector ? Why doesn ’t as.vector() work ?
#   As vector removes attributes and does not unpack the structure

# Why is 1 == "1" true ? Why is - 1 < FALSE true ? Why is "one" < 2 false ?
#   values are coerced, in decreasing order of peecedence:
#       character, complex, numeric, integer, logical and raw.
# Answer: true, because 1 ==1, or "1" == "1""
1 == "1"
# Answer: true, becuase FALSE is coerced to 0
-1 < FALSE
# Answer: false, because "one" is "2"
"one" < 2

# Why is the default missing value, NA, a logical vector?
# What ’s special about logical vectors?
# (Hint:think about c(FALSE, NA_character_) .)
x <- c(FALSE, NA, TRUE)
is.na(x)
# Answer: Because logical is coercible to every other type, expect raw


# Attributes

intList <- 1:10
attr(intList, "Name") <- "Integer List"
attr(intList, "Parent") <- "Some Object"
attr(intList, "Type") <- "Integer List"

attr(y, "Name")
attr(y, "Parent")
attr(y, "Type")

str(attributes(intList))

# Structure creates a copy of the object, and allows one to change the attributes
intList2 <- structure(1:10, Name = "New Integer LIst", Parent = "Same Parent Object", TYpe = "Same Integer List")
str(attributes(intList2))

#modifying the object, usally removes the attributes
intList <- c(intList, 11)
str(attributes(intList))

# name method, on existing list
intList <- 1:3
names(intList) <- c('one', 'two', 'three')
names(intList)

# SetNames method, on new list
intListCopy <- setNames(intList,c("1", "2", "3"))
names(intListCopy)


#Factors

oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")
summary(oecdData)
country.vector <- oecdData$Country
country.factors <- factor(country.vector)
country.factors

#  Australia
country.factors[1]

# Should error, assigning nonexistent value
country.factors[1] <- 'test'

# Should work
country.factors[1] <- country.factors[2]
# Displays Austria
country.factors[1]

country.factors[1] <- 'Australia'
# Displays Australia
country.factors[1]


# Exercises
# An early draft used this code to illustrate structure():
# structure(1:5, comment = "my attribute")
# > [1] 1 2 3 4 5
# But when you print that object you don ’t see the comment attribute. 
# Why ? Is the attribute missing, or is there something else special about it?
# (Hint:try using help.)
#
x <- structure(1:5, comment = "my attribute")
x
attributes(x)

# What happens to a factor when you modify its levels ?
# f1 <- factor(letters)
# levels(f1) <- rev(levels(f1))
# Answer: They usually are NULLed, except in the case of some special attributes, like Class
f1 <- factor(letters)
levels(f1) <- rev(levels(f1))
f1

# What does this code do ? How do f2 and f3 differ from f1 ?
# f2 <- rev(factor(letters))
# f3 <- factor(letters, levels = rev(letters))
#
# Answer: They are newly created, ad both will have their factors
f2 <- rev(factor(letters))
f3 <- factor(letters, levels = rev(letters))
f2
f3

# Matrices and arrays

# using dim on a vector
oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")
summary(oecdData)
country.vector <- oecdData$Country
country.vector
country.factors <- factor(country.vector)
country.factors

is.matrix(country.vector)
is.array(country.vector)

is.matrix(country.factors)
is.array(country.factors)

country.matrix <- country.vector

dim(country.matrix) <- c(6, 4)
country.matrix

is.matrix(country.matrix)
is.array(country.matrix)

length(country.matrix)
nrow(country.matrix)
ncol(country.matrix)
names(country.matrix)

country.transposed <- t(country.matrix)
country.transposed

is.matrix(country.transposed)
is.array(country.transposed)

str(country.vector)
str(country.factors)
str(country.matrix)
str(country.transposed)

# Exercises

# What does dim() return when applied to a vector?
# Answer:  a matrix, when supplied rows and columns

#If is.matrix(x) is TRUE, what will is.array(x) return?
# Answer: TRUE

# How would you describe the following three objects?
# What makes them different to 1:5 ?
# x1 <- array(1:5, c(1, 1, 5))
# x2 <- array(1:5, c(1, 5, 1))
# x3 <- array(1:5, c(5, 1, 1))
x1 <- array(1:5, c(1, 1, 5))
x2 <- array(1:5, c(1, 5, 1))
x3 <- array(1:5, c(5, 1, 1))
x1
x2
x3
# Answer: takes the same vakues, but creates arrays of different dimensnation


# Data frames

oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")
country.vector <- oecdData$Country
country.vector


df1 <- data.frame(oecdData$Country)
df2 <- data.frame(oecdData$Country, stringsAsFactors = FALSE)
df1
df2

# Exercises
# What attributes does a data frame possess ?
attributes(df1)
nrow(df1)
ncol(df1)
# Answer: names, row.names, class, nrows, ncol

# What does as.matrix() do when applied to a data frame with columns of different types ?
class(oecdData)
m <- as.matrix(oecdData)
oecdData
m
# Answer: cerces to a single type, in this case string

# Can you have a data frame with 0 rows ? What about 0 columns ?
test <- data.frame()
test
# Answer: yes, to both, can be both zero rows and zero columns
