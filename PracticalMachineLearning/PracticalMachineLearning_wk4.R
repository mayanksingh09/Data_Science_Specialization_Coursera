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


## FORECASTING

library(quantmod)
library(forecast)

from.dat <- as.Date("01/01/08", format = "%m/%d/%y")
to.dat <- as.Date("12/31/13", format = "%m/%d/%y")
getSymbols("GOOG", src = "google", from = from.dat, to = to.dat)
head(GOOG)

GOOG$GOOG.Volume <- 0

mGoog <- to.monthly(GOOG)
googOpen <- Op(mGoog)
ts1 <- ts(googOpen, frequency = 12)
plot(ts1, xlab = "Years+1", ylab = "GOOG")

plot(decompose(ts1), xlab = "Years+1") # decompose the trend

ts1Train <- window(ts1, start = 1, end = 5)
ts1Test <- window(ts1, start = 5)

# Simple moving average
plot(ts1Train)
lines(ma(ts1Train, order = 3), col = "red")

# Exponential smoothing
## Weights nearby time points higher than time points further away

ets1 <- ets(ts1Train, model = "MMM")
fcast <- forecast(ets1)
plot(fcast)
lines(ts1Test, col = "red")
accuracy(fcast, ts1Test)


# UNSUPERVISED PREDICTION

data(iris)
library(ggplot2)
inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = FALSE)

training <- iris[inTrain,]
testing <- iris[-inTrain,]
dim(training)
dim(testing)

## K means clustering
kMeans1 <- kmeans(subset(training, select = -c(Species)), centers = 3)
training$clusters <- as.factor(kMeans1$cluster)

qplot(Petal.Width, Petal.Length, colour = clusters, data = training)

table(kMeans1$cluster, training$Species)
modFit <- train(clusters ~., data = subset(training, select = -c(Species)), method = "rpart")
table(predict(modFit, training), training$Species)

testClusterPred <- predict(modFit, testing)
table(testClusterPred, testing$Species)

# cl_predict in clue package does the same
# recommendation engines


## Week 4 quiz

library(ElemStatLearn)
library(caret)
library(gbm)
data(vowel.train)
data(vowel.test)
set.seed(33833)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)

modgbm <- train(y~., data = vowel.train, method = "gbm", verbose = F)
modrf <- train(y~., data = vowel.train, method = "rf")
predgbm <- predict(modgbm, vowel.test)
predrf <- predict(modrf, vowel.test)

confusionMatrix(predgbm, vowel.test$y)
confusionMatrix(predrf, vowel.test$y)
