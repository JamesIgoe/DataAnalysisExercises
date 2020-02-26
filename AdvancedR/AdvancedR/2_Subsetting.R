# Quiz

# Take this short quiz to determine if you need to read this chapter.
# If the answers quickly come to mind, you can comfortably skip this chapter.
# Check your answers in answers.
#
# What is the result of subsetting a vector with 
#  positive integers, negative integers, a logical vector, or a character vector ?
# extract, delete, extract/delete, names vecotr elements?
abcs <- c(letters)
abcs <- abcs[1:6]
abcs
abcs1 <- abcs[-4]
abcs1
abcs3 <- abcs[c(1,3,5)]
abcs3
abcs4 <- c(abcs1,abcs3)
abcs4
abcs5 <- factor(abcs4)
abcs5


# What ’s the difference between[, [[, and $ when applied to a list ?
# selects element of a list, selects elements of a list, short hand for [[
abcs <- c(letters)
abcs <- abcs[1:6]
abcs
abcs1 <- abcs[[2]]
abcs1
abcs3 <- abcs[c(1, 3, 5)]
abcs3
abcs4 <- c(abcs1, abcs3)
abcs4
abcs5 <- factor(abcs4)
abcs5

abcs1

# When should you use drop = FALSE ?
# 

# If x is a matrix, what does x[] <- 0 do ? How is it different to x <- 0 ?
#
abcs <- c(letters)
abcs
abcs.matrix <- as.matrix(abcs, nrows=13, ncols=2)
abcs.matrix

# sets all values to 0, and coalesces type, but keeps matrix
abcs.matrix[] <- 0
abcs.matrix

# sets variable to 0
abcs.matrix <- 0
abcs.matrix

# How can you use a named vector to relabel categorical variables ?
# 
# Answer: gives names to values
x <- c(x = 1, y = 2, z = 3)[c("y", "z", "x")]
x["y"]


# Data Sets

x <- c(2.1, 4.2, 3.3, 5.4)

# five ways to subset a vector:

# Positive integers return elements at the specified positions:
x[c(3, 1)]
x[order(x)]

# Duplicated indices yield duplicated values
x[c(1, 1)]
#> [1] 2.1 2.1

# Real numbers are silently truncated to integers
x[c(2.1, 2.9)]

# Negative integers omit elements at the specified positions:
x[-c(3, 1)]

# You can ’t mix positive and negative integers in a single subset:
x[c(-1, 2)]

# Logical vectors select elements where the corresponding logical value is TRUE. 
x[c(TRUE, TRUE, FALSE, FALSE)]

# This is probably the most useful type of subsetting because you write the expression that creates the logical vector:
x[x > 3]
x[x < 3]

# Character vectors to return elements with matching names.
y <- setNames(1:26, letters)
y
y[c("d", "c", "a")]


# Lists
# Subsetting a list works in the same way as subsetting an atomic vector.
# Using [ will always return a list; [[ and $ , as described below,
# let you pull out the components of the list
y <- c(1:26)
y

# returns list
z1 <- y[1:6]
z1

# error
z2 <- y[[1:6]]

# correct
z2 <- y[[1]]
z2


# Matrices and arrays
abcs <- 0
abcs <- matrix(letters, ncol=13)
abcs
abcs <- matrix(letters, nrow = 13)
abcs
colnames(abcs) <- c("higher", "lower")
abcs
abcs[c(10, 20)]

select <- matrix(ncol = 2, byrow = TRUE, c(1, 1, 3, 1, 13, 2))
abcs[select]


# Data frames

#Exercises
# Fix each of the following common data frame subsetting errors:
#   mtcars[mtcars$cyl = 4,]
#   mtcars[-1:4,]
#   mtcars[mtcars$cyl <= 5]
#   mtcars[mtcars$cyl == 4 | 6,]

mtcars[mtcars$cyl][4,]
mtcars[1:4,]
mtcars[mtcars$cyl] <= 5
mtcars[mtcars$cyl == 4 | 6,]

# Why does x <- 1:5; x[NA] yield five missing values ? (Hint:why is it different from x[NA_real_] ? )
x <- 1:5
x[NA]
x[NA_real_]

# What does upper.tri() return ? How does subsetting a matrix with it work ? Do we need any additional subsetting rules to describe its behaviour ?
#   x <- outer(1:5, 1:5, FUN = "*")
#   x[upper.tri(x)]
x <- outer(1:5, 1:5, FUN = "*")
x[upper.tri(x)]

x <- outer(1:5, 1:5, FUN = "+")
x[upper.tri(x)]

x <- outer(1:5, 1:5, FUN = "-")
x[upper.tri(x)]

x <- outer(1:2, 1:2, FUN = "*")
x[upper.tri(x)]

x <- outer(1:3, 1:3, FUN = "*")
x[upper.tri(x)]

x <- outer(1:2, 1:3, FUN = "*")
x[upper.tri(x)]

x <- outer(1:3, 1:2, FUN = "*")
x[upper.tri(x)]


# Why does mtcars[1:20] return an error ? How does it differ from the similar mtcars[1:20,] ?
mtcars[1:20]
mtcars[1:20, ]
mtcars
mtcars[1:20,1]
# Answer: mtcars is a dataframe, and needs to know the rows and columns to return

# Implement your own function that extracts the diagonal entries from a matrix(it should behave like diag(x) where x is a matrix) .
items.v = c(1:20)
items.v
items.matrix = matrix(data = items.v, nrow = 5, ncol = 4)
items.matrix
diag(items.matrix)
items.matrix[1, 1]

# Answer: algo, starting at i=1 at i,i then increase loop increasing i to i <= columns
new.diag <- function(matrix) {
    iter <- c(1:dim(matrix)[2])
    return.v <- c()
    for (i in iter) {
        return.v <- c(return.v, matrix[i, i])
    }
    return.v
}
new.diag(items.matrix)

# What does df[is.na(df)] <- 0 do ? How does it work ?






