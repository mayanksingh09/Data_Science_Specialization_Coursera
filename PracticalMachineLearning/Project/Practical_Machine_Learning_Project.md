Summary
-------

The study aims to predict the manner in which exercises were carried out
in the correct manner using data from devices such as Jawbone Up, Nike
FuelBand, and Fitbit. The predictions would help measure the how in the
personal activity space.

The steps in the analysis include:

1.  Preprocessing and transforming the data used for the analysis.
2.  Exploratory analysis on the data find out relevant variables and
    patterns that may help in subsequent study.
3.  Identifying an ideal model suited to the problem based on the
    exploratory analysis.
4.  Evaluating the model to find out the best fit.
5.  Predicting outcomes on the out of sample data.

### Preprocessing

Loading the data:

    training <- read.csv("pml-training.csv")
    testing <- read.csv("pml-testing.csv")

Reading in the dimensions:

    dim(training)

    ## [1] 19622   160

    dim(testing)

    ## [1]  20 160

The model has 160 variables.

Removing variables that do not contain much information (more than 25%
rows are NAs) and variables we will not use (Time Stamp variables):

    col_to_rem <- which(colSums(is.na(training) | training == "" | training == "#DIV/0!") > 
        nrow(training) * 0.25)
    timestamp_cols <- grep("timestamp", names(training))

    training_new <- training[, -col_to_rem]
    testing_new <- testing[, -col_to_rem]

    training_new <- training_new[, -c(1, timestamp_cols)]
    training_new <- training_new[, -c(1, 2, 3)]

    testing_new <- testing_new[, -c(1, timestamp_cols)]
    testing_new <- testing_new[, -c(1, 2, 3)]

We are now left with 53 variables.

Convert all numerical variables to integers variables for appropriate
use in the subsequent process.

    classelabs <- levels(training_new$classe)
    training_new <- data.frame(data.matrix(training_new))
    training_new$classe <- factor(training_new$classe, labels = classelabs)

Splitting the data into Training and Testing set:

    library(caret)
    classe_num <- which(names(training_new) == "classe")
    inTrain <- createDataPartition(y = training_new$classe, p = 0.7, list = F)
    training_new_train <- training_new[inTrain, ]
    training_new_test <- training_new[-inTrain, ]

Exploratory Data Analysis
-------------------------

Identifying highly correlated variables

    library(caret)
    library(ggplot2)
    library(corrplot)

    cor_matrix <- cor(training_new_test[, -classe_num])
    corrplot(cor_matrix, method = "square", tl.cex = 0.7, tl.col = "black")

![](Practical_Machine_Learning_Project_files/figure-markdown_strict/eda1-1.png)
We can see some variables are highly correlated with each other.

Removing the features which are highly correlated using PCA.

    high_cor <- findCorrelation(cor_matrix, cutoff = 0.9, exact = T)
    cols_rem <- c(high_cor, classe_num)

    PCA_preprocess <- preProcess(training_new_train[, -cols_rem], method = "pca")

    training_new_train_pca <- predict(PCA_preprocess, training_new_train[-cols_rem])
    training_new_test_pca <- predict(PCA_preprocess, training_new_test[-cols_rem])

    testing_new_pca <- predict(PCA_preprocess, testing_new[, -c(classe_num, cols_rem)])

Identifying the Ideal Model
---------------------------

We will run the analysis on three data sets:

1.  The original train-test split we created with all the variables.
2.  The train-test split without the highly correlated variables
3.  The train-test split with PCA components

Then we will evaluate the results on the in-sample testing set and
choose the best model.

We will be using a *Random Forest Model* with 100 trees for this
Analysis.

    library(randomForest)
    ntrees <- 100

    # complete data
    RF_complete_data <- randomForest(x = training_new_train[, -classe_num], y = training_new_train$classe, 
        xtest = training_new_test[, -classe_num], ytest = training_new_test$classe, 
        ntree = ntrees, keep.forest = T)

    # without highly correlated variables
    RF_uncorrelated <- randomForest(x = training_new_train[, -c(classe_num, cols_rem)], 
        y = training_new_train$classe, xtest = training_new_test[, -c(classe_num, 
            cols_rem)], ytest = training_new_test$classe, ntree = ntrees, keep.forest = T)

    # with the PCA components
    RF_PCA_comps <- randomForest(x = training_new_train_pca[, -classe_num], y = training_new_train$classe, 
        xtest = training_new_test_pca[, -classe_num], ytest = training_new_test$classe, 
        ntree = ntrees, keep.forest = T)

Evaluating the Model
--------------------

Lets examine the Accuracy of the models: 1. Complete data model:
Accuracy = 96.6% 2. Uncorrelated data model: Accuracy = 95.6% 3. PCA
Components model: Accuracy = 82.6%

So we can clearly see that the model with the complete data has the
highest accuracy among the three, so we will use that to make
predictions on the out of sample testing data.

Predictions on Out of Sample Data
---------------------------------

Lets predict on out of sample data using the RF\_complete\_data model:

    predictions <- predict(RF_complete_data, testing_new)

The predictions for the 20 out of sample rows are:

B, A, B, A, A, E, D, B, A, A, B, C, B, A, E, E, A, B, B, B

Conclusion
----------

Lets look the importance of all the variables from our
RF\_complete\_data tree:

    varImpPlot(RF_complete_data, cex = 0.7, pch = 16, main = "Most Important Variables")

![](Practical_Machine_Learning_Project_files/figure-markdown_strict/impvars-1.png)
