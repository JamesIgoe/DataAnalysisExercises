################################  
# performance  
# vectorization and memoization  
################################

# clear memory between changes
rm(list = ls())

# load memoise
#install.packages('memoise')
library(memoise)

# create test function
monte_carlo = function(N) {
    hits = 0
    for (i in seq_len(N)) {
        u1 = runif(1)
        u2 = runif(1)
        if (u1 ^ 2 > u2)
            hits = hits + 1
        }
    return(hits / N)
}

# memoise test function 
monte_carlo_memo <- memoise(monte_carlo)

# vectorize function
monte_carlo_vec <- function(N) mean(runif(N) ^ 2 > runif(N))

# memoise vectorized function
monte_carlo_vec_memo <- memoise(monte_carlo_vec)

# run test - pass 1   
n <- 999999
plainFor <- system.time(monte_carlo(n))
memoised <- system.time(monte_carlo_memo(n))
vectorised <- system.time(monte_carlo_vec(n))
both <- system.time(monte_carlo_vec_memo(n))

# results - pass 1   
result <- cbind(plainFor, memoised, vectorised, both)
display <- format(result, digits = 3, nsmall = 3)
View(display)

# run test - pass 2   
plainFor <- system.time(monte_carlo(n))
memoised <- system.time(monte_carlo_memo(n))
vectorised <- system.time(monte_carlo_vec(n))
both <- system.time(monte_carlo_vec_memo(n))

# results - pass 2   
result <- cbind(plainFor, memoised, vectorised, both)
display <- format(result, digits = 3, nsmall = 3)
View(display)

#install.packages("microbenchmark")
library(microbenchmark)
n <- 999999
comparison <- microbenchmark(times = 10, memoised = system.time(monte_carlo_memo(n)), vectorised = system.time(monte_carlo_vec(n)), both = system.time(monte_carlo_vec_memo(n)))

#library(ggplot2)
autoplot(comparison)


