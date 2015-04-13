##############################
# Lookup
##############################
cor(dataframe)

plot(dataframe$name)
pairs(dataframe)
pie(rep(1, 20), col = rainbow(20))

layout(matrix(c(1,2,3,4), 2, 2, byrow=TRUE))

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
