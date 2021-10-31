######################################
######   Visualization with R   ######
######################################

### 4.1 - Base R Graphic Tools ###

# Most people use the base R built-in graphic tools as the starting point for data visualization, 
# which base R alreayd provides a great set of graphic tools. Here we are going to demonstrate
# the use of these graphic tools and later compare it to the more sophisticated ggplot2 package.

# In this demonstration, we are using the 'diamonds' data set from ggplot2 package
library(ggplot2)
data(diamonds)
head(diamonds)

# Basic Histogram in base R
# Histogram is the most fundamental graphic tools to show the frequency distribution of the numerical data.
# Base R provides this very easy way to plot the histogram with hist() function.
# e.g. Suppose we are plotting the histrogram for the numerical column "carat" from the diamonds tbl.
hist(diamonds$carat, main='Carat Histogram', xlab='Carat')

# Scatter Plot in base R
# Scatter plot is a very useful tool to compare two sets of numerical data.
# e.g. We can use "formula" to plot the diamond price against carat.
plot(price ~ carat, data=diamonds)

# Note: In the formula, price is the y value and carat is the x value.

# It is not necessary to use "formula" for a scatter plot,
plot(diamonds$carat, diamonds$price)

# Note: the first argument in the plot() function is the x value and the second argument is the y value.

# Box Plot in base R
# Bos plot is probably the first graphical tool learned in fundermental statistic class.
# It is used to depict the range, mean, median, and quartiles of the numerical data.
# e.g. We can use the boxplot() function to depict the numerical data 'carat'
boxplot(diamonds$carat)


### 4.2 - ggplot2 Package ###

# Base R already provides a powerful graphic tools for the average R users.
# However, when we want to modify some specific features in the graph, the base R graphic tools requires more lines of code.
# ggplot2 package offers a structure of coding for achieving the complex modification of graphic features.
# In some cases, adding some additional features to a graph may take 30 additional lines of code to run in base R, but may only 
# require 1 line of code using ggplot2 package.

# We start with taking the data as the first argument in ggplot() function and build on top of it with "+"
# Think of "+" is like adding an additional layer to the plot for different feature added. 
# The most important thing to add into the new layer is aes(), represents "aesthetic" adjustment.

# Histogram with ggplot2
# e.g. Using ggplot2 for plotting the histogram for numerical data 'Carat' in the diamonds data set.
ggplot(data=diamonds) + geom_histogram(aes(x=carat))

# Similar to histrogram, we can easily plot the density distribution with geom_density().
ggplot(data=diamonds) + geom_density(aes(x=carat), fill='grey50')

# Note: Histogram divide the continuous variable into groups (x-axis) and gives the frequency (y-axis) in each group.
# Density distribution is evaluated at any given point on the continuous variable (x-axis)


# Scatter Plot with ggplot2
# In this section, we are not only demonstrate how to use scatter plot with ggplot2 package, we also try to demonstrate
# the simplicity for adding some useful features to our graph.
# e.g. Plot the diamond price and carat within a scatter plot
# This time we are including the aes() in the ggplot() function, but not in the geom()
ggplot(diamonds, aes(x=carat, y=price)) + geom_point()

# We are going to repeat using "ggplot(diamonds, aes(x=carat, y=price))", so we save it into a variable "g".
g <- ggplot(diamonds, aes(x=carat, y=price))

# Suppose we would like to identify the colors of the diamond in the graph with different color codes.
g + geom_point(aes(color=color))

# Note: The argument color= is to define what color to use for the data points in the graph and we
# define the color will be different according to the value under column "color" in the data set.

# ggplot2 can also create layers of plot with functions like facet_wrap() or facet_grid()

# For instance, if we are interested to split each color grade into its own price vs. carat scatter plot.
g + geom_point(aes(color=color)) + facet_wrap(~color)

# Or, if we want to splite the scatter plots into different combinations of "cut" and "clarity" grade.
g + geom_point(aes(color=color)) + facet_grid(cut~clarity)

# Note: Both facet_wrap() and facet_grid() can be applied to any geom() functions.
# e.g. We can use facet_wrap() to plot the histrogram for carat in different color grade.
ggplot(diamonds, aes(x=carat)) + geom_histogram() + facet_wrap(~color)


# Box Plot with ggplot2
# ggplot2 provides a more complete and intuitive features to the box plot graphic
# e.g. Plotting the box plot for carat
ggplot(diamonds, aes(y=carat, x=1)) + geom_boxplot()

# Note: Unlike the base R boxplot(), ggplot2 require to define the x-axis even for a one dimensional plot.
# therefore, we put in the value 1 for x.

# In ggplot2, we can easily extend the boxplot into different classes by defining a categorical data
# e.g. we can divide the box plot for carat by the cut grade
ggplot(diamonds, aes(y=carat, x=cut)) + geom_boxplot()

# In a more specific case, we can change the box plot into a violin plot
ggplot(diamonds, aes(y=carat, x=cut)) + geom_violin()


# Line Graph with ggplot2
# Line graph is usually applied to express the time series data.
# We are using the economics data set from ggplot2 package to demonstrate the use of line graph with date.
# e.g. Plot the population data with the given date.
ggplot(economics, aes(x=date, y=pop)) + geom_line()

# Suppose we are trying to break the data into year and plot into the same graph.
# We can use the lubridate package to help us on this task.
library(lubridate)

# Build year and month variables
economics$year <- year(economics$date)
# The argument label=TRUE means to return month by its name, not a numeric value
economics$month <- month(economics$date, label=TRUE)
# Let's save the data in or beyond 2000 to an object "econ2000"
econ2000 <- economics[which(economics$year >= 2000),]
# We can use scales package to give better format to the graph
library(scales)
# Build the base of the line graph
g <- ggplot(econ2000, aes(x=month, y=pop))
# Define different colors for different years.
# Use argument group to group the data into different year.
g <- g +geom_line(aes(color=factor(year), group=year))
# Define the color by the given "Year"
g <- g + scale_color_discrete(name="Year")
# Format the y-axis
g <- g + scale_y_continuous(labels=comma)
# Adding the title, x-axis, and y-axis to the graph
g <- g + labs(title="Population Growth", x="Month", y="Population")
# Plot the graph with all the added features
g


# Themes in ggplot2
# Another big advantage using ggplot2 is that the package provides users variety of theme options.
# e.g. "The Economist", "Excel", "Edward Tufte", and "The Wall Street Journal"
# To access the themes, we need to load the ggthemes library package.
install.packages("ggthemes")
library(ggthemes)

# e.g. Applying differen themes on a scatter plot.
g2 <- ggplot(diamonds, aes(x=carat, y=price)) +
  geom_point(aes(color=color))

g2 + theme_economist() + scale_color_economist()
g2 + theme_excel() + scale_color_excel()
g2 + theme_tufte()
g2 + theme_wsj()


### 4.3 - lattice Package ###

# The lattice package, written by Deepayan Sarkar, attempts to improve on base R graphics
# by providing better defaults and the ability to easily display multivariate relationships.
library(lattice)

# Histogram with lattice
# e.g. histogram for carat in the diamonds data set
histogram(~ diamonds$carat,
          type="count",
          main="Histogram",
          xlab="Carat")

# Note: The default argument for type is "percent", which return the percentage of the total count.


# Scatter Plot with lattice
# e.g. scatter plot for diamond price and carat grade
xyplot(price~carat,
       data=diamonds,
       main="Scatterplots by Price and Carat",
       xlab="Carat",
       ylab="Price")


# Box Plot with lattice
bwplot(diamonds$carat,
       main="Boxplot for Carat",
       ylab="Carat")

# Note: lattice package displays a boxplot with one demensional data horizontally by default

# Suppose we are interested to the boxplot for carat in different cut grade
bwplot(carat~cut,
       data=diamonds,
       main="Boxplot for Carat by Cut",
       xlab="Cut",
       ylab='Carat')

# We can also generate the violin plot like in ggplot2 package by the argument panel=panel.violin.
bwplot(carat~cut,
       data=diamonds,
       main="Boxplot for Carat by Cut",
       xlab="Cut",
       ylab='Carat',
       panel=panel.violin)
