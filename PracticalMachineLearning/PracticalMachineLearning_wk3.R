# TREES

data(iris)
library(ggplot2)
names(iris)

table(iris$Species)

inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]
dim(training)
dim(testing)

qplot(Petal.Width, Sepal.Width, colour = Species, data = training)
library(caret)

modFit <- train(Species ~., method = "rpart", data = training)
print(modFit$finalModel)
modFit2 <- rpart(Species~., data = training)

plot(modFit$finalModel, uniform = TRUE, main = "Classification Tree")
text(modFit$finalModel, use.n = TRUE, all = TRUE, cex = 0.8)

library(rpart.plot)
rpart.plot(modFit2)


# BAGGING

library(ElemStatLearn)
data(ozone, package = "ElemStatLearn")
ozone <- ozone[order(ozone$ozone),]
head(ozone)

ll <- matrix(NA, nrow = 10, ncol = 155) #matrix created
for (i in 1:10){ # resample data set 10 times
    ss <- sample(1:dim(ozone)[1], replace = T) # sample with replacement
    ozone0 <- ozone[ss,]; ozone0 <- ozone0[order(ozone0$ozone),] # resampled data set for that element of the loop, reorder by ozone
    loess0 <- loess(temperature ~ ozone, data = ozone0, span = 0.2) # fit loess curve relating temp and ozone and use resampled data set each time
    ll[i,] <- predict(loess0, newdata = data.frame(ozone = 1:155)) # predict outcome for new dataset
}

plot(ozone$ozone, ozone$temperature, pch = 19, cex = 0.5)
for (i in 1:10){lines(1:155, ll[i,], col = "grey", lwd = 2)} # grey line capture the variability with each loop in data set
lines(1:155, apply(ll, 2, mean), col = "red", lwd = 2) # plot with average values

# building own bagging fn
# predictors = data.frame(ozone = ozone$ozone)
# temperature = ozone$temperature
# treebag <- bag(predictors, temperature, B = 10,
#                bagControl = bagControl(fit = ctreeBag$fit,
#                                        predict = ctreeBag$pred,
#                                        aggregate = ctreeBag$aggregate))


# RANDOM FORESTS
data(iris)
library(ggplot2)
inTrain <- createDataPartition(y = iris$Species,
                               p = 0.7,
                               list = FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]

library(randomForest)
library(caret)
modFit <- train(Species~. , data = training, method = "rf", prox = TRUE)
modFit

getTree(modFit$finalModel, k = 2)

irisP <- classCenter(training[,c(3,4)], training$Species, modFit$finalModel$prox)
irisP <- as.data.frame(irisP)
irisP$Species <- rownames(irisP)
p <- qplot(Petal.Width, Petal.Length, col = Species, data = training)
p + geom_point(aes(x = Petal.Width, y = Petal.Length, col = Species), size = 5, shape = 4, data = irisP)

pred <- predict(modFit, testing)
testing$predRight <- pred == testing$Species
table(pred, testing$Species)

qplot(Petal.Width, Petal.Length, colour = predRight, data = testing, main = "newData Predictions")


# BOOSTING

library(ISLR)
data(Wage)
library(ggplot2)
library(caret)
library(gbm)
Wage <- subset(Wage, select = -c(logwage))
inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]

modFit <- train(wage ~. , method = "gbm", data = training, verbose = FALSE)
print(modFit)
qplot(predict(modFit, testing), wage, data = testing)


# MODEL BASED PREDICTION

data(iris)
library(ggplot2)
names(iris)
library(caret)

table(iris$Species)

inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]

dim(training)
dim(testing)

modlda <- train(Species ~., data = training, method = "lda")
modnb <- train(Species ~., data = training, method = "nb")

plda <- predict(modlda, testing)
pnb <- predict(modnb, testing)

table(plda, pnb)

# compare results
equalPredictions <- (plda==pnb)
qplot(Petal.Width, Sepal.Width, colour = equalPredictions, data = testing)
