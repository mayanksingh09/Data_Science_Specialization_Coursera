# HIERARCHICAL CLUSTERING

set.seed(1234)
par(mar = c(0,0,0,0))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1,2,1), each = 4), sd = 0.2)
plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

dataFrame <- data.frame(x = x, y = y)
dist(dataFrame) # distance b/w all the different rows in the df (default eucleadian dist)

## hclust fn

distxy <- dist(dataFrame)
hClustering <- hclust(distxy)
plot(hClustering) #plot the dendrogram

###### Custom Plot

myplclust <- function( hclust, lab=hclust$labels, lab.col=rep(1,length(hclust$labels)), hang=0.1,...){
  ## modifiction of plclust for plotting hclust objects *in colour*!
  ## Copyright Eva KF Chan 2009
  ## Arguments:
  ##    hclust:    hclust object
  ##    lab:        a character vector of labels of the leaves of the tree
  ##    lab.col:    colour for the labels; NA=default device foreground colour
  ##    hang:     as in hclust & plclust
  ## Side effect:
  ##    A display of hierarchical cluster with coloured leaf labels.
  y <- rep(hclust$height,2)
  x <- as.numeric(hclust$merge)
  y <- y[which(x<0)]
  x <- x[which(x<0)]
  x <- abs(x)
  y <- y[order(x)]
  x <- x[order(x)]
  plot( hclust, labels=FALSE, hang=hang, ... )
  text( x=x, y=y[hclust$order]-(max(hclust$height)*hang), labels=lab[hclust$order], col=lab.col[hclust$order], srt=90, adj=c(1,0.5), xpd=NA, ... )}

######

myplclust(hClustering, lab = rep(1:3, each = 4), lab.col = rep(1:3, each = 4))

## merging approaches 

### 1. Average Linkage
### 2. Complee Linkage

## Heatmap fn

set.seed(143)
dataMatrix <- as.matrix(dataFrame)[sample(1:12),]
heatmap(dataMatrix) ## runs hierarchical cluster analysis on the rows and columns of the table
## visualize groups and blocks of table (so within the table how the groups are represented)



# K-Means Clustering
set.seed(1234)
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1,2,1), each = 4), sd = 0.2)
plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

### find random starting points for centroids
### find closest points to the centroids
### re-calculate centroid
### repeat

kmeansObj <- kmeans(dataFrame, centers = 3)
names(kmeansObj)

kmeansObj$cluster #vector of cluster numbers

plot(x, y, col = kmeansObj$cluster, pch = 19, cex = 2)
points(kmeansObj$centers, col = 1:3, pch = 3, cex = 3, lwd = 3)


## Heatmaps

set.seed(1234)
dataMatrix <- as.matrix(dataFrame)[sample(1:12),]
kmeansObj2 <- kmeans(dataMatrix, centers = 3)
par(mfrow = c(1,2), mar = c(2,4,0.1,0.1))
image(t(dataMatrix)[,nrow(dataMatrix):1], yaxt = "n") #image of original data
image(t(dataMatrix)[,order(kmeansObj$cluster)], yaxt = "n") #clusters together



# Principal Component Analysis and Singular Value Decomposition

## can be used in exploratory data analysis and the modeling phase both

set.seed(12345)
#par(mar = rep(0.2, 4))
dataMatrix <- matrix(rnorm(400), nrow = 40)
image(1:10, 1:40, t(dataMatrix)[,nrow(dataMatrix):1])

par(mar = rep(0.2,4))
heatmap(dataMatrix)

set.seed(678910)
for (i in 1:40){
  #flip a coin
  coinFlip <- rbinom(1, size = 1, prob = 0.5)
  # if heads add a common pattern to that row
  if (coinFlip){
    dataMatrix[i,] <- dataMatrix[i, ] + rep(c(0,3), each = 5)
  }
}

#par(mar = rep(0.2,4))
image(1:10, 1:40, t(dataMatrix)[,nrow(dataMatrix):1]) ## rhs more yellow (higher values)

heatmap(dataMatrix) ## two sets of columns easily split, no real pattern along rows

## patterns in rows and columns

#### look at marginal means of rows and column

hh <- hclust(dist(dataMatrix))
dataMatrixOrdered <- dataMatrix[hh$order, ]
par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(rowMeans(dataMatrixOrdered), 40:1, xlab = "Row Mean", ylab = "Row", pch = 19) #plotting row means
plot(colMeans(dataMatrixOrdered), xlab = "Column", ylab = "Column Mean", pch = 19) #plotting column means

## 

# Singular Value Decomposition

svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(svd1$u[,1], 40:1, xlab = "Row", ylab = "First left singular vector", pch = 19) 
plot(svd1$v[,1], xlab = "Column", ylab = "First right singular vector", pch = 19)
### Picked up the shift in mean in the row and column dimension

### svd picks up a pattern

## Component of SVD - Variance explained
### Comes from the D matrix

par(mfrow = c(1,2))
plot(svd1$d, xlab = "Column", ylab = "Singular value", pch = 19)
plot(svd1$d^2/sum(svd1$d^2), xlab = "Column", ylab = "Prop. of variance explained", pch = 19) # proportion of variance explained

## Relationship to principal components
svd1 <- svd(scale(dataMatrixOrdered))
pca1 <- prcomp(dataMatrixOrdered, scale = TRUE)
plot(pca1$rotation[,1], svd1$v[,1], pch = 19, xlab = "Principal Component 1", ylab = "Right Singular Vector 1")
abline(c(0,1))


constantMatrix <- dataMatrixOrdered*0
for(i in 1:dim(dataMatrixOrdered)[1]){constantMatrix[i,] <- rep(c(0,1), each = 5)}
svd1 <- svd(constantMatrix)
par(mfrow = c(1,3))
image(t(constantMatrix)[,nrow(constantMatrix):1])
plot(svd1$d, xlab = "Column", ylab = "Singular value", pch = 19)
plot(svd1$d^2/sum(svd1$d^2), xlab = "Column", ylab = "Prop. of variance explained", pch = 19) # first singular value explains 100% of the variation in the dataset

### add a new pattern

set.seed(678910)
for (i in 1:40){
  # flip a coin
  coinFlip1 <- rbinom(1, size = 1, prob = 0.5)
  coinFlip2 <- rbinom(1, size = 1, prob = 0.5)
  # if coin is heads add a common pattern to that row
  if (coinFlip1){
    dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,5), each = 5)
  }
  if (coinFlip2){
    dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,5), 5)
  }
}

hh <- hclust(dist(dataMatrix))
dataMatrixOrdered <- dataMatrix[hh$order, ]

## SVD true patterns
svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(rep(c(0,1), each = 5), pch = 19, xlab = "Column", ylab = "Pattern 1")
plot(rep(c(0,1),5), pch = 19, xlab = "Column", ylab = "Pattern 2")


## SVD on new matrix with 2 patterns (v and patterns of variance in rows)
svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(svd2$v[,1], pch = 19, xlab = "Column", ylab = "First right singular vector")
plot(svd2$v[,2], pch = 19, xlab = "Column", ylab = "Second right singular vector") ## 1st and 2nd singular vectors also known as principal components


## d and variance explained
svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow = c(1,2))
plot(svd1$d, xlab = "Column", ylab = "Singular value", pch = 19)
plot(svd1$d^2/sum(svd1$d^2), xlab = "Column", ylab = "Percent of variance explained", pch = 19)


## error with SVD and PCA on missing value data

## Missing values

dataMatrix2 <- dataMatrixOrdered
## Randomly insert missing values
dataMatrix2[sample(1:100, size = 40, replace = FALSE)] <- NA
svd1 <- svd(scale(dataMatrix2)) #won't work

## Can impute missing values


## Face data
load("data/face.rda")
image(t(faceData)[,nrow(faceData):1])

svd1 <- svd(scale(faceData))
plot(svd1$d^2/sum(svd1$d^2), pch = 19, xlab = "Singular vector", ylab = "Variance explained")

svd1 <- svd(scale(faceData))
## %*% is matrix multiplication

# svd1$d[1] is a constant
approx1 <- svd1$u[,1] %*% t(svd1$v[,1]) * svd1$d[1]

# make a diagonal matrix out of d
approx5 <- svd1$u[,1:5] %*% diag(svd1$d[1:5]) %*% t(svd1$v[,1:5])
approx10 <- svd1$u[,1:10] %*% diag(svd1$d[1:10]) %*% t(svd1$v[,1:10])

par(mfrow = c(1,4))
image(t(approx1)[, nrow(approx1):1], main = "(a)") # 1st singular vector
image(t(approx5)[, nrow(approx5):1], main = "(b)") # first 5 singular vector
image(t(approx10)[, nrow(approx10):1], main = "(c)") # first 10 singular vector
image(t(faceData)[, nrow(faceData):1], main = "(d)") # original data


# Plotting and Color in R
library(grDevices)

pal <- colorRamp(c("red","blue"))
pal(0.75) #colors b/w red and blue
pal(seq(0,1, len = 10))


pal <- colorRampPalette(c("red","blue"))
pal(2) #returns 2 colors
pal(10) # returns 10 colors b/w red and blue

library(RColorBrewer)

cols <- brewer.pal(3, "BuGn")
cols
pal <- colorRampPalette(cols)
image(volcano, col = pal(20))

### can also be used with scatter plot

x <- rnorm(10000)
y <- rnorm(10000)

smoothScatter(x,y) #creates a histogram higher density = darker, lower density = lighter

plot(x,y, col = rgb(0,0,0, 0.2), pch = 19)

## swirl lessons

scale(matrix) #subtract col mean from each element of matrix and divide the result by the column standard deviation
