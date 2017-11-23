# WEEK 4 #

fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/cameras.csv", method = "curl")
cameraData <- read.csv("./data/cameras.csv")

tolower(names(cameraData)) #all lowercase

splitNames <- strsplit(names(cameraData), "\\.") #split by "."
splitNames[[6]]

firstElement <- function(x){x[1]} #first element of each split fn

sapply(splitNames, firstElement)

sub("\\.","", names(cameraData)) #substitute "." with "" (only the first one)

x <- "checking_it_out"

sub("_", "", x)

gsub("_", "", x) #removes all "_"

## Finding values

grep("Alameda", cameraData$intersection) #position of "Alameda" (0 if it doesn't appear)
grep("Alameda", cameraData$intersection, value = TRUE) #values of rows w/ "Alameda"

table(grepl("Alameda", cameraData$intersection)) #if "Alameda" present or not check

cameraData2 <- cameraData[!grepl("Alameda", cameraData$intersection),] #subset rows without Alameda

library(stringr)
nchar("Bruce Wayne")

substr("Bruce Wayne", 1, 5)

paste("Bruce", "Wayne") #space as sep by default
paste0("Bruce", "Wayne")

str_trim(" as  as a sdda         ") #removes excess spaces from the beginning and the end

# "^i think" will match all rows with "i think" at the start
# "check$" will match all of the strings with "check" at the end of the line

# [Bb][Uu][Ss][Hh] will match all versions of Bush, BUsh, BUSH, etc

# [0-9] [a-z] [A-Z] can be used to denote range of letters [a-zA-Z]

# [^?.]$ anything that does not end in a "." or "?"

# "." means any character Eg: 9.11 will match 9_11, 9/11, 9:11, 9.112

# "|" is OR Eg: flood|fire will match "fireball here", "flood there", "flood fire asdn adasd"

# ^[Gg]ood|[Bb]ad will match "Good heloo here" and "hasdsa bad adasd" but not "asdsad Good asdsad"

# ^([Gg]ood|[Bb]ad) good and bad at the start of the sentence only

# [Gg]eorge( [Ww]\.)? [Bb]ush # Ww is optional cause of the "?" sign, "\" is used to escape special character

# [0-9]* = any number including none of them, [0-9]+ = at least one of the numbers

# {} interval quantifiers, min an max number of matches of an expression

# "[Bb]ush( +[^ ]+ +){1,5} debate" bush<space><not_space><space>debate (middle part max 5 times)
# {m} = exactly m matches, {m,} = atleast m matches, {m,n} = between m and n matches

# \1, \2 can be used to look for already matched text
#  +([a-zA-Z]+) +\1 + = <space><some char><atleast one space> then exact same match as before
# Eg: time for bed night night twitter, blah blah hello

# * is greedy, always matches the longest possible string

# can be turned off by *?


## working with dates

d2 = Sys.Date()


# %d = day as number (0-31), %a = abbreviated weekday, %A = unabbreviated weekday, %m = month(00-12), %b = abbreviated month, %B = unabbreviated month, %y = 2 digit year, %Y = four digit year

format(d2, "%a %b %d") #day month date


x = c("1jan1990", "12may2007", "30jun2014")
z = as.Date(x, "%d%b%Y")

z[3] - z[2] #number of days in between

as.numeric(z[3] - z[2]) #numeric value of interval

weekdays(d2)
months(d2)
julian(d2) #julian date, days since origin


## Lubridate package

library(lubridate)
ymd("20140108")
mdy("08/04/2013")
dmy("03-04-2013")

ymd_hms("2011-08-03 10:15:03")

ymd_hms("2011-08-03 10:15:03", tz = "Pacific/Auckland")

?Sys.timezone


## week 4 assignment

library(data.table)

dt <- data.table(read.csv("./data/Idaho.csv"))
varNames <- names(dt)
varNamesSplit <- strsplit(varNames, "wgtp")
varNamesSplit[[123]]

library(quantmod)
amzn <- getSymbols("AMZN",auto.assign=FALSE)
sampleTimes <- index(amzn) 
table(year(sampleTimes), weekdays(sampleTimes))
