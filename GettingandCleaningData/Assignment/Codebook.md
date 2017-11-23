Codebook
========
Codebook was generated on 2017-11-23 23:00:09 during the same process that generated the dataset. See `run_analysis.md` or `run_analysis.html` for details on dataset creation.

Variable list and descriptions
------------------------------

Variable name    | Description
-----------------|------------
subject          | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.
activity         | Activity name

domain_ftr       | Feature: Time domain signal or frequency domain signal (Time or Freq)
instrument_ftr   | Feature: Measuring instrument (Accelerometer or Gyroscope)
acceleration_ftr | Feature: Acceleration signal (Body or Gravity)
variable_ftr     | Feature: Variable (Mean or SD)
jerk_ftr         | Feature: Jerk signal
magnitude_ftr    | Feature: Magnitude of the signals calculated using the Euclidean norm
axis_ftr         | Feature: 3-axial signals in the X, Y and Z directions (X, Y, or Z)
count_ftr        | Feature: Count of data points used to compute `average`
average_ftr      | Feature: Average of each variable for each activity and each subject


Dataset structure
-----------------


```r
str(tidy_data)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  11 variables:
##  $ subject         : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity        : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ domain_ftr      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
##  $ acceleration_ftr: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ instrument_ftr  : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ jerk_ftr        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
##  $ magnitude_ftr   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
##  $ variable_ftr    : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 2 1 1 ...
##  $ featAxis        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
##  $ count           : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ average         : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
##  - attr(*, "sorted")= chr  "subject" "activity" "domain_ftr" "acceleration_ftr" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

List the key variables in the data table
----------------------------------------


```r
key(tidy_data)
```

```
## [1] "subject"          "activity"         "domain_ftr"      
## [4] "acceleration_ftr" "instrument_ftr"   "jerk_ftr"        
## [7] "magnitude_ftr"    "variable_ftr"     "featAxis"
```

Show a few rows of the dataset
------------------------------


```r
tidy_data
```

```
##        subject         activity domain_ftr acceleration_ftr instrument_ftr
##     1:       1           LAYING       Time               NA      Gyroscope
##     2:       1           LAYING       Time               NA      Gyroscope
##     3:       1           LAYING       Time               NA      Gyroscope
##     4:       1           LAYING       Time               NA      Gyroscope
##     5:       1           LAYING       Time               NA      Gyroscope
##    ---                                                                    
## 11876:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11877:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11878:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11879:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11880:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
##        jerk_ftr magnitude_ftr variable_ftr featAxis count     average
##     1:       NA            NA         Mean        X    50 -0.01655309
##     2:       NA            NA         Mean        Y    50 -0.06448612
##     3:       NA            NA         Mean        Z    50  0.14868944
##     4:       NA            NA           SD        X    50 -0.87354387
##     5:       NA            NA           SD        Y    50 -0.95109044
##    ---                                                               
## 11876:     Jerk            NA           SD        X    65 -0.56156521
## 11877:     Jerk            NA           SD        Y    65 -0.61082660
## 11878:     Jerk            NA           SD        Z    65 -0.78475388
## 11879:     Jerk     Magnitude         Mean       NA    65 -0.54978489
## 11880:     Jerk     Magnitude           SD       NA    65 -0.58087813
```

Summary of variables
--------------------


```r
summary(tidy_data)
```

```
##     subject                   activity    domain_ftr  acceleration_ftr
##  Min.   : 1.0   LAYING            :1980   Time:7200   NA     :4680    
##  1st Qu.: 8.0   SITTING           :1980   Freq:4680   Body   :5760    
##  Median :15.5   STANDING          :1980               Gravity:1440    
##  Mean   :15.5   WALKING           :1980                               
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                               
##  Max.   :30.0   WALKING_UPSTAIRS  :1980                               
##        instrument_ftr jerk_ftr      magnitude_ftr  variable_ftr featAxis 
##  Accelerometer:7200   NA  :7200   NA       :8640   Mean:5940    NA:3240  
##  Gyroscope    :4680   Jerk:4680   Magnitude:3240   SD  :5940    X :2880  
##                                                                 Y :2880  
##                                                                 Z :2880  
##                                                                          
##                                                                          
##      count          average        
##  Min.   :36.00   Min.   :-0.99767  
##  1st Qu.:49.00   1st Qu.:-0.96205  
##  Median :54.50   Median :-0.46989  
##  Mean   :57.22   Mean   :-0.48436  
##  3rd Qu.:63.25   3rd Qu.:-0.07836  
##  Max.   :95.00   Max.   : 0.97451
```

List all possible combinations of features
------------------------------------------


```r
tidy_data[, .N, by=c(names(tidy_data)[grep("^feat", names(tidy_data))])]
```

```
##    featAxis    N
## 1:        X 2880
## 2:        Y 2880
## 3:        Z 2880
## 4:       NA 3240
```
