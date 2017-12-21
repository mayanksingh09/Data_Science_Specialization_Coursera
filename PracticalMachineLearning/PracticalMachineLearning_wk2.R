## Week 2

library(caret)
library(kernlab)

data(spam)
inTrain <- createDataPartition(y = spam$type, p = 0.75, list = FALSE)

training <- spam[inTrain,]
testing <- spam[-inTrain,]
dim(testing)

set.seed(123)
modelFit <- train(type~., data = training, method = "glm")
modelFit

#Final model
modelFit$finalModel

#Prediction

predictions <- predict(modelFit, newdata = testing)
predictions

# Confusion Matrix
confusionMatrix(predictions, testing$type)


## DATA SLICING

# Cross validation K-fold

set.seed(123)
folds <- createFolds(y = spam$type, k = 10, list = TRUE, returnTrain = TRUE)

sapply(folds, length)

## Return test set

folds <- createFolds(y = spam$type, k = 10, list = TRUE, returnTrain = FALSE)
sapply(folds, length)


# RESAMPLING

set.seed(123)
folds <- createResample(y = spam$type, times = 10, list = TRUE)
sapply(folds, length)

# Time Slices 

set.seed(123)
tme <- 1:1000
folds <- createTimeSlices(y = tme, initialWindow = 20, horizon = 10)
names(folds)

folds$train[[1]]


## Training Options

#args(train)

args(trainControl)

## Plotting Predictors
library(ISLR)
library(ggplot2)

data(Wage)
summary(Wage)

inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)

training <- Wage[inTrain,]
testing <- Wage[-inTrain,]

dim(training) ; dim(testing)

featurePlot(x = training[,c("age", "education", "jobclass")], y = training$wage, plot = "pairs") #all variables plotted against each other

qplot(age, wage, color = jobclass, data = training) #plotting age v/s age 


## making factors (creating bins)
library(Hmisc)

cutWage <- cut2(training$wage, g = 3)
table(cutWage)

p1 <- qplot(cutWage, age, data = training, fill = cutWage, geom = c("boxplot"))
p2 <- qplot(cutWage, age, data = training, fill = cutWage, geom = c("boxplot", "jitter"))

gridExtra::grid.arrange(p1, p2, ncol = 2)


table(cutWage, training$jobclass) #table comparing the wage groups v/s job classes

prop.table(t1, 1) # proportion, 1 -> proportion in each row

# density plots
qplot(wage, color = education, data = training, geom = "density") # by education



## PREPROCESSING (predictor variables) ##


data(spam)
set.seed(123)
inTrain <- createDataPartition(y = spam$type, p = 0.7, list = FALSE)

training <- spam[inTrain,]
testing <- spam[-inTrain,]

hist(training$capitalAve, main = "", xtab = "ave. capital run length") #variable very skewed (hard to deal with in Model based predictors)

mean(training$capitalAve)

sd(training$capitalAve) #very high standard deviation

# standardize the variable (subtract mean, divide by sd)

training$capitalAveS <- (training$capitalAve - mean(training$capitalAve))/sd(training$capitalAve)

mean(training$capitalAveS) #almost 0
sd(training$capitalAveS) #almost 1

# use mean & sd from training to standardize the testing set values

testing$capitalAveS <- (testing$capitalAve - mean(training$capitalAve))/sd(training$capitalAve)

mean(testing$capitalAveS) #not exactly 0
sd(testing$capitalAveS) #not exactly 1

## Using preprocessing fn from caret

preObj <- preProcess(training[,-58], method = c("center", "scale")) #same transformation to all the variables in the data

trainCapAveS <- predict(preObj, training[,-58])$capitalAve #same as capitalAveS for training set

testCapAveS <- predict(preObj, testing[,-58])$capitalAve #same as capitalAveS for testing set


# can pass pre process as an argument to train command
modelFit <- train(type~., data = training, preProcess = c("center", "scale"), method = "glm")


# Can also do other transformations

## Box-Cox transformation - turns continuous data into normal data
## Continuous transform, doesn't take care of values that are repeated

preObj <- preProcess(training[,-58], method = c("BoxCox"))
trainCapAveS <- predict(preObj, training[,-58])$capitalAve
par(mfrow = c(1,2))
hist(trainCapAveS)
qqnorm(trainCapAveS)

## Imputing data

set.seed(123)
training$capAve <- training$capitalAve
selectNA <- rbinom(dim(training)[1], size = 1, prob = 0.05)==1
training$capAve[selectNA] <- NA

# Impute and Standardize
preObj <- preProcess(training[,-58], method = "knnImpute")
capAve <- predict(preObj, training[,-58])$capAve

# Standardize true values
capAveTruth <- training$capitalAve
capAveTruth <- (capAveTruth - mean(capAveTruth))/sd(capAveTruth)

quantile((capAve - capAveTruth)[selectNA]) #comparing values that were missing


## COVARIATE CREATION ##

# Covariates = Features = Predictors
# 2 levels: 1. Raw data -> Covariate, 2. Transforming tidy covariates

library(kernlab)
data(spam)

spam$capitalAveSq <- spam$capitalAve^2 #level2

# Level 2: Transforming covariates
# Only on training data set
# best approach through EDA

library(ISLR)
library(caret)

data(Wage)
inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]

table(training$jobclass) # categorical covariate to dummy variables

# create dummy variables
dummies <- dummyVars(wage ~ jobclass, data = training)
head(predict(dummies, newdata = training)) # 1-0 new columns for each class

# removing zero covariates, with very little variability and won't be good predictors

nsv <- nearZeroVar(training, saveMetrics = TRUE)
nsv # the metrics, region is zero variability

# fit curvy lines to the data

library(splines)

# create a polynomial variable
bsBasis <- bs(training$age, df = 3) # 3rd degree polynomial
bsBasis # 1st col - scaled age, 2nd - squared scaled age, 3rd - cubed scaled age

# linear model
lm1 <- lm(wage ~ bsBasis, data = training)
plot(training$age, training$wage, pch = 19, cex =0.5)
points(training$age, predict(lm1, newdata = training), col = "red", pch = 19, cex = 0.5)

# on the test set we will have to predict those new variables we created
predict(bsBasis, age = testing$age) # values predicted from the original training data fn


### PREPROCESSING WITH PRINCIPAL COMPONENT ANALYSIS ###

