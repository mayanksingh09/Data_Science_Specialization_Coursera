library(kernlab)
data(spam)
str(spam[,1:5])

## perform the subsampling
set.seed(3435)
trainIndicator = rbinom(4601, size = 1, prob = 0.5)
table(trainIndicator)

trainSpam <- spam[trainIndicator == 1, ]
testSpam <- spam[trainIndicator == 0, ]

# EDA

names(trainSpam) #words
head(trainSpam) #frequencies of words within emails

table(trainSpam$type)

plot(trainSpam$capitalAve ~ trainSpam$type) #data highly skewed
plot(log10(trainSpam$capitalAve+1) ~ trainSpam$type) #remove skew

plot(log10(trainSpam[,1:4] + 1)) #pairwise plots

## clustering

hcluster <- hclust(dist(t(trainSpam[,1:57])))
plot(hcluster)

hclusterUpdated <- hclust(dist(t(log10(trainSpam[,1:55] + 1))))
plot(hclusterUpdated) #log transformation cluster


# STATISTICAL PREDICTION
trainSpam$numType <- as.numeric(trainSpam$type) - 1
costFunction <- function(x,y) sum(x != (y > 0.5))

cvError <- rep(NA, 55)
library(boot)
for (i in 1:55){
  lmFormula = reformulate(names(trainSpam)[i], response = "numType")
  glmFit = glm(lmFormula, family = "binomial", data = trainSpam)
  cvError[i] = cv.glm(trainSpam, glmFit, costFunction, 2)$delta[2]
}

## predictor with minimum cv error

names(trainSpam)[which.min(cvError)]

## Use the best model from the group
predictionModel <- glm(numType ~ charDollar, family = "binomial", data = trainSpam)

## Get predictions on the test set
predictionTest <- predict(predictionModel, testSpam)
predictedSpam <- rep("nonspam", dim(testSpam)[1])

## Classify as 'spam' for those with prob > 0.5
predictedSpam[predictionModel$fitted.values > 0.5] = "spam"

## Confusion matrix
table(predictedSpam, testSpam$type)

## Error rate
(table(predictedSpam, testSpam$type)[2,1] + table(predictedSpam, testSpam$type)[1,2])/sum(table(predictedSpam, testSpam$type))

