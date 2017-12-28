## Regularized Regression

library(ElemStatLearn)
data(prostate)
str(prostate)

# issue for high dimensional data
small = prostate[1:5,]

lm(lpsa~., data = small) # some wont be predicted, more predictors than samples

## Combining Predictors

library(ISLR)
data(Wage)
library(ggplot2)
library(caret)
Wage <- subset(Wage, select=-c(logwage))

# create a building data set and validation set
inBuild <- createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
validation <- Wage[-inBuild,]
buildData <- Wage[inBuild,]

inTrain <- createDataPartition(y = buildData$wage, p = 0.7, list = FALSE)
training <- buildData[inTrain,]
testing <- buildData[-inTrain,]

dim(training)
dim(testing)
dim(validation)

# build two different models
mod1 <- train(wage ~., method = "glm", data = training)
mod2 <- train(wage ~., method = "rf", data = training, trControl = trainControl(method = "cv"), number = 3)

pred1 <- predict(mod1, testing)
pred2 <- predict(mod2, testing)

qplot(pred1, pred2, colour = wage, data = testing)

predDF <- data.frame(pred1, pred2, wage = testing$wage)
combModFit <- train(wage~., method = "gam", data = predDF) # model related the wage variable to the two predictions
combPred <- predict(combModFit, predDF)

# Testing errors

sqrt(sum((pred1 - testing$wage)^2)) # first predictor error
sqrt(sum((pred2 - testing$wage)^2))
sqrt(sum((combPred - testing$wage)^2)) # combined predictor error

# Predict on validation set

pred1V <- predict(mod1, validation)
pred2V <- predict(mod2, validation)
predVDF <- data.frame(pred1 = pred1V, pred2 = pred2V)
combPredV <- predict(combModFit, predVDF)

sqrt(sum((pred1V - validation$wage)^2)) # first predictor error
sqrt(sum((pred2V - validation$wage)^2))
sqrt(sum((combPredV - validation$wage)^2)) # combined predictor error
