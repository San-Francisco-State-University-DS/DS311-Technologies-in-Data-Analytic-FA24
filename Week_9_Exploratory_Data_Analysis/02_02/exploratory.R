# import csv file 
myExploratoryData <- read.csv("~/Desktop/Exercise_Files/02_02/exploratory-r.csv") 

# get a quick snapshot of your data
head(myExploratoryData)

hist(myExploratoryData$cpa)

# shift the names to each row
row.names(myExploratoryData) <- myExploratoryData$keyword

# review that transformation 
head(myExploratoryData)
 
# transform into a matrix 
myDataMatrix <- data.matrix(myExploratoryData)

# generate our heatmap
heatmap(myDataMatrix, Rowv=NA, Colv=NA, scale="column")
