# TODO: review, compact

##############################
# Lookup
##############################

cor(dataframe)
summary(x)
str(x)
svd(matrix)$d

plot(dataframe$name)
boxplot()
pairs(dataframe)
pie(rep(1, 20), col = rainbow(20))
hist()

layout(matrix(c(1,2,3,4), 2, 2, byrow=TRUE))

##############################
# Overview
##############################
View(data) # UX view table

##############################
# Reading
##############################

initial <- read.table("dataset.txt", nrows = 100)
classes <- sapply(initial, class)
tabAll <- read.table("dataset.txt", colClasses = classes)

data <- read.csv("foo.txt")

con <- file("foo.txt", "r")
data <- read.csv(con)
close(con)

con <- gzfile("words.gz") # || con <- url("http://www.jhsph.edu", "r")
x <- readLines(con, 10)
head(x)

##############################
# Subsetting
##############################

x <- c("a", "b", "c", "c", "d", "a")
x[1]
x[[1]]
x[1:3]
x[x > "a"]

x <- list (foo=1:4, bar=0.6)
x[1]
x[[1]]
x$bar
x['bar']
x[['bar']]

x <- list(foo=1:4, bar=0.6, baz="hello")
name <- "foo"
x[[name]] # ok
x$name # fail
x$foo # ok

# The [[ can take an integer sequence
x <- list(a=list(10,12,14), b=c(3.14, 2.81))
x[[c(1,3)]]
x[[2]][[1]]

x <-matrix(1:6, 2, 3)
x[1,2] # vector
x[1,2,drop=FALSE] # 1x1 matrix

x <- c(1, 2, NA, 4, NA, 5)
bad <- is.na(x)
x[!bad]

x <- c(1, 2, NA, 4, NA, 5)
y <- c("a", "b", NA, NA, "d", "f")
good <- complete.cases(x, y) # complete in both vectors
x[good]
y[good]


##############################
# Control
##############################

# Assign value in control structures
y <- if(x > 3) {
  10
} else {
  5
}

##############################
# Functions
##############################

# Variadic param
myplot <- function(x,y, type ="1", ...) {
  plot(x,y,type=type,...)
}

# Closures
make.power <- function(n) {
  pow <- function(x) {
     x^n
  }
}
cube <- make.power(3)
square <-make.power(4)
cube(4)
square(3)

##############################
# Describers
##############################

args(function)
str(type)

ls(environment(cube)); get("n", environment(cube))


#############################
# Loop functions
#############################

# lapply() - loop over a list and evaluate a function on each element
# sapply() - same as lapply but try to simplify the result
# apply()  - apply a function over the margins of an array
# tapply() - apply a dunction over subset of of a vector
# mapply() - multivariate version of lapply
#
# An auxiliary function split() is also useful, particularly in conjunction
# with lapply().

# lapply() always returns a list.
x <- list(a=1:5, b=rnorm(10))
lapply(x, mean)

x <- list(a=1:4, b=rnorm(10), c=rnorm(20,1), d=rnorm(100,5))
lapply(x, mean)

x<-1:4
lapply(x, runif) # runif - gen N randoms

x<-1:4
lapply(x, runif, min=0, max=10)


############
# lapply() and friends make heavy use of anonymous functions.
x <- list(a=matrix(1:4,2,2), b=matrix(1:6, 3, 2))
# An anonymous function for extracting the first column of each matrix.
str(lapply) # (X, FUN, ...)
lapply(x, function(elt) elt[,1])

############
# sapply() will try to simplify the result of lapply if possible.
# - if the result is a list where every element is length 1, then
#   a vector is returned
# - if the result is a list where every element is a vector of the same
#   length(>1), a matrix is returned
# - if if can't figure things out, a list is returned
x <- list(a=1:4, b=rnorm(10), c=rnorm(20,1), d=rnorm(100,5))
str(sapply) # (X, FUN, ..., simplify = TRUE, USE.NAMES = TRUE)
sapply(x, mean)
mean(x$b)

############
# apply() is used to a evaluate a function (often an anonymous one)
# over the margins of an array.
# - It is most often used to apply a function to the rows or columns
#   of a matrix
# - It can be used with general arrays, e.g. taking the average of an
#   array of matrices
# - It is not really faster than writing a loop, but it works in one line!
str(apply) # (X, MARGIN, FUN, ...)
# x - is an array
# MARGIN - is an int vec indicating which margins should be "retained"
# FUN - is a function to be applied
# ... - args for FUN

x <- matrix(rnorm(200), 20, 10)
apply(x,2,mean) # calc by 2-nd dimension and means over columns
apply(x,1,mean) # calc by 1-st dimension and means over rows

# Shortcuts
rowSums = apply(x, 1, sum);rowSums
rowMeans = apply(x, 1, mean);rowMeans
colSums = apply(x, 2, sum);colSums
colMeans = apply(x, 2, mean);colMeans

x <- matrix(rnorm(200), 20, 10)
apply(x, 1, quantile, probs=c(0.25, 0.75))

# Average matrices(2x2) in an array, collapse 3rd dim
a <- array(rnorm(2*2*10), c(2,2,10))
apply(a, c(1,2), mean)
# same as
rowMeans(a, dims=2)

############
# mapply() is a multivariate apply of sorts which applies a function
# in parallel over a set of arguments.
str(mapply) # (FUN, ..., MoreArgs = NULL, SIMPLIFY = TRUE, USE.NAMES = TRUE)
# FUN - function to apply
# ... - contains arguments to apply over
# MoreArgs - is a list of other arguments to FUN
# SIMPLIFY - indicates whether the result should be simplified

# The following is tedious to type
list(rep(1,4), rep(2,3), rep(3,2), rep(4,1))
# same as
mapply(rep, 1:4, 4:1)

# Vectorizing a Function
noise <- function(n, mean, sd) {
    rnorm(n, mean, sd)
}
noise(5,1,2)
noise(1:5,1:5,2) # bad, want so:
mapply(noise, 1:5, 1:5, 2) # which is the same as
list(noise(1,1,2), noise(2,2,2), noise(3,3,2), noise(4,4,2), noise(5,5,2))

############
# tapply() - is used to apply a function over subsets of a vector.
str(tapply) # (X, INDEX, FUN = NULL, ..., simplify = TRUE)
# X - is a vector
# INDEX - is a factor or a list of factors (they are coerced to factors)
# FUN - is a function to be applied
# ... - contains other arguments to be passed FUN
# simplify - should we simplify the result?

# Take group means.
x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3,10) # 3 levels by 10 elems
f
tapply(x, f, mean)
tapply(x, f, mean, simplify=FALSE)

# Find group ranges
tapply(x, f, range)


#############################
# Split
#############################

x <- c(rnorm(10), runif(10), rnorm(10,1));x
f <- gl(3,10) # factor 3 levels by 10 elems
y <- split(x,f)

# Split by month
library(datasets)
head(airquality)
s<-split(airquality, airquality$Month)
lapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")], na.rm=TRUE))
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")], na.rm=TRUE))

# Splitting on More than One Level
x <- rnorm(10)
f1 <- gl(2,5);f1
f2 <- gl(5,2);f2
interaction(f1,f2)

# Interactions can create empty levels
str(split(x, list(f1, f2)))
# But they also can be dropped
str(split(x, list(f1, f2), drop=TRUE))

#############################
# Debug
#############################

rm(x)
mean(x)
traceback()

rm(y)
lm(y-x)
traceback()

debug(lm)
lm(y-x)

options(error = recover) # hmmm nice!
read.csv("nosuchfile")


