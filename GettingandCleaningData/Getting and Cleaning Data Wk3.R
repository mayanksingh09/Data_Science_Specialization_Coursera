setwd("/Users/mayank/Documents/Coursera/Data Science Specialization")

set.seed(13435)
X <- data.frame("var1"= sample(1:5), "var2"=sample(6:10), "var3"=sample(11:15)) # creating X

X <- X[sample(1:5),]

X$var2[c(1,3)] = NA # setting some values NA

X[,1] #subset a column (1st column)

X[,"var1"] #subset var1

X[1:2, "var2"] #first 2 rows of X in var2

## Subset using logical statements

X[(X$var1 <= 3 & X$var3 > 11),] #and statement

X[(X$var1 <=3 | X$var3 > 15),] #or statement


## Dealing with missing values

X[which(X$var2 > 8),] # removes the rows with NAs

## Sorting

sort(X$var1) #ascending

sort(X$var1, decreasing = TRUE) #descending

sort(X$var2, na.last = TRUE) #NAs at the end
sort(X$var2) #NAs removed usually

## Ordering 
X[order(X$var1),] # sorts all the rows in table with values of var1

X[order(X$var1, X$var3),]

library(plyr)

arrange(X, var1) # with plyr

arrange(X, desc(var1))


## adding rows and columns

X$var4 <- rnorm(5)

Y <- cbind(X, var5 = rnorm(5))


## getting data from web
if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/restaurants.csv", method = "curl")
restData <- read.csv("./data/restaurants.csv")


## quantiles
quantile(restData$councilDistrict)
quantile(restData$councilDistrict, probs = c(0.5, 0.8, 0.9)) #different quantiles

## make tables

table(restData$zipCode) #omits NAs by default
table(restData$zipCode, useNA = "ifany")

table(restData$councilDistrict, restData$zipCode) #2D table


## missing values

sum(is.na(restData$councilDistrict))

any(is.na(restData$councilDistrict))

all(restData$zipCode > 0)

## Row and Column sums

colSums(is.na(restData)) #NAs not removed

all(colSums(is.na(restData)) == 0)

## Values with specific characteristics

table(restData$zipCode %in% c("21212"))

table(restData$zipCode %in% c("21212", "21213"))

restData[restData$zipCode %in% c("21212", "21213"),] #subset the df

## cross tabs

DF = as.data.frame(UCBAdmissions)

summary(DF)

xt <- xtabs(Freq ~ Gender + Admit, data = DF)

warpbreaks$replicate <- rep(1:9, len = 54)

xt = xtabs(breaks ~. , data = warpbreaks)
xt

## flat tables
ftable(xt)

## Size of a dataset

fakeData = rnorm(1e5)
object.size(fakeData)

print(object.size(fakeData), units = "Mb")


## Creating sequences

s1 <- seq(1,10, by = 2)
s1

s2 <- seq(1,10, length = 3) ;s2

x <- c(1,3,8,25, 100)

seq(along = x)


## subsetting variables

restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)

## creating binary variables
restData$zipWrong = ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode < 0)

## creating categorical variables
restData$zipGroups = cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroups)

table(restData$zipGroups, restData$zipCode)

## easier cutting
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode, g = 4)
table(restData$zipGroups)

## creating factor variables

restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]

class(restData$zcf)

## levels of factor variables

yesno <- sample(c("yes", "no"), size = 10, replace = TRUE)
yesnofac = factor(yesno, levels = c("yes", "no"))
relevel(yesnofac, ref = "yes")

as.numeric(yesnofac)

## cutting produces factor variables

## using mutate
library(dplyr)
restData2 = mutate(restData, zipGroups = cut2(zipCode, g = 4))
table(restData2$zipGroups)

## common transforms
x <- 3.454212
abs(x) # absolute value

sqrt(x)

ceiling(x)

floor(x)

round(x, digits = 2)

signif(x, digits = 2)

cos(x)

sin(x)

log(x); log2(x); log10(x)

exp(x)

## Reshaping data
library(reshape2)
head(mtcars)

## melting data frames

mtcars$carname <- rownames(mtcars)

carMelt <- melt(mtcars, id = c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp")) #wide to long
head(carMelt)

cylData <- dcast(carMelt, cyl ~ variable) #by default summarizes the data set for cyl (Default: count)
cylData <- dcast(carMelt, cyl ~ variable, mean)


## Averaging values
head(InsectSprays)

tapply(InsectSprays$count, InsectSprays$spray, sum)

splitInsect <- split(InsectSprays$count, InsectSprays$spray) #counts split by the type of sprays, lists as outputs

sprCount <- lapply(splitInsect, sum) #sum of the lists
unlist(sprCount)  # normal format

sapply(splitInsect, sum) #directly simplifies sum

## using plyr

ddply(InsectSprays, .(spray), summarize, sum = sum(count))

## creating new variable

#spraySums <- ddply(InsectSprays, .(spray), summarize, sum = ave(count, FUN = sum))

## DPLYR

library(dplyr)

chicago <- readRDS("./data/chicago.rds")
head(chicago)
dim(chicago)
names(chicago) # column names

select(chicago, city:dptp) #select from city to dptp column

select(chicago, -(city:dptp)) #all columns except in the range mentioned

chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80) #filters data

chicago <- arrange(chicago, date) #order by date

chicago <- arrange(chicago, desc(date)) #descending order

chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp) #rename col names

chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE)) #creating new column

chicago <- mutate(chicago, tempcat = factor(1* (tmpd > 80), labels = c("cold", "hot"))) #creating new var

hotcold <- group_by(chicago, tempcat) #groupby tempcat

summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2)) #summarize on the group by

chicago %>%
  mutate(month = as.POSIXlt(date)$mon + 1) %>%
  group_by(month) %>%
  summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

## merging data

fileUrl1 <- "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 <- "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"

download.file(fileUrl1, destfile = "./data/reviews.csv", method = "curl")
download.file(fileUrl2, destfile = "./data/solutions.csv", method = "curl")

reviews <- read.csv("./data/reviews.csv"); solutions <- read.csv("./data/solutions.csv")

mergedData <- merge(reviews, solutions, by.x = "solution_id", by.y = "id", all = TRUE) #default merge by common column names

intersect(names(solutions), names(reviews))

mergedData2 <- merge(reviews, solutions, all = TRUE)

## joining using plyr (faster)

df1 <- data.frame(id = sample(1:10), x = rnorm(10))
df2 <- data.frame(id = sample(1:10), y = rnorm(10))

arrange(join(df1, df2), id) #default left join

## for multiple dfs 

df1 <- data.frame(id = sample(1:10), x = rnorm(10))
df2 <- data.frame(id = sample(1:10), y = rnorm(10))
df3 <- data.frame(id = sample(1:10), z = rnorm(10))

dfList = list(df1, df2, df3)
join_all(dfList)

## Week 3 assignment

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

data <- read.csv(fileURL)
summary(data)

agricultureLogical <- (data$ACR == 3 & data$AGS == 6)
which(agricultureLogical)

library(jpeg)
jpegURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg" 
download.file(jpegURL,"jeff.jpg", mode = "wb")

jeff <- readJPEG("jeff.jpg", native = TRUE)
quantile(jeff, probs = c(0.3, 0.8))


GDP <- read.csv("/Users/mayank/Documents/Coursera/Data Science Specialization/data/GDP.csv", header = TRUE)
edu <- read.csv("./data/edu.csv", header = TRUE)


df <- GDP %>%
  merge(edu, all = TRUE, by = c("CountryCode"))

sum(!is.na(unique(df$CountryCode)))


