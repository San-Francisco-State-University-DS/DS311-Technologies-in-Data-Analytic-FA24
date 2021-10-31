################################
######    dplyr Package   ######
################################

### 1.1 - tbl Object and data.frame ###

# Note: if you want to use both dplyr and plyr, the plyr package should be imported first, 
# then import the dplyr package.  The reason is some of the object names are the same in the
# two packages and the last one being imported will be called.

# Importing the magritter package for pipe operation
library(magrittr)
# Importing the diamonds data set from ggplot2 library
data(diamonds, package='ggplot2')
dim(head(diamonds, n=4))

# Using pipe(%>%) to pass on an object to another object
diamonds %>% head(4) %>% dim

# The diamonds data set is saved as tbl, in fact, it's saved as tbl_df
class(diamonds)
# If we are not using dplyr or tbl package, the data set will be displayed as regular dataframe.
head(diamonds)

# After loading the dplyr package, the data set will be displayed as tbl object
library(dplyr)
head(diamonds)

# tbl displays the first 10 rows without the head() function
diamonds


### 1.2 - Select ###

# select() function takes the first agrument data.frame, then the column names.
select(diamonds, carat, price)

# Using a pipe(%>%) operator
diamonds %>% select(carat, price)

# Also can use vector c() within the pipe operator
diamonds %>% select(c(carat, price))

# We can also directly call out the column names with "select_" in standard evaluation version
diamonds %>% select_('carat', 'price')

# If we saving the column names into a vector
theCols <- c('carat', 'price')
# We can use .dots to call out the column names in a vector
diamonds %>% select_(.dots=theCols)

# An alternative for select_, is nesting select() with one_of()
diamonds %>% select(one_of('carat', 'price'))

# In this case, we can pass in the vector of column names directly
diamonds %>% select(one_of(theCols))

# We can also use a traditional R method
diamonds[,c('carat', 'price')]

# We can also select using the column index
select(diamonds, 1, 7)
diamonds %>% select(1, 7)

### 1.3 - Partial Match ###

# We can find partial match from the data frame using start_with, ends_with, and contains
diamonds %>% select(starts_with('c'))

diamonds %>% select(ends_with('e'))

diamonds %>% select(contains('l'))

# Using "matches" to find specific columns
# e.g. we can search for column names with "r" + "."(wildcard) + "t"
diamonds %>% select(matches('r.+t'))

# We can also remove the columns by using '-'
diamonds %>% select(-carat, -price)
diamonds %>% select(-c('carat', 'price'))
diamonds %>% select(-1, -7)
diamonds %>% select(-c(1,7))
diamonds %>% select_(.dots=c('-carat', '-price'))

# Another way is to use one_of() to select columns
diamonds %>% select(-one_of('carat', 'price'))


### 1.4 - Filter ###

# Using filter() function, we can sort out the specific rows from the data frame with a given condition
# e.g. sort out the rows that has value "Ideal" in the "cut" column
diamonds %>% filter(cut == 'Ideal')

# Using the traditional R syntex,
diamonds[diamonds$cut == 'Ideal',]

# We can use %in% to select the rows with one of the search values in a specific column
# e.g. sort out the rows that has either value "Ideal" or "Good" in the cut column
diamonds %>% filter(cut %in% c('Ideal', 'Good'))

# We can use any R standard logical operators with filter() function
diamonds %>% filter(price >= 1000)
diamonds %>% filter(price != 1000)

# Filtering with condition 1 AND condition 2
diamonds %>% filter(carat>2, price<14000)
diamonds %>% filter(carat>2 & price<14000)

# Filtering with condition 1 OR condition 2
diamonds %>% filter(carat<1 | carat>5)

# When using filter_() function, we need to pass in the condition in string
diamonds %>% filter_("cut == 'Ideal'")

# We can also use "~" to replace the outter quote ""
diamonds %>% filter_(~cut == 'Ideal')

# The advantage for using "~" instead of the quote "" is that variable can be used in filter_()
# e.g.
theCut <- 'Ideal'
diamonds %>% filter_(~cut == theCut)

# When both the column name and row value are stored into variables,
# we can use sprintf() function to combine in filter_()
# Note: it's not recommended with more complex conditions
# e.g.
theCol <- 'cut'
theCut <- 'Ideal'
diamonds %>% filter_(sprintf("%s == '%s'", theCol, theCut))

# A preferred method is using the interp() function in the lazyeval pacakge
library(lazyeval)

# Define the variables into an formula
# as.name(theCol) -> cut
# theCut -> 'Ideal'
interp(~ a == b, a=as.name(theCol), b=theCut)

# Put the formula into the filter_() function
diamonds %>% filter_(interp(~ a == b, a=as.name(theCol), b=theCut))

# If using dplyr 0.6.0 version, we can combine the use of filter() function and UQ() function from rlang pacakge
install.packages("rlang")
library(rlang)
diamonds %>% filter(UQ(as.name(theCol)) == theCut)


### 1.5 - Slice ###

# Unlike filter(), slice() function chooses rows by their ordinal position int he tbl.
# Grouped tbls use the ordinal position within the group.
# Vector indexing is required to pass into the slice() function
# e.g. slicing the first 5 rows of data from the data frame
diamonds %>% slice(1:5)

# Suppose we want to slice the first 5 rows, the 8th row, and 15th to 20th rows
diamonds %>% slice(1:5, 8, 15:20)

# Note that the return data frame will not have the original index
# When using a negative value, we are removing the row
# e.g. removing the first row
diamonds %>% slice(-1)


### 1.6 - Mutate ###

# mutate() function is used to update values of a column or adding new column to the data frame.
# e.g. Adding a new column using price divided by carat
diamonds %>% mutate(price/carat)

# Display the new column, by selecting the columns in the original data frame,
# then pass into mutate()
diamonds %>% select(carat, price) %>% mutate(price/carat)

# The new added column will not be given a column name
# We can define the name "Ratio" to the new column,
diamonds %>% select(carat, price) %>% mutate(Ratio=price/carat)

# The newly added column can be used in the same mutate().
# For instance, creating the "Ratio" column and a "Double" column by multiplying the "Ratio" by 2.
diamonds %>%
  select(carat, price) %>%
  mutate(Ratio=price/carat, Double=Ratio*2)

# Note that the code we use previously will not make change of the orignal data frame.
# It can be saved into a new data frame object.
# e.g.
diamonds2 <- diamonds %>%
  select(carat, price) %>%
  mutate(Ratio=price/carat, Double=Ratio*2)

diamonds2

# We can continue to add new column to the new data frame
diamonds2 <- diamonds2 %>%
  mutate(Quadruple=Double*2)

diamonds2

# magrittr package also has a pipe operator (%<>%) to mutate the data frame
# e.g.
diamonds3 <- diamonds
diamonds3

diamonds3 %<>%
  select(carat, price) %>%
  mutate(Ratio=price/carat, Double=Ratio*2)
diamonds3


### 1.7 - Summarize ###

# summarize() function will return mean, max, median or other similar statistics
# It allows direct call of the column name from the data frame, similar to with() in regular R.
# e.g. suppose we are interested the mean price in diamonds data set.
summarize(diamonds, mean(price))

# Using pipe operator,
diamonds %>% summarize(mean(price))

# One of the advantage using summarize() is that we can nest several statistics in one line of code.
diamonds %>% 
  summarize(AvgPrice = mean(price),
            MedianPrice = median(price),
            AvgCarat = mean(carat))


### 1.8 - Group By ###

# group_by() function complement the summarize() and make it more powerful to use.
# In most cases, we segment the data frame into different groups, then pass into summarize() function for specific statistics.
# e.g. suppose we are interested to know the average price for each cut grade
diamonds %>% 
  group_by(cut) %>%
  summarize(AvgPrice = mean(price))

# The combination (group_by() & summarize()) is much more efficient (faster) that using aggregate() 
# It also improves the readability and nesting process.
diamonds %>% 
  group_by(cut) %>%
  summarize(AvgPrice=mean(price), SumCarat=sum(carat))

diamonds %>% 
  group_by(cut, color) %>%
  summarize(AvgPrice=mean(price), SumCarat=sum(carat))


### 1.9 - Arrange ###

# arrange() function can be used for sorting and ordering the data
# Its use is more intuitive than the regular R order() and sort().
# e.g. suppose we want to order the group_by summary by the average price for each cut grade.
diamonds %>% 
  group_by(cut) %>%
  summarize(AvgPrice=mean(price), SumCarat=sum(carat)) %>%
  arrange(AvgPrice)

# Note that the data frame will be ordered in an ascending order by default
# We can arrange the data frame in descending order with desc()
diamonds %>% 
  group_by(cut) %>%
  summarize(AvgPrice=mean(price), SumCarat=sum(carat)) %>%
  arrange(desc(AvgPrice))

### 1.10 - Do ###

# do() is a general purpose complement to the specialized manipulation functions,
# such as filter(), select(), mutate(), summarize(), and arrange()
# We can also use do() to perform arbitrary computation, returning either a data frame or 
# arbitrary objects which will be sorted in a list.
# e.g. suppose we are interested to get the top N prices in each cut grade
# First we create a function topN to arrange the price in descending order and return N rows
topN <- function(x, N=5){
  x %>% arrange(desc(price)) %>% head(N)
}

# We then nest the do() and group_by() to identify the top prices in each cut group.
diamonds %>% group_by(cut) %>% do(topN(., N=3))

# Note that the return object from the previous comment is a data frame.
# If we define the return object name in the do(), it will return as a list for each cut grade.
diamonds %>% group_by(cut) %>% do(top = topN(., N=3))

# We can retreive the list elements if it's saved as data frame.
topByCut <- diamonds %>% group_by(cut) %>% do(top = topN(., N=3))

# The data frame has 5 rows and each rows contains a list of 3 rows data
class(topByCut)
class(topByCut$top)
class(topByCut$top[[1]])

# The first row in topByCut data frame will return the cut grade "Fair" prices
topByCut$top[[1]]


### 1.11 - Applying dplyr with Database ###

# dplyr can also be use to process the data in the traditional database structure.
# The process is similar to the data.frame operations.
# dplyr can be applied in PostgreSQL, MySQL, SQLite, MonetDB, Google Big Query, and Spark DataFrames
# Note: The processing speed from database will be slower than processing in a data.frame 
# because some of the computation needs to be process after the data is being saved into the memories.

# We first download the diamonds database in SQLite format 
download.file("http://www.jaredlander.com/data/diamonds.db",
              destfile="SQLite/diamonds.db",
              mode='wb')

# First, we need to build the connection with the database
# install.packages("RSQLite")
library("RSQLite")
diaDBSource <- src_sqlite("SQLite/diamonds.db")
diaDBSource

# For dplyr 0.6.0 version, we can also use DBI to build the connect to the database
diaDBSource2 <- DBI::dbConnet(RSQLite::SQLite(), "SQLite/diamonds.db")
diaDBSource2

# Inside the database, there are 3 taps, 'diamonds', 'DiamondColors', and 'sqlite_stat1'
# For each tap, we need to appoint to that specific tap name at a time
diaTab <- tbl(diaDBSource, 'diamonds')
diaTab

# Note: It looks like a data.frame, but it is actually the database table
# Majority of the calcuation of this tbl is done within the database

# Once we build the connection to the database, we can write our quries using the pipe operator
diaTab %>% group_by(cut) %>% dplyr::summarize(Price=mean(price))

diaTab %>% 
  group_by(cut) %>%
  dplyr::summarize(Price=mean(price), Carat=mean(Carat))
