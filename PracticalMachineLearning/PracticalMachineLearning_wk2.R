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
