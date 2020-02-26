##########################################
#
# Performance Testing - Microbenchmark
# 
##########################################

# clear memory between changes
rm(list = ls())


##########################################
# Load packages
##########################################

# load memoise
#install.packages('memoise')
library(memoise)

# load microbenchmark
#install.packages("microbenchmark")
library(microbenchmark)

# load ggplot2
#install.packages("ggplot2")
library(ggplot2)


##########################################
# Create functions
##########################################

# base function
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


##########################################
# Run test
##########################################

n <- 999999
comparison <- microbenchmark(times = 100, memoised = system.time(monte_carlo_memo(n)), vectorised = system.time(monte_carlo_vec(n)), both = system.time(monte_carlo_vec_memo(n)))
comparison


##########################################
# Run test
##########################################

autoplot(comparison)


