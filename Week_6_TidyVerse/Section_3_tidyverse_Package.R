#########################
######  Tidyverse  ######
#########################

### 3.1 - Combine Rows and Columns ###

# Similar to base R rbind() and cbind(), dplyr has the similar functions bind_rows() and bind_cols().
# The two are not exactly the same, which dplyr functions only apply to data.frame or tibble.
# Base R functions can be more genearlly applied to combine vectors into matrices or data.frame.
# Import dplyr package
library(dplyr)
library(tibble)

# Create a tibble with two columns
sportLeague <- tibble(sport=c("Hockey", "Baseball", "Foodball", "Basketball"),
                      league=c("NHL", "MLB", "NFL", "NBA"))

# Create a tibble with one column
trophy <- tibble(trophy=c("Stanley Cup", "Commissioner's Trophy",
                          "Vince Lombardi Trophy", "Larry O'Brien Trophy"))

# Combine the two tibbles into one
trophies1 <- bind_cols(sportLeague, trophy)

# Use tribble create anotehr tibble 
trophies2 <- tribble(
  ~sport, ~league, ~trophy,
  "Golf", "PGA", "Wanamaker Trophy",
  "Tennis", "Wimbledon", "Wimbledon Trophy" 
)

# Combine the trophies1 with trophies2 (adding new row)
trophies <- bind_rows(trophies1, trophies2)

trophies

# bind_cols and bind_rows can be used to combine multiple tibble or data.frame


### 3.2 - Join ###

# Joining table or data.frame is very important first step in data manipulation.
# In base R, we can use plyr or data.table to join two tables or data.frames.
# With dplyr package, we can use left_join(), right_join(), inner_join(), full_join(),
# semi_join(), and anti_join() for different join settings.
# We are using "diamonds" data set to demonstrate the use of join functions in dplyr.

library(readr)
colorsURL <- 'http://www.jaredlander.com/data/DiamondColors.csv'
diamondColors <- read_csv(colorsURL)
diamondColors

data(diamonds, package='ggplot2')
unique(diamonds$color)
class(diamonds)

library(dplyr)

# Using left_join() with column 'color' in diamonds and 'Color' in diamondColors.
# Note that we are defining "diamonds" as the left tbl and "diamondColors" as the right tbl.
# We are joining the two tbls with different column names "color" from left and "Color" from right.
# When using argument "by", a vector of equality of the string for left table column name and right table column name.
left_join(diamonds, diamondColors, by=c('color'='Color'))

# Note: Since the data type of the two joined columns are different ('color' is factor and 'Color' is character),
# after joining the two tbls, an warning message stated the column will be forced to be "character".

# If we only want to extract some specific columns, we can also use the pipe operator
# e.g. only select carat, color, price, description, and details columns after join
left_join(diamonds, diamondColors, by=c('color'='Color')) %>%
  select(carat, color, price, Description, Details)

# Note: A left join will keep all fo the left tbl rows and match the rows from the right tbl.
# If a value in the right tbl cannot be found in the left tbl, it will be dropped.
# As observed, the joined tbl "Color" and "Description" distinct count is less than the "diamondColors" tbl.

# Before Join:
diamondColors %>% distinct(Color, Description)  # total 10 colors in the original tbl

# After Join:
left_join(diamonds, diamondColors, by=c('color'='Color')) %>%
  distinct(color, Details)  # only 7 colors were matched to the left tbl


# Using a right_join() function, we are keeping all of the existing rows from the right tbl 
# and match with the rows in the left tbl.
# In right join case, the joined tbl contains more rows than the left tbl (diamonds).
# Before Join:
diamonds %>% nrow

# After Join:
right_join(diamonds, diamondColors, by=c('color'='Color')) %>%
  nrow

# inner_join() returns a joined tbl with all the matches from the left and right tbls.
inner_join(diamonds, diamondColors, by=c('color'='Color'))

# In this example, the inner_join() should return the same rows as the left_join() because 
# the right tbl has some rows that cannot be match with the left tbl.
all.equal(left_join(diamonds, diamondColors, by=c('color'='Color')),
          inner_join(diamonds, diamondColors, by=c('color'='Color')))

# full_join() (usually called "Outter Join") will joined tbl with with all the rows from the two tbls,
# even without match.
full_join(diamonds, diamondColors, by=c('color'='Color'))

# In this example, the full_join() should return the same rows as the right_join() because
# the right tbl has 7 rows that cannot be match to the left tbl and will be included.
all.equal(right_join(diamonds, diamondColors, by=c('color'='Color')),
          full_join(diamonds, diamondColors, by=c('color'='Color')))

# semi_join() returns only the first match from the left tbl to the right tbl, which is more like sorting.
# If we set "diamondColors" as the left tbl, only the matched colors found in "diamonds" tbl will be returned.
semi_join(diamondColors, diamonds, by=c('Color'='color'))

# anti_join() is the opposite of the semi_join(), which returns the unmatch rows from the left tbl.
# Since no color "K", "L", and "M" can be found in the 'diamonds' tbl, so anti_join() will return the three rows.
anti_join(diamondColors, diamonds, by=c('Color'='color'))

# We can also apply the filter() and unique() to achieve the semi_join() or anti_join(), but the later ones are preferred 
# when dealing with data.frame.
# semi_join() result,
diamondColors %>% filter(Color %in% unique(diamonds$color))
# anti_join() result,
diamondColors %>% filter(!Color %in% unique(diamonds$color))


### 3.3 - Transform Data Format ###

# Both base R or melt() and dcast() in reshape2 package can be used to make transformation of the wide format data
# and long format data.  tidyr package is more like a advance version of reshape2 package.
# We are using the Columbia University reaction data set for demonstration.

# We are using readr package from Tidyverse to read the text file and save it into a tibble.
library(readr)
emotion <- read_tsv('http://www.jaredlander.com/data/reaction.txt')

# Note: read_tsv() function will return a message about the data type extracted from the text file.

# Print the tibble / data.frame
emotion

# Note that the return tibble is a wide format.  We can tranform the data into a long format tibble by using gather(), 
# which is similar to melt() in reshape2 package.
# We will stack the "Age", "BMI", "React", and "Regulate" into a single column called "Measurement"
# A new column will also be created and called "Type" to identify the column names being stacked.
library(tidyr)
emotion %>% 
  gather(key=Type, value=Measurement, Age, BMI, React, Regulate)

# Note: The first argument is the "key" which is used to identify the column names in the original tbl.
# The second argument "value" is to create a column with a new name from a collections of columns in the original tbl.
# After given the name to the new column, we then identify the column names that will be stacked into the new column.

# The new tbl will be sorted by 'Type', which is the key defined in gather().
# It would be difficult to identify the changes of the data, so we can arrange it by ID.
emotionLong <- emotion %>%
  gather(key=Type, value=Measurement, Age, BMI, React, Regulate) %>%
  arrange(ID)

emotionLong

# Note: In the original data, each ID has 2 rows and each row contains Age, BMI, React, and Regulate column.
# After the transformation, each ID turns into 4 rows and each row will have a Type and measurement column.

# We can also appoint the columns to be included in the return tbl, or using "-" to excluded in the return tbl.
# e.g.
emotion %>%
  gather(key=Type, value=Measurement, -ID, -Test, -Gender) %>%
  arrange(ID)

# Check to see if they are the same.
identical(
  emotion %>%
    gather(key=Type, value=Measurement, Age, BMI, React, Regulate) %>%
    arrange(ID),
  emotion %>%
    gather(key=Type, value=Measurement, -ID, -Test, -Gender) %>%
    arrange(ID)
)

# Opposite to gather() is spread(), which is similar to dcast() in reshape2 package.
# spread() can transform the long format data into wide format data.
# In general, it can break the stacked data into columns.
# e.g. Suppose we are interested to break the emotionLong data into it's original form.
emotionLong %>%
  spread(key=Type, value=Measurement)
